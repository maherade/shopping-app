import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app_task/core/pricing/cart_calculator.dart';
import 'package:shopping_app_task/core/widgets/shop_widgets.dart';
import 'package:shopping_app_task/features/cart/domain/entities/cart_item_entity.dart';

class CartItemTile extends StatelessWidget {
  const CartItemTile({
    super.key,
    required this.item,
    required this.busy,
    required this.onRemove,
    required this.onQuantityChanged,
  });
  final CartItem item;
  final bool busy;
  final VoidCallback onRemove;
  final ValueChanged<int> onQuantityChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final product = item.product;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: colors.outlineVariant.withValues(alpha: .65)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 76.r,
                height: 76.r,
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: ProductImage(
                  product.thumbnail,
                  height: 60.r,
                  width: 60.r,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                    if (product.category.isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      Text(
                        product.category.replaceAll('-', ' '),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                    SizedBox(height: 6.h),
                    Text(
                      '${product.stock} available',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 6.h,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                '\$${CartCalculator.money(CartCalculator.unitCents(product))}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (product.discount > 0) ...[
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: colors.primaryContainer.withValues(alpha: .55),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    '${product.discount.toStringAsFixed(2)}% off',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 14.h),
          Divider(
            height: 1,
            color: colors.outlineVariant.withValues(alpha: .5),
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Theme(
                data: theme.copyWith(
                  iconButtonTheme: IconButtonThemeData(
                    style: IconButton.styleFrom(
                      foregroundColor: colors.primary,
                    ),
                  ),
                ),
                child: QuantitySelector(
                  quantity: item.quantity,
                  maximum: product.stock,
                  enabled: !busy,
                  onChanged: onQuantityChanged,
                ),
              ),
              IconButton.outlined(
                onPressed: busy ? null : onRemove,
                style: IconButton.styleFrom(
                  foregroundColor: colors.onSurfaceVariant,
                  side: BorderSide(color: colors.outlineVariant),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                icon: Icon(Icons.delete_outline, size: 20.r, color: Colors.red),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'Line total: \$${CartCalculator.money(CartCalculator.unitCents(product) * item.quantity)}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
