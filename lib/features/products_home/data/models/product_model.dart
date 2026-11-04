import 'package:shopping_app_task/features/products_home/domain/entities/product_entity.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.title,
    super.description,
    super.category,
    super.price,
    super.discount,
    super.rating,
    super.stock,
    super.thumbnail,
    super.images,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final id = (json['id'] as num?)?.toInt();
    if (id == null || id <= 0) {
      throw const FormatException('Missing product ID');
    }

    double number(String key) => (json[key] as num?)?.toDouble() ?? 0;
    return ProductModel(
      id: id,
      title: json['title'] as String? ?? 'Untitled product',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      price: number('price'),
      discount: number('discountPercentage'),
      rating: number('rating'),
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      thumbnail: json['thumbnail'] as String? ?? '',
      images: List.unmodifiable(
        (json['images'] as List? ?? []).whereType<String>(),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'category': category,
    'price': price,
    'discountPercentage': discount,
    'rating': rating,
    'stock': stock,
    'thumbnail': thumbnail,
    'images': images,
  };

  factory ProductModel.fromEntity(Product value) => ProductModel(
    id: value.id,
    title: value.title,
    description: value.description,
    category: value.category,
    price: value.price,
    discount: value.discount,
    rating: value.rating,
    stock: value.stock,
    thumbnail: value.thumbnail,
    images: value.images,
  );

  Product toEntity() => Product(
    id: id,
    title: title,
    description: description,
    category: category,
    price: price,
    discount: discount,
    rating: rating,
    stock: stock,
    thumbnail: thumbnail,
    images: images,
  );
}
