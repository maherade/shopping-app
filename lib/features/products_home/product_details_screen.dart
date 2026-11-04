import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app_task/features/products_home/widgets/product_details_screen_body.dart';
import 'controller/product_details_cubit/product_details_cubit.dart';
import 'domain/repo/products_home_repo.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key, required this.productId});
  final int productId;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) =>
        ProductDetailsCubit(context.read<ProductsHomeRepository>(), productId)
          ..loadProductDetails(),
    child: const ProductDetailsScreenBody(),
  );
}
