import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/shop_widgets.dart';
import '../../domain/entities/product_entity.dart';

class ProductDetailsGallery extends StatefulWidget {
  final Product product;

  const ProductDetailsGallery({super.key, required this.product});

  @override
  State<ProductDetailsGallery> createState() => ProductDetailsGalleryState();
}

class ProductDetailsGalleryState extends State<ProductDetailsGallery> {
  int imageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final images = widget.product.images.isEmpty
        ? [widget.product.thumbnail]
        : widget.product.images;
    final theme = Theme.of(context);
    return Column(
      children: [
        Container(
          height: 290.h,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Stack(
            children: [
              PageView.builder(
                itemCount: images.length,
                onPageChanged: (index) => setState(() => imageIndex = index),
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 24.h,
                  ),
                  child: ProductImage(images[index]),
                ),
              ),
              PositionedDirectional(
                bottom: 16.h,
                end: 16.w,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Text(
                    '${imageIndex + 1} / ${images.length}',
                    semanticsLabel:
                        'Image ${imageIndex + 1} of ${images.length}',
                    style: theme.textTheme.labelMedium,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
