import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app_task/features/products_home/domain/repo/products_home_repo.dart';
import 'package:shopping_app_task/features/products_home/domain/entities/product_entity.dart';
part 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  /// Creates the product details cubit.
  ProductDetailsCubit(this.repository, this.productId)
    : super(ProductDetailsInitial());
  final ProductsHomeRepository repository;
  final int productId;
  Product? product;
  int quantity = 1;
  bool loading = true;
  String? notice, error;
  int requestGeneration = 0;

  /// Updates the selected cart quantity.
  void updateQuantity(int quantity) {
    this.quantity = quantity;
    emit(ProductDetailsSuccess());
  }

  /// Loads product details with cache fallback.
  Future<void> loadProductDetails() async {
    final generation = ++requestGeneration;
    loading = true;
    error = null;
    emit(ProductDetailsLoading());
    final response = await repository.loadProductDetails(productId);
    if (isClosed || generation != requestGeneration) return;
    response.fold(
      (failure) {
        loading = false;
        error = failure.message;
        emit(ProductDetailsError());
      },
      (details) {
        final (loadedProduct, cacheNotice) = details;
        product = loadedProduct;
        notice = cacheNotice;
        error = null;
        loading = false;
        emit(ProductDetailsSuccess());
      },
    );
  }

  /// Invalidates pending requests and closes the Cubit.
  @override
  Future<void> close() {
    ++requestGeneration;
    return super.close();
  }
}
