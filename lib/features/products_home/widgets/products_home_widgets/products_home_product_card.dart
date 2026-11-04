import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopping_app_task/features/products_home/widgets/products_home_widgets/product_card_image.dart';
import 'package:shopping_app_task/features/products_home/widgets/products_home_widgets/product_card_information.dart';
import '../../domain/entities/product_entity.dart';

class ProductsHomeProductCard extends StatelessWidget {
  final Product product;
  final bool isGrid;
  final VoidCallback onTap;
  const ProductsHomeProductCard(
    this.product, {
    super.key,
    this.isGrid = true,
    required this.onTap,
  });


  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(20.r);
    return Card(
      elevation: 0,
      color: colors.surface,
      margin: EdgeInsets.only(bottom: isGrid ? 0 : 12.h),
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: colors.outlineVariant.withValues(alpha: .6)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          child: isGrid
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: ProductCardImage(product: product)),
                    SizedBox(height: 12.h),
                    ProductCardInformation(product: product),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 100.r,
                      height: 128.r,
                      child: ProductCardImage(
                        product: product,
                        showRating: false,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(child: ProductCardInformation(product: product)),
                  ],
                ),
        ),
      ),
    );
  }
}
