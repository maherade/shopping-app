import 'package:shopping_app_task/features/products_home/domain/entities/product_entity.dart';

class ProductPage {
  ProductPage(
    List<Product> products, {
    required this.total,
    required this.nextSkip,
    this.cached = false,
    this.notice,
  }) : products = List.unmodifiable(products);
  final List<Product> products;
  final int total, nextSkip;
  final bool cached;
  final String? notice;

  bool get hasMore => !cached && products.isNotEmpty && nextSkip < total;
}
