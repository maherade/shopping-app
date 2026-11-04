import 'package:shopping_app_task/core/helper/dio/end_points.dart';
import 'package:shopping_app_task/core/helper/api/api_helper.dart';
import 'package:shopping_app_task/features/products_home/data/models/product_model.dart';
import 'package:shopping_app_task/features/products_home/data/models/category_model.dart';
import 'package:shopping_app_task/features/products_home/data/models/product_page_model.dart';

abstract interface class ProductsHomeApiService {
  Future<ProductPageModel> products({
    required int skip,
    String query = '',
    String? category,
  });

  Future<List<CategoryModel>> categories();

  Future<ProductModel> product(int id);
}

class DioProductsHomeApiService implements ProductsHomeApiService {
  DioProductsHomeApiService(this.client);
  final ApiHelper client;

  @override
  Future<ProductPageModel> products({
    required int skip,
    String query = '',
    String? category,
  }) => client.parse(() async {
    final path = query.isNotEmpty
        ? EndPoints.searchProducts
        : category != null
        ? EndPoints.categoryProducts(category)
        : EndPoints.products;
    final json = (await client.getData<Map<String, dynamic>>(
      url: path,
      query: {'limit': 20, 'skip': skip, if (query.isNotEmpty) 'q': query},
    )).data!;
    return ProductPageModel.fromJson(json);
  });

  @override
  Future<List<CategoryModel>> categories() => client.parse(
    () async => (await client.getData<List<dynamic>>(
      url: EndPoints.categories,
    )).data!.map(CategoryModel.fromJson).toList(),
  );

  @override
  Future<ProductModel> product(int id) => client.parse(
    () async => ProductModel.fromJson(
      (await client.getData<Map<String, dynamic>>(
        url: EndPoints.product(id),
      )).data!,
    ),
  );
}
