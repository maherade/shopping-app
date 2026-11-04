import 'package:shopping_app_task/core/error/api_failure.dart';
import 'package:shopping_app_task/core/result/either.dart';
import 'package:shopping_app_task/features/products_home/domain/entities/product_entity.dart';
import 'package:shopping_app_task/features/products_home/domain/entities/category_entity.dart';
import 'package:shopping_app_task/features/products_home/domain/entities/product_page_entity.dart';

abstract interface class ProductsHomeRepository {
  Future<Either<ApiFailure, ProductPage>> loadProducts({
    int skip = 0,
    String query = '',
    String? category,
  });

  Future<Either<ApiFailure, (List<Category>, String?)>> loadCategories();

  Future<Either<ApiFailure, (Product, String?)>> loadProductDetails(
    int productId,
  );
}
