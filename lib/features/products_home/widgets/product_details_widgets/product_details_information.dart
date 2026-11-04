import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/pricing/cart_calculator.dart';
import '../../../../core/widgets/shop_widgets.dart';
import '../../../cart/controller/cart_cubit/cart_cubit.dart';
import '../../controller/product_details_cubit/product_details_cubit.dart';
import '../../domain/entities/product_entity.dart';

class ProductDetailsInformation extends StatelessWidget {
  final Product product;

  const ProductDetailsInformation({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cart = context.watch<CartCubit>();
    final details = context.watch<ProductDetailsCubit>();
    final remaining = cart.remainingStock(product);
    final selectedQuantity = remaining > 0 && details.quantity > remaining
        ? remaining
        : details.quantity;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// category
        Text(
          product.category.replaceAll('-', ' ').toUpperCase(),
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.primary,
            letterSpacing: 1,
          ),
        ),
        SizedBox(height: 8.h),

        /// product name
        Text(
          product.title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 12.h),

        /// price with discount
        Wrap(
          spacing: 12.w,
          runSpacing: 8.h,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              '\$${CartCalculator.money(CartCalculator.unitCents(product))}',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
            if (product.discount > 0) ...[
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  '${product.discount.toStringAsFixed(0)}% off',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: 16.h),

        /// rating
        Wrap(
          spacing: 16.w,
          runSpacing: 8.h,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star_rounded, color: Colors.orange, size: 20.r),
                SizedBox(width: 4.w),
                Text(
                  '${product.rating.toStringAsFixed(1)} / 5',
                  semanticsLabel:
                      'Rated ${product.rating.toStringAsFixed(1)} out of 5',
                ),
              ],
            ),
            Text(
              product.stock > 0 ? '${product.stock} in stock' : 'Out of stock',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: product.stock > 0
                    ? theme.colorScheme.primary
                    : theme.colorScheme.error,
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),
        Wrap(
          spacing: 16.w,
          runSpacing: 8.h,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text('Quantity', style: theme.textTheme.titleMedium),
            QuantitySelector(
              quantity: selectedQuantity,
              maximum: remaining,
              enabled: cart.isProductAvailableToAdd(product),
              onChanged: details.updateQuantity,
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: const Divider(),
        ),

        /// product descriptions
        Text(
          'About this product',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          product.description.isEmpty
              ? 'No description available.'
              : product.description,
          style: theme.textTheme.bodyLarge?.copyWith(
            height: 1.6,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
