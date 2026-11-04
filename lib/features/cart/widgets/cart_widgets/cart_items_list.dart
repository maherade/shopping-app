import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopping_app_task/features/cart/domain/entities/cart_item_entity.dart';
import 'package:shopping_app_task/features/cart/widgets/cart_widgets/cart_item_tile.dart';

class CartItemsList extends StatelessWidget {
  const CartItemsList({
    super.key,
    required this.items,
    required this.busy,
    required this.onRemove,
    required this.onQuantityChanged,
  });
  final List<CartItem> items;
  final bool busy;
  final ValueChanged<int> onRemove;
  final void Function(int productId, int quantity) onQuantityChanged;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      for (final item in items)
        Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: CartItemTile(
            item: item,
            busy: busy,
            onRemove: () => onRemove(item.product.id),
            onQuantityChanged: (quantity) =>
                onQuantityChanged(item.product.id, quantity),
          ),
        ),
    ],
  );
}
