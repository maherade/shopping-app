import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  const ProductImage(this.url, {super.key, this.height, this.width});
  final String url;
  final double? height, width;

  @override
  Widget build(BuildContext context) {
    Widget placeholder() => SizedBox(
      height: height,
      width: width,
      child: Center(child: Icon(Icons.image_outlined, size: 40.r)),
    );
    if (url.isEmpty) return placeholder();
    return CachedNetworkImage(
      imageUrl: url,
      height: height,
      width: width,
      fit: BoxFit.contain,
      placeholder: (context, imageUrl) => placeholder(),
      errorWidget: (context, imageUrl, error) => placeholder(),
    );
  }
}

class Notice extends StatelessWidget {
  const Notice(this.message, {super.key, this.onRetry});
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
    color: Theme.of(context).colorScheme.surfaceContainerHighest,
    child: Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8.w,
      children: [
        Text(message),
        if (onRetry != null)
          TextButton(onPressed: onRetry, child: const Text('Retry')),
      ],
    ),
  );
}

/// Selects a quantity within the available stock.
class QuantitySelector extends StatelessWidget {
  /// Creates the segmented quantity control.
  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.maximum,
    required this.onChanged,
    this.enabled = true,
  });
  final int quantity, maximum;
  final bool enabled;
  final ValueChanged<int> onChanged;

  /// Builds the bordered quantity segments.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.outlineVariant),
        borderRadius: BorderRadius.circular(12.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'Decrease quantity',
              onPressed: enabled && quantity > 1
                  ? () => onChanged(quantity - 1)
                  : null,
              icon: const Icon(Icons.remove),
            ),
            VerticalDivider(
              width: 1.w,
              thickness: 1.w,
              color: colors.outlineVariant,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              child: Text(
                '$quantity',
                semanticsLabel: 'Quantity $quantity',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            VerticalDivider(
              width: 1.w,
              thickness: 1.w,
              color: colors.outlineVariant,
            ),
            IconButton(
              tooltip: 'Increase quantity',
              onPressed: enabled && quantity < maximum
                  ? () => onChanged(quantity + 1)
                  : null,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
