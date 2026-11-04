import 'package:shopping_app_task/features/cart/widgets/cart_widgets/cart_order_success_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app_task/features/cart/controller/cart_cubit/cart_cubit.dart';
import 'package:shopping_app_task/features/cart/widgets/cart_widgets/cart_checkout_bar.dart';
import 'package:shopping_app_task/features/cart/widgets/cart_widgets/cart_content.dart';

class CartScreenBody extends StatelessWidget {
  const CartScreenBody({super.key, required this.onContinueShopping});
  final VoidCallback onContinueShopping;

  @override
  Widget build(BuildContext context) => SafeArea(
    bottom: false,
    child: BlocConsumer<CartCubit, CartState>(
      listenWhen: (previous, current) =>
          previous is CartSubmitting && current is! CartSubmitting,
      listener: (context, state) {
        final cubit = context.read<CartCubit>();
        if (state is CartSuccess && cubit.message != null) {
          showDialog<void>(
            context: context,
            useRootNavigator: false,
            barrierDismissible: false,
            builder: (dialogContext) => CartOrderSuccessDialog(
              onContinueShopping: () {
                Navigator.of(dialogContext).pop();
                onContinueShopping();
              },
            ),
          );
        } else if (cubit.error != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(cubit.error!)));
        }
      },
      builder: (context, state) {
        final cubit = context.read<CartCubit>();
        if (!cubit.ready && cubit.busy) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          children: [
            Expanded(
              child: CartContent(onContinueShopping: onContinueShopping),
            ),
            if (cubit.cartItems.isNotEmpty)
              CartCheckoutBar(
                totals: cubit.totals,
                quantity: cubit.quantity,
                onSubmit: cubit.submitOrder,
              ),
          ],
        );
      },
    ),
  );
}
