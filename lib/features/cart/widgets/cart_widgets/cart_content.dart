import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopping_app_task/features/cart/controller/cart_cubit/cart_cubit.dart';
import 'package:shopping_app_task/features/cart/widgets/cart_widgets/cart_empty_state.dart';
import 'package:shopping_app_task/features/cart/widgets/cart_widgets/cart_products_section.dart';

class CartContent extends StatelessWidget {
  const CartContent({super.key, required this.onContinueShopping});
  final VoidCallback onContinueShopping;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CartCubit>();
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1080),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (cubit.ready && cubit.cartItems.isEmpty)
                CartEmptyState(onContinueShopping: onContinueShopping),
              if (cubit.cartItems.isNotEmpty) const CartProductsSection(),
            ],
          ),
        ),
      ),
    );
  }
}
