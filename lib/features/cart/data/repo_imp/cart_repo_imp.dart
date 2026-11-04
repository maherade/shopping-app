import 'package:shopping_app_task/core/error/api_failure.dart';
import 'package:shopping_app_task/core/result/either.dart';
import 'package:shopping_app_task/core/result/repository_result.dart';
import 'package:shopping_app_task/features/cart/domain/repo/cart_repo.dart';
import 'package:shopping_app_task/features/cart/data/data_source/cart_api_service.dart';
import 'package:shopping_app_task/core/storage/local_store.dart';
import 'package:shopping_app_task/features/cart/domain/entities/cart_item_entity.dart';
import 'package:shopping_app_task/features/auth/domain/entities/session_entity.dart';

class CartRepoImp implements CartRepository {
  CartRepoImp(this.localStore, this.cartApi);
  final LocalStore localStore;
  final CartApiService cartApi;

  @override
  Future<Either<ApiFailure, List<CartItem>>> loadCart(int userId) async {
    final response = await repositoryResult(
      () => localStore.cart(userId),
      failureMessage:
          'Could not restore your cart. Retry before making changes.',
    );
    return response.fold((failure) => Left(failure), (items) => Right(items));
  }

  @override
  Future<Either<ApiFailure, void>> saveCart(
    int userId,
    List<CartItem> items,
  ) async {
    final response = await repositoryResult(
      () => localStore.saveCart(userId, items),
      failureMessage:
          'Could not save your cart. No changes were applied. Please retry.',
    );
    return response.fold((failure) => Left(failure), (_) => const Right(null));
  }

  @override
  Future<Either<ApiFailure, int>> submitOrder(
    Session session,
    List<CartItem> items,
  ) async {
    final response = await repositoryResult(
      () => cartApi.submitOrder(session, items),
      failureMessage:
          'Could not submit the cart. Your items were kept. Please retry.',
    );
    return response.fold(
      (failure) => Left(failure),
      (orderId) => Right(orderId),
    );
  }
}
