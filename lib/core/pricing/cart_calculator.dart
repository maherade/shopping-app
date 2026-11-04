import 'package:shopping_app_task/features/cart/domain/entities/cart_item_entity.dart';
import 'package:shopping_app_task/features/products_home/domain/entities/product_entity.dart';

class CartTotals {
  const CartTotals(this.subtotal, this.delivery);
  final int subtotal, delivery;

  int get total => subtotal + delivery;
}

class CartCalculator {
  static int unitCents(Product product) {
    if (!product.price.isFinite ||
        product.price < 0 ||
        !product.discount.isFinite ||
        product.discount < 0 ||
        product.discount > 100) {
      throw ArgumentError('Invalid product price or discount.');
    }
    return (product.price * (100 - product.discount) + 1e-9).round();
  }

  /// Checks product stock, quantity, and pricing
  static void validate(Product product, int quantity) {
    if (quantity < 1) throw ArgumentError('Quantity must be at least 1.');
    if (product.stock <= 0) {
      throw ArgumentError('This product is out of stock.');
    }
    if (quantity > product.stock) {
      throw ArgumentError('Only ${product.stock} available.');
    }
    unitCents(product);
  }

  /// Calculates subtotal, delivery, and total
  static CartTotals calculate(List<CartItem> items) {
    var subtotal = 0;
    for (final item in items) {
      validate(item.product, item.quantity);
      subtotal += unitCents(item.product) * item.quantity;
    }
    return CartTotals(subtotal, subtotal > 0 && subtotal < 20000 ? 1000 : 0);
  }

  /// Formats cents with two decimal places
  static String money(int cents) => (cents / 100).toStringAsFixed(2);
}
