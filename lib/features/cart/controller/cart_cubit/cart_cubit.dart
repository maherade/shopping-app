import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app_task/core/pricing/cart_calculator.dart';
import 'package:shopping_app_task/features/auth/domain/entities/session_entity.dart';
import 'package:shopping_app_task/features/products_home/domain/entities/product_entity.dart';
import 'package:shopping_app_task/features/cart/domain/entities/cart_item_entity.dart';
import 'package:shopping_app_task/features/cart/domain/repo/cart_repo.dart';
part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit(
    this.repository, {
    DateTime Function()? now,
    bool Function()? isSessionActive,
  }) : now = now ?? DateTime.now,
       isSessionActive = isSessionActive ?? (() => true),
       super(CartInitial());
  final CartRepository repository;
  final DateTime Function() now;
  final bool Function() isSessionActive;
  Session? activeSession;
  List<CartItem> cartItems = const [];
  bool busy = false, submitting = false, ready = false;
  String? error, message;

  /// Counts all units in the cart
  int get quantity => cartItems.fold(0, (total, item) => total + item.quantity);

  /// Calculates cart prices and delivery
  CartTotals get totals => CartCalculator.calculate(cartItems);
  int requestGeneration = 0;
  int? addingProductId;

  /// Checks whether this request is current
  bool isCurrentGeneration(int generation) =>
      !isClosed && generation == requestGeneration && isSessionActive();

  /// Loads the current user's saved cart
  Future<void> loadCartForSession(Session? session) async {
    final generation = ++requestGeneration;
    activeSession = session;
    cartItems = const [];
    addingProductId = null;
    submitting = ready = false;
    error = message = null;
    busy = session != null;
    if (session == null) {
      emit(CartInitial());
      return;
    }
    emit(CartLoading());
    final response = await repository.loadCart(session.profile.id);
    if (!isCurrentGeneration(generation)) return;
    response.fold(
      (failure) {
        busy = false;
        error = failure.message;
        emit(CartError());
      },
      (items) {
        try {
          CartCalculator.calculate(items);
          cartItems = List.unmodifiable(items);
          busy = false;
          ready = true;
          emit(CartSuccess());
        } catch (_) {
          busy = false;
          error = 'Could not restore your cart. Retry before making changes ';
          emit(CartError());
        }
      },
    );
  }

  /// Retries loading the active user's cart
  Future<void> reloadCart() => loadCartForSession(activeSession);

  /// Validates and persists a cart change
  Future<void> applyCartChange(
    List<CartItem> Function(List<CartItem>) change, {
    int? productId,
  }) async {
    final session = activeSession;
    if (session == null || busy || !ready || !isSessionActive()) return;
    final generation = requestGeneration;
    busy = true;
    addingProductId = productId;
    submitting = false;
    error = message = null;
    emit(CartLoading());
    try {
      final updatedItems = change(cartItems);
      CartCalculator.calculate(updatedItems);
      final response = await repository.saveCart(
        session.profile.id,
        updatedItems,
      );
      if (!isCurrentGeneration(generation)) return;
      response.fold(
        (failure) {
          busy = false;
          addingProductId = null;
          error = failure.message;
          emit(CartError());
        },
        (_) {
          cartItems = List.unmodifiable(updatedItems);
          busy = false;
          addingProductId = null;
          emit(CartSuccess());
        },
      );
    } on ArgumentError catch (validationError) {
      if (isCurrentGeneration(generation)) {
        busy = false;
        addingProductId = null;
        error = validationError.message.toString();
        emit(CartError());
      }
    } catch (_) {
      if (isCurrentGeneration(generation)) {
        busy = false;
        addingProductId = null;
        error =
            'Could not save your cart  No changes were applied, Please retry';
        emit(CartError());
      }
    }
  }

  /// Counts units still available to add
  int remainingStock(Product product) {
    final quantity = cartItems
        .where((item) => item.product.id == product.id)
        .fold(0, (quantity, item) => quantity + item.quantity);
    final remaining = product.stock - quantity;
    return remaining > 0 ? remaining : 0;
  }

  /// Checks whether another unit can be added
  bool isProductAvailableToAdd(Product product) =>
      ready &&
      !busy &&
      activeSession != null &&
      isSessionActive() &&
      remainingStock(product) > 0;

  /// Adds or merges a product quantity
  Future<void> addToCart(Product product, int quantity) => applyCartChange((
    items,
  ) {
    CartCalculator.validate(product, quantity);
    final matchingItems = items.where((item) => item.product.id == product.id);
    final totalQuantity =
        quantity + (matchingItems.isEmpty ? 0 : matchingItems.first.quantity);
    CartCalculator.validate(product, totalQuantity);
    return [
      ...items.where((item) => item.product.id != product.id),
      CartItem(product, totalQuantity),
    ];
  }, productId: product.id);

  /// Updates a cart item's quantity
  Future<void> updateItemQuantity(
    int productId,
    int quantity,
  ) => applyCartChange(
    (items) => items
        .map(
          (item) =>
              item.product.id == productId ? item.withQuantity(quantity) : item,
        )
        .toList(),
  );

  /// Removes a product from the cart
  Future<void> removeFromCart(int productId) => applyCartChange(
    (items) => items.where((item) => item.product.id != productId).toList(),
  );

  /// Removes all saved cart items
  Future<void> clearCart() => applyCartChange((_) => []);

  /// Submits order online
  Future<void> submitOrder() async {
    final session = activeSession;
    if (session == null || busy || !ready || !isSessionActive()) return;
    error = message = null;
    if (cartItems.isEmpty) {
      error = 'Add products before submitting.';
      emit(CartError());
      return;
    }
    if (!session.validAt(now())) {
      error = 'Your session expired. Sign in again to submit.';
      emit(CartError());
      return;
    }
    final generation = requestGeneration;
    final items = cartItems;
    try {
      CartCalculator.calculate(items);
    } on ArgumentError catch (validationError) {
      error = validationError.message.toString();
      emit(CartError());
      return;
    }
    busy = submitting = true;
    emit(CartSubmitting());
    final response = await repository.submitOrder(session, items);
    if (!isCurrentGeneration(generation)) return;
    await response.fold<Future<void>>(
      (failure) async {
        busy = submitting = false;
        error = failure.message;
        emit(CartError());
      },
      (orderId) async {
        final persistence = await repository.saveCart(session.profile.id, []);
        if (!isCurrentGeneration(generation)) return;
        persistence.fold(
          (failure) {
            busy = submitting = false;
            error =
                'Simulated order #$orderId succeeded, but the local cart could not be cleared. Clear it manually; do not resubmit.';
            emit(CartError());
          },
          (_) {
            cartItems = const [];
            busy = submitting = false;
            message =
                'Simulated order #$orderId confirmed. No real purchase was made.';
            emit(CartSuccess());
          },
        );
      },
    );
  }

  /// Invalidates pending requests and closes the Cubit
  @override
  Future<void> close() {
    ++requestGeneration;
    return super.close();
  }
}
