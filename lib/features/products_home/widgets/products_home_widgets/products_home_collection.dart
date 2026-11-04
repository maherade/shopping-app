import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app_task/features/products_home/widgets/products_home_widgets/products_home_product_card.dart';

import '../../controller/products_home_cubit/products_home_cubit.dart';

class ProductsHomeCollection extends StatefulWidget {
  const ProductsHomeCollection({super.key, required this.onOpenProduct});

  final ValueChanged<int> onOpenProduct;

  @override
  State<ProductsHomeCollection> createState() => ProductsHomeCollectionState();
}

class ProductsHomeCollectionState extends State<ProductsHomeCollection> {
  final controller = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.addListener(loadAtBottom);
  }

  /// Loads another page
  void loadAtBottom() {
    if (controller.hasClients &&
        controller.position.pixels >= controller.position.maxScrollExtent) {
      context.read<ProductsHomeCubit>().loadNextProductsPage();
    }
  }

  /// Disposes the product scroll controller
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductsHomeCubit>();
    if (cubit.status == ProductsHomeStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (cubit.products.isEmpty) {
      var message = 'No products found.';
      if (cubit.status == ProductsHomeStatus.error) {
        message = 'Products unavailable. Please retry.';
      } else if (cubit.cached) {
        message = 'No matching cached products.';
      }
      return Center(child: Text(message));
    }

    return RefreshIndicator(
      onRefresh: () => cubit.loadProducts(),
      child: NotificationListener<OverscrollNotification>(
        onNotification: (notification) {
          if (notification.depth == 0 && notification.overscroll > 0) {
            cubit.loadNextProductsPage();
          }
          return false;
        },
        child: CustomScrollView(
          controller: controller,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              sliver: cubit.isGrid
                  ? SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.65,
                        crossAxisSpacing: 8.w,
                        mainAxisSpacing: 8.h,
                      ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final product = cubit.products[index];
                        return ProductsHomeProductCard(
                          product,
                          key: ValueKey(product.id),
                          isGrid: cubit.isGrid,
                          onTap: () => widget.onOpenProduct(product.id),
                        );
                      }, childCount: cubit.products.length),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final product = cubit.products[index];
                        return ProductsHomeProductCard(
                          product,
                          key: ValueKey(product.id),
                          isGrid: cubit.isGrid,
                          onTap: () => widget.onOpenProduct(product.id),
                        );
                      }, childCount: cubit.products.length),
                    ),
            ),
            if (cubit.hasMore && cubit.error == null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 12.h,
                  ),
                  child: const LinearProgressIndicator(
                    semanticsLabel: 'More products available',
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
