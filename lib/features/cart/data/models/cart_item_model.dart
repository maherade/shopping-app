import 'package:shopping_app_task/features/cart/domain/entities/cart_item_entity.dart';
import 'package:shopping_app_task/features/products_home/data/models/product_model.dart';

class CartItemModel extends CartItem {
  const CartItemModel(super.product, super.quantity);

  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
    ProductModel.fromJson(json['product'] as Map<String, dynamic>).toEntity(),
    (json['quantity'] as num).toInt(),
  );

  factory CartItemModel.fromEntity(CartItem value) =>
      CartItemModel(value.product, value.quantity);

  Map<String, dynamic> toJson() => {
    'product': ProductModel.fromEntity(product).toJson(),
    'quantity': quantity,
  };

  CartItem toEntity() =>
      CartItem(ProductModel.fromEntity(product).toEntity(), quantity);
}
