import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Scaffold(
      backgroundColor: colors.primary,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(24.r),
                  decoration: BoxDecoration(
                    color: colors.onPrimary.withValues(alpha: .12),
                    borderRadius: BorderRadius.circular(28.r),
                  ),
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    size: 64.r,
                    color: colors.onPrimary,
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  'Maher Store',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: colors.onPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 32.h),
                SizedBox.square(
                  dimension: 24.r,
                  child: CircularProgressIndicator(
                    color: colors.onPrimary,
                    strokeWidth: 2,
                    semanticsLabel: 'Loading store',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
