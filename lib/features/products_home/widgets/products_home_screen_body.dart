import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app_task/features/products_home/widgets/products_home_widgets/products_home_collection.dart';
import 'package:shopping_app_task/features/products_home/widgets/products_home_widgets/products_home_filters.dart';

import '../../../core/widgets/shop_widgets.dart';
import '../../auth/controller/auth_cubit/auth_cubit.dart';
import '../controller/products_home_cubit/products_home_cubit.dart';

class ProductsHomeScreenBody extends StatefulWidget {
  const ProductsHomeScreenBody({super.key, required this.onOpenProduct});
  final ValueChanged<int> onOpenProduct;

  @override
  State<ProductsHomeScreenBody> createState() => ProductsHomeScreenBodyState();
}

class ProductsHomeScreenBodyState extends State<ProductsHomeScreenBody> {
  final searchController = TextEditingController();

  /// Disposing search controller
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthCubit>();
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: BlocBuilder<ProductsHomeCubit, ProductsHomeState>(
            builder: (context, state) {
              final cubit = context.read<ProductsHomeCubit>();
              return Column(
                children: [
                  /// offline message
                  if (auth.offline)
                    const Notice(
                      'Offline session: cached products and local cart are available.',
                    ),

                  /// filter by category
                  ProductsHomeFilters(searchController: searchController),

                  /// list of products
                  Expanded(
                    child: ProductsHomeCollection(
                      key: ValueKey((
                        cubit.query,
                        cubit.category,
                        cubit.isGrid,
                      )),
                      onOpenProduct: widget.onOpenProduct,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
