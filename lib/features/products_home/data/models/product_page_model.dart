import 'package:shopping_app_task/features/products_home/domain/entities/product_page_entity.dart';
import 'package:shopping_app_task/features/products_home/data/models/product_model.dart';

class ProductPageModel extends ProductPage {
  ProductPageModel(
    super.products, {
    required super.total,
    required super.nextSkip,
    super.cached,
    super.notice,
  });

  factory ProductPageModel.fromJson(Map<String, dynamic> json) {
    final products = (json['products'] as List)
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return ProductPageModel(
      products,
      total: (json['total'] as num).toInt(),
      nextSkip: (json['skip'] as num).toInt() + products.length,
    );
  }

  factory ProductPageModel.fromEntity(ProductPage value) => ProductPageModel(
    value.products.map(ProductModel.fromEntity).toList(),
    total: value.total,
    nextSkip: value.nextSkip,
    cached: value.cached,
    notice: value.notice,
  );

  ProductPage toEntity() => ProductPage(
    products.map((p) => ProductModel.fromEntity(p).toEntity()).toList(),
    total: total,
    nextSkip: nextSkip,
    cached: cached,
    notice: notice,
  );
}
