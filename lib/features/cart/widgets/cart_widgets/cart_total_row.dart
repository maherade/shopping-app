import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app_task/core/pricing/cart_calculator.dart';

class CartTotalRow extends StatelessWidget {
  const CartTotalRow(
    this.label,
    this.cents, {
    super.key,
    this.emphasized = false,
  });
  final String label;
  final int cents;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: emphasized
                  ? theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    )
                  : theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              '\$${CartCalculator.money(cents)}',
              textAlign: TextAlign.end,
              style: emphasized
                  ? theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w800,
                    )
                  : theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
