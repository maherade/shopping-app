import 'package:shopping_app_task/features/products_home/domain/entities/category_entity.dart';

class CategoryModel extends Category {
  const CategoryModel(super.slug, super.name);

  factory CategoryModel.fromJson(dynamic json) => json is String
      ? CategoryModel(json, json)
      : CategoryModel(
          json['slug'] as String,
          json['name'] as String? ?? json['slug'] as String,
        );

  Map<String, dynamic> toJson() => {'slug': slug, 'name': name};

  factory CategoryModel.fromEntity(Category value) =>
      CategoryModel(value.slug, value.name);

  Category toEntity() => Category(slug, name);
}
