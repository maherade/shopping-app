import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopping_app_task/features/cart/controller/cart_cubit/cart_cubit.dart';
import 'package:shopping_app_task/features/cart/widgets/cart_widgets/cart_header.dart';
import 'package:shopping_app_task/features/cart/widgets/cart_widgets/cart_items_list.dart';
import 'package:shopping_app_task/features/cart/widgets/cart_widgets/cart_order_summary.dart';

class CartProductsSection extends StatelessWidget {
  const CartProductsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<CartCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CartHeader(
          onClear: cubit.busy || !cubit.ready ? null : cubit.clearCart,
        ),
        SizedBox(height: 20.h),
        LayoutBuilder(
          builder: (context, constraints) {
            final items = CartItemsList(
              items: cubit.cartItems,
              busy: cubit.busy,
              onRemove: cubit.removeFromCart,
              onQuantityChanged: cubit.updateItemQuantity,
            );
            final summary = CartOrderSummary(
              totals: cubit.totals,
              quantity: cubit.quantity,
            );
            if (constraints.maxWidth >= 760) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: items),
                  SizedBox(width: 24.w),
                  Expanded(flex: 2, child: summary),
                ],
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                items,
                SizedBox(height: 8.h),
                summary,
              ],
            );
          },
        ),
        SizedBox(height: 12.h),
      ],
    );
  }
}
