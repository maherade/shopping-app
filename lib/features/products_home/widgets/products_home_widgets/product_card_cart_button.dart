import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../cart/controller/cart_cubit/cart_cubit.dart';
import '../../domain/entities/product_entity.dart';

class ProductCardCartButton extends StatelessWidget {
  final Product product;

  const ProductCardCartButton({super.key, required this.product});


  @override
  Widget build(BuildContext context) => BlocBuilder<CartCubit, CartState>(
    builder: (context, state) {
      final cart = context.read<CartCubit>();
      return IconButton.filled(
        key: ValueKey('add-product-${product.id}'),
        onPressed: cart.isProductAvailableToAdd(product)
            ? () async {
                final cart = context.read<CartCubit>();
                if (!cart.isProductAvailableToAdd(product)) return;
                final generation = cart.requestGeneration;
                await cart.addToCart(product, 1);
                if (!context.mounted) return;
                if (!cart.isCurrentGeneration(generation)) return;
                final message = cart.error ?? 'Added to your cart';
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text(message)));
              }
            : null,
        constraints: BoxConstraints(minWidth: 48.r, minHeight: 48.r),
        style: IconButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
        icon: cart.busy && cart.addingProductId == product.id
            ? const CircularProgressIndicator(strokeWidth: 2)
            : const Icon(Icons.add_shopping_cart_rounded),
      );
    },
  );
}
