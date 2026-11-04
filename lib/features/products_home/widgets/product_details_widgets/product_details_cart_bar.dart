import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cart/controller/cart_cubit/cart_cubit.dart';
import '../../controller/product_details_cubit/product_details_cubit.dart';
import '../../domain/entities/product_entity.dart';

class ProductDetailsCartBar extends StatelessWidget {
  final Product product;

  const ProductDetailsCartBar({super.key, required this.product});

  @override
  Widget build(BuildContext context) => BlocBuilder<CartCubit, CartState>(
    builder: (context, state) {
      final theme = Theme.of(context);
      final cart = context.read<CartCubit>();
      final details = context.watch<ProductDetailsCubit>();
      final remaining = cart.remainingStock(product);
      final selectedQuantity = remaining > 0 && details.quantity > remaining
          ? remaining
          : details.quantity;
      final canAdd = cart.isProductAvailableToAdd(product);
      final adding = cart.busy && cart.addingProductId == product.id;
      return Material(
        color: theme.colorScheme.surface,
        elevation: 8,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                    onPressed: canAdd
                        ? () async {
                            final cart = context.read<CartCubit>();
                            if (!cart.isProductAvailableToAdd(product)) return;
                            final generation = cart.requestGeneration;
                            await cart.addToCart(product, selectedQuantity);
                            if (!context.mounted) return;
                            if (!cart.isCurrentGeneration(generation)) return;
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  content: Text(
                                    cart.error ?? 'Added to your cart',
                                  ),
                                ),
                              );
                          }
                        : null,
                    icon: adding
                        ? SizedBox.square(
                            dimension: 20.r,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.add_shopping_cart_rounded),
                    label: Text(
                      product.stock <= 0
                          ? 'Out of stock'
                          : remaining == 0
                          ? 'All available stock is in your cart'
                          : 'Add to cart',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
