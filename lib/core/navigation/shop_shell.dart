import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app_task/core/navigation/widgets/shop_bottom_navigation.dart';
import 'package:shopping_app_task/features/auth/controller/auth_cubit/auth_cubit.dart';
import 'package:shopping_app_task/features/cart/cart_screen.dart';
import 'package:shopping_app_task/features/products_home/products_home_screen.dart';
import 'package:shopping_app_task/features/profile/profile_screen.dart';

class ShopShell extends StatefulWidget {
  const ShopShell({super.key});

  @override
  State<ShopShell> createState() => ShopShellState();
}

class ShopShellState extends State<ShopShell> {
  int selectedTab = 0;

  void selectTab(int index) {
    if (index == selectedTab) return;
    setState(() => selectedTab = index);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    const titles = ['Maher Store', 'Cart', 'Profile'];
    return PopScope(
      canPop: selectedTab == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && selectedTab != 0) selectTab(0);
      },
      child: Scaffold(
        backgroundColor: colors.surfaceContainerLow,
        appBar: AppBar(
          title: Text(titles[selectedTab]),
          centerTitle: true,
          backgroundColor: colors.surface,
          scrolledUnderElevation: 0,
          actions: [
            selectedTab == 2
                ? IconButton(
                    tooltip: 'Sign out',
                    icon: const Icon(Icons.logout_rounded),
                    onPressed: () => context.read<AuthCubit>().signOut(),
                  )
                : SizedBox.shrink(),
          ],
        ),
        body: IndexedStack(
          index: selectedTab,
          children: [
            const ProductsHomeScreen(),
            CartScreen(onContinueShopping: () => selectTab(0)),
            ProfileScreen(onSelectTab: selectTab),
          ],
        ),
        bottomNavigationBar: ShopBottomNavigation(
          selectedTab: selectedTab,
          onSelectTab: selectTab,
        ),
      ),
    );
  }
}
