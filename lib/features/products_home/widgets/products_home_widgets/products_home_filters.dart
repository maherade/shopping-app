import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app_task/features/products_home/widgets/products_home_widgets/product_category_chip.dart';
import '../../controller/products_home_cubit/products_home_cubit.dart';

class ProductsHomeFilters extends StatelessWidget {
  const ProductsHomeFilters({super.key, required this.searchController});
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductsHomeCubit>();
    final colors = Theme.of(context).colorScheme;
    final searchBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(18.r),
    );

    /// Clears search and selects a category
    void selectCategory(String? category) {
      searchController.clear();
      cubit.selectCategory(category);
    }

    return Column(
      children: [
        /// search section
        SizedBox(
          height: 80.h,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search products',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: colors.surfaceContainerLow,
                border: searchBorder,
                enabledBorder: searchBorder.copyWith(
                  borderSide: BorderSide(color: colors.outlineVariant),
                ),
                focusedBorder: searchBorder.copyWith(
                  borderSide: BorderSide(color: colors.primary, width: 2.w),
                ),
                suffixIcon: searchController.text.isEmpty
                    ? const SizedBox.shrink()
                    : IconButton(
                        onPressed: () {
                          searchController.clear();
                          cubit.searchProducts('');
                        },
                        icon: const Icon(Icons.close),
                      ),
              ),
              onChanged: cubit.searchProducts,
            ),
          ),
        ),
        Row(
          children: [
            /// switching grid and list
            Padding(
              padding: EdgeInsetsDirectional.only(start: 4.w),
              child: IconButton(
                onPressed: () => cubit.setGridLayout(!cubit.isGrid),
                icon: Icon(
                  cubit.isGrid ? Icons.view_list_outlined : Icons.grid_view,
                ),
              ),
            ),

            /// categories list
            Expanded(
              child: SizedBox(
                height: 40.h,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  children: [
                    ProductCategoryChip(
                      label: 'All',
                      selected: cubit.category == null,
                      onSelected: () => selectCategory(null),
                    ),
                    for (final category in cubit.categories)
                      ProductCategoryChip(
                        key: ValueKey(category.slug),
                        label: category.name,
                        selected: cubit.category == category.slug,
                        onSelected: () => selectCategory(category.slug),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
