import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopping_app_task/core/navigation/widgets/shop_navigation_item.dart';
import 'package:shopping_app_task/core/widgets/user_avatar.dart';
import 'package:shopping_app_task/features/auth/controller/auth_cubit/auth_cubit.dart';
import 'package:shopping_app_task/features/cart/controller/cart_cubit/cart_cubit.dart';

class ShopBottomNavigation extends StatelessWidget {
  const ShopBottomNavigation({
    super.key,
    required this.selectedTab,
    required this.onSelectTab,
  });
  final int selectedTab;
  final ValueChanged<int> onSelectTab;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final profile = context.watch<AuthCubit>().session?.profile;
    return SafeArea(
      top: false,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border.all(
            color: colors.outlineVariant.withValues(alpha: .6),
          ),
          borderRadius: BorderRadius.circular(26.r),
          boxShadow: [
            BoxShadow(
              color: colors.primary.withValues(alpha: .06),
              blurRadius: 20.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ShopNavigationItem(
                key: const ValueKey('nav-home'),
                label: 'Home',
                selected: selectedTab == 0,
                icon: Icon(
                  selectedTab == 0 ? Icons.home_rounded : Icons.home_outlined,
                ),
                onTap: () => onSelectTab(0),
              ),
            ),
            Expanded(
              child: BlocBuilder<CartCubit, CartState>(
                builder: (context, state) {
                  final quantity = context.read<CartCubit>().quantity;
                  return ShopNavigationItem(
                    key: const ValueKey('nav-cart'),
                    label: 'Cart',
                    selected: selectedTab == 1,
                    icon: Badge(
                      isLabelVisible: quantity > 0,
                      label: Text('$quantity'),
                      child: Icon(
                        selectedTab == 1
                            ? Icons.shopping_cart_rounded
                            : Icons.shopping_cart_outlined,
                      ),
                    ),
                    onTap: () => onSelectTab(1),
                  );
                },
              ),
            ),
            Expanded(
              child: ShopNavigationItem(
                key: const ValueKey('nav-profile'),
                label: 'Profile',
                selected: selectedTab == 2,
                icon: UserAvatar(imageUrl: profile?.image ?? '', size: 22.r),
                onTap: () => onSelectTab(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
