import 'package:shopping_app_task/features/products_home/domain/entities/product_entity.dart';

class CartItem {
  const CartItem(this.product, this.quantity);
  final Product product;
  final int quantity;

  CartItem withQuantity(int value) => CartItem(product, value);
}
