import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app_task/features/products_home/widgets/product_details_widgets/product_details_gallery.dart';
import 'package:shopping_app_task/features/products_home/widgets/product_details_widgets/product_details_information.dart';

import '../../../../core/widgets/shop_widgets.dart';
import '../../controller/product_details_cubit/product_details_cubit.dart';
import '../../domain/entities/product_entity.dart';

class ProductDetailsContent extends StatelessWidget {
  final Product product;

  const ProductDetailsContent({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final details = context.read<ProductDetailsCubit>();
    return SafeArea(
      bottom: false,
      child: Center(
        child: SizedBox(
          width: 800.w,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            children: [
              if (details.notice != null)
                Notice(details.notice!, onRetry: details.loadProductDetails),
              if (details.error != null)
                Notice(details.error!, onRetry: details.loadProductDetails),

              /// product images
              ProductDetailsGallery(key: ValueKey(product), product: product),
              SizedBox(height: 24.h),

              /// details
              ProductDetailsInformation(product: product),
            ],
          ),
        ),
      ),
    );
  }
}
