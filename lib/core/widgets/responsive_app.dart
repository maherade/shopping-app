import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Initializes responsive sizing and themes.
class ResponsiveApp extends StatelessWidget {
  /// Creates the responsive app.
  const ResponsiveApp({super.key, required this.builder});
  final WidgetBuilder builder;
  static const designSize = Size(375, 812);

  /// Scales a text style for the screen.
  static TextStyle? responsiveTextStyle(TextStyle? style) =>
      style?.fontSize == null
      ? style
      : style!.copyWith(fontSize: style.fontSize!.sp);

  /// Scales typography for the screen.
  static TextTheme responsiveTextTheme(TextTheme text) => text.copyWith(
    displayLarge: responsiveTextStyle(text.displayLarge),
    displayMedium: responsiveTextStyle(text.displayMedium),
    displaySmall: responsiveTextStyle(text.displaySmall),
    headlineLarge: responsiveTextStyle(text.headlineLarge),
    headlineMedium: responsiveTextStyle(text.headlineMedium),
    headlineSmall: responsiveTextStyle(text.headlineSmall),
    titleLarge: responsiveTextStyle(text.titleLarge),
    titleMedium: responsiveTextStyle(text.titleMedium),
    titleSmall: responsiveTextStyle(text.titleSmall),
    bodyLarge: responsiveTextStyle(text.bodyLarge),
    bodyMedium: responsiveTextStyle(text.bodyMedium),
    bodySmall: responsiveTextStyle(text.bodySmall),
    labelLarge: responsiveTextStyle(text.labelLarge),
    labelMedium: responsiveTextStyle(text.labelMedium),
    labelSmall: responsiveTextStyle(text.labelSmall),
  );

  /// Applies responsive text and control sizing.
  static ThemeData responsiveTheme(ThemeData base) => base.copyWith(
    textTheme: responsiveTextTheme(
      base.typography.englishLike.merge(base.textTheme),
    ),
    primaryTextTheme: responsiveTextTheme(
      base.typography.englishLike.merge(base.primaryTextTheme),
    ),
    iconTheme: base.iconTheme.copyWith(size: 24.r),
    appBarTheme: base.appBarTheme.copyWith(toolbarHeight: 56.h),
    inputDecorationTheme: base.inputDecorationTheme.copyWith(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: (base.filledButtonTheme.style ?? const ButtonStyle()).copyWith(
        minimumSize: WidgetStatePropertyAll(Size(64.w, 40.h)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: (base.outlinedButtonTheme.style ?? const ButtonStyle()).copyWith(
        minimumSize: WidgetStatePropertyAll(Size(64.w, 40.h)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: (base.textButtonTheme.style ?? const ButtonStyle()).copyWith(
        minimumSize: WidgetStatePropertyAll(Size(64.w, 40.h)),
      ),
    ),
  );

  /// Builds the responsive app layout.
  @override
  Widget build(BuildContext context) => ScreenUtilInit(
    designSize: designSize,
    minTextAdapt: true,
    fontSizeResolver: FontSizeResolvers.radius,
    splitScreenMode: true,
    rebuildFactor: RebuildFactors.change,
    builder: (context, child) => builder(context),
  );
}
