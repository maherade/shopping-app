import 'package:flutter/material.dart';
import 'package:shopping_app_task/features/products_home/product_details_screen.dart';
import 'package:shopping_app_task/features/products_home/widgets/products_home_screen_body.dart';

class ProductsHomeScreen extends StatelessWidget {
  const ProductsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProductsHomeScreenBody(
        onOpenProduct: (id) => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) => ProductDetailsScreen(productId: id),
          ),
        ),
      ),
    );
  }
}
