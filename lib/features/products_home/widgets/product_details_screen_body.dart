import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app_task/features/products_home/widgets/product_details_widgets/product_details_cart_bar.dart';
import 'package:shopping_app_task/features/products_home/widgets/product_details_widgets/product_details_content.dart';

import '../../../core/widgets/shop_widgets.dart';
import '../controller/product_details_cubit/product_details_cubit.dart';

class ProductDetailsScreenBody extends StatelessWidget {
  const ProductDetailsScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
      builder: (context, state) {
        final product = context.read<ProductDetailsCubit>().product;
        return Scaffold(
          appBar: AppBar(title: const Text('Product details')),
          body: buildContent(context),
          bottomNavigationBar:
              context.read<ProductDetailsCubit>().loading || product == null
              ? null
              : ProductDetailsCartBar(
                  key: ValueKey(product.id),
                  product: product,
                ),
        );
      },
    );
  }

  ///check availability
  Widget buildContent(BuildContext context) {
    final details = context.read<ProductDetailsCubit>();
    if (details.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    final product = details.product;
    if (product == null) {
      return Center(
        child: Notice(
          details.error ?? 'Product unavailable.',
          onRetry: details.loadProductDetails,
        ),
      );
    }
    return ProductDetailsContent(product: product);
  }
}
