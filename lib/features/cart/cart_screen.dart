import 'package:flutter/material.dart';
import 'package:shopping_app_task/features/cart/widgets/cart_screen_body.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key, this.onContinueShopping});
  final VoidCallback? onContinueShopping;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colors.surfaceContainerLow,
      body: CartScreenBody(
        onContinueShopping:
            onContinueShopping ?? () => Navigator.of(context).maybePop(),
      ),
    );
  }
}
