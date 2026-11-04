import 'package:shopping_app_task/core/error/api_failure.dart';
import 'package:shopping_app_task/core/result/either.dart';
import 'package:shopping_app_task/core/result/repository_result.dart';
import 'package:shopping_app_task/features/products_home/domain/repo/products_home_repo.dart';
import 'package:shopping_app_task/features/products_home/data/data_source/products_home_api_service.dart';
import 'package:shopping_app_task/core/storage/local_store.dart';
import 'package:shopping_app_task/features/products_home/domain/entities/product_entity.dart';
import 'package:shopping_app_task/features/products_home/domain/entities/category_entity.dart';
import 'package:shopping_app_task/features/products_home/domain/entities/product_page_entity.dart';

class ProductsHomeRepoImp implements ProductsHomeRepository {
  ProductsHomeRepoImp(this.productsApi, this.localStore);
  final ProductsHomeApiService productsApi;
  final LocalStore localStore;

  @override
  Future<Either<ApiFailure, ProductPage>> loadProducts({
    int skip = 0,
    String query = '',
    String? category,
  }) async {
    final response = await repositoryResult(
      () => productsApi.products(skip: skip, query: query, category: category),
      failureMessage:
          'Could not load products or read the cache. Please retry.',
    );
    return response.fold<Future<Either<ApiFailure, ProductPage>>>(
      (failure) async {
        if (failure is UnexpectedFailure) return Left(failure);
        final cachedResponse = await repositoryResult(
          localStore.products,
          failureMessage:
              'Could not load products or read the cache. Please retry.',
        );
        return cachedResponse.fold((cacheFailure) => Left(cacheFailure), (
          cachedProducts,
        ) {
          final matches = cachedProducts
              .where(
                (product) =>
                    product.title.toLowerCase().contains(query.toLowerCase()) &&
                    (category == null || product.category == category),
              )
              .toList();
          return Right(
            ProductPage(
              matches,
              total: matches.length,
              nextSkip: matches.length,
              cached: true,
              notice: '${failure.message} Cached results may be incomplete.',
            ),
          );
        });
      },
      (pageModel) async {
        final productsPage = pageModel.toEntity();
        final cacheResponse = await repositoryResult(
          () => localStore.cacheProducts(productsPage.products),
          failureMessage:
              'Products loaded, but could not be saved for offline use.',
        );
        return cacheResponse.fold(
          (failure) => Right(
            ProductPage(
              productsPage.products,
              total: productsPage.total,
              nextSkip: productsPage.nextSkip,
              notice: failure.message,
            ),
          ),
          (_) => Right(productsPage),
        );
      },
    );
  }

  @override
  Future<Either<ApiFailure, (List<Category>, String?)>> loadCategories() async {
    final response = await repositoryResult(
      productsApi.categories,
      failureMessage: 'Could not load categories. Please retry.',
    );
    return response.fold<Future<Either<ApiFailure, (List<Category>, String?)>>>(
      (failure) async {
        if (failure is UnexpectedFailure) return Left(failure);
        final cachedResponse = await repositoryResult(
          localStore.categories,
          failureMessage: 'Could not load categories. Please retry.',
        );
        return cachedResponse.fold(
          (cacheFailure) => Left(cacheFailure),
          (categories) => Right((
            categories,
            'Showing cached categories. Retry to refresh.',
          )),
        );
      },
      (categoryModels) async {
        final categories = categoryModels
            .map((categoryModel) => categoryModel.toEntity())
            .toList();
        final cacheResponse = await repositoryResult(
          () => localStore.cacheCategories(categories),
          failureMessage: 'Categories could not be saved for offline use.',
        );
        return cacheResponse.fold(
          (failure) => Right((categories, failure.message)),
          (_) => Right((categories, null)),
        );
      },
    );
  }

  @override
  Future<Either<ApiFailure, (Product, String?)>> loadProductDetails(
    int productId,
  ) async {
    final response = await repositoryResult(
      () => productsApi.product(productId),
      failureMessage: 'Could not load this product. Please retry.',
    );
    return response.fold<Future<Either<ApiFailure, (Product, String?)>>>(
      (failure) async {
        if (failure is UnexpectedFailure) return Left(failure);
        final cachedResponse = await repositoryResult(
          localStore.products,
          failureMessage: 'Could not load this product. Please retry.',
        );
        return cachedResponse.fold((cacheFailure) => Left(cacheFailure), (
          cachedProducts,
        ) {
          final matches = cachedProducts.where(
            (product) => product.id == productId,
          );
          if (matches.isEmpty) return Left(failure);
          return Right((
            matches.first,
            '${failure.message} Showing cached product and stock.',
          ));
        });
      },
      (productModel) async {
        final product = productModel.toEntity();
        final cacheResponse = await repositoryResult(
          () => localStore.cacheProducts([product]),
          failureMessage: 'Product could not be saved for offline use.',
        );
        return cacheResponse.fold(
          (failure) => Right((product, failure.message)),
          (_) => Right((product, null)),
        );
      },
    );
  }
}
