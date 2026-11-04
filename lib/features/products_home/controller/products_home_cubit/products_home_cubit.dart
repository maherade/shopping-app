import 'dart:async';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app_task/core/storage/preferences_service.dart';
import 'package:shopping_app_task/features/products_home/domain/repo/products_home_repo.dart';
import 'package:shopping_app_task/features/products_home/domain/entities/product_entity.dart';
import 'package:shopping_app_task/features/products_home/domain/entities/category_entity.dart';
part 'products_home_state.dart';

class ProductsHomeCubit extends Cubit<ProductsHomeState> {
  ProductsHomeCubit(this.repository, this.preferences)
    : isGrid = preferences.grid,
      super(ProductsHomeInitial());
  final ProductsHomeRepository repository;
  final LayoutPreferences preferences;
  ProductsHomeStatus status = ProductsHomeStatus.loading;
  List<Product> products = const [];
  List<Category> categories = const [];
  bool isGrid;
  String query = '';
  String? category, notice, error;
  bool loadingMore = false, hasMore = false, cached = false;
  int skip = 0;
  Timer? searchDebounce;
  int requestGeneration = 0;

  /// Checks the request is current
  bool isCurrentGeneration(int generation) =>
      !isClosed && generation == requestGeneration;

  ///  get initial products and categories
  Future<void> initializeProducts() async {
    unawaited(loadProducts());
    await loadCategories();
  }

  ///  get product categories
  Future<void> loadCategories() async {
    final response = await repository.loadCategories();
    if (isClosed) return;
    response.fold(
      (failure) {
        notice = failure.message;
        emit(ProductsHomeError());
      },
      (loaded) {
        final (loadedCategories, cacheNotice) = loaded;
        categories = List.unmodifiable(loadedCategories);
        notice = cacheNotice ?? notice;
        emit(ProductsHomeSuccess());
      },
    );
  }

  /// Searches products
  void searchProducts(String query) {
    searchDebounce?.cancel();
    ++requestGeneration;
    this.query = query.trim();
    category = null;
    products = const [];
    status = ProductsHomeStatus.loading;
    loadingMore = hasMore = cached = false;
    skip = 0;
    error = notice = null;
    emit(ProductsHomeLoading());
    searchDebounce = Timer(
      const Duration(milliseconds: 350),
      () => unawaited(loadProducts()),
    );
  }

  /// Filters products by category
  Future<void> selectCategory(String? category) async {
    searchDebounce?.cancel();
    ++requestGeneration;
    this.category = category;
    query = '';
    products = const [];
    status = ProductsHomeStatus.loading;
    loadingMore = hasMore = cached = false;
    skip = 0;
    error = notice = null;
    emit(ProductsHomeLoading());
    await loadProducts();
  }

  /// Updates and saves the product layout
  Future<void> setGridLayout(bool grid) async {
    if (isGrid == grid) return;
    isGrid = grid;
    emit(ProductsHomeSuccess());
    try {
      await preferences.setGrid(grid);
    } catch (_) {
      if (!isClosed) {
        notice = 'Could not save layout preference.';
        emit(ProductsHomeError());
      }
    }
  }

  ///  get the next product page
  Future<void> loadNextProductsPage() async {
    if (isClosed || error != null || products.isEmpty) return;
    await loadProducts(more: true);
  }

  ///  get products with pagination and filters
  Future<void> loadProducts({bool more = false}) async {
    if (more &&
        (loadingMore || !hasMore || status != ProductsHomeStatus.ready)) {
      return;
    }
    final generation = more ? requestGeneration : ++requestGeneration;
    final requestedQuery = query;
    final requestedCategory = category;
    final requestedSkip = more ? skip : 0;
    if (!more) status = ProductsHomeStatus.loading;
    loadingMore = more;
    error = null;
    emit(ProductsHomeLoading());
    final response = await repository.loadProducts(
      skip: requestedSkip,
      query: requestedQuery,
      category: requestedCategory,
    );
    if (!isCurrentGeneration(generation)) return;
    response.fold(
      (failure) {
        status = more ? ProductsHomeStatus.ready : ProductsHomeStatus.error;
        loadingMore = false;
        error = failure.message;
        emit(ProductsHomeError());
      },
      (productsPage) {
        final productsById = <int, Product>{
          if (more)
            for (final product in products) product.id: product,
          for (final product in productsPage.products) product.id: product,
        };
        products = List.unmodifiable(productsById.values);
        status = ProductsHomeStatus.ready;
        loadingMore = false;
        hasMore = productsPage.hasMore;
        cached = productsPage.cached;
        notice = productsPage.notice;
        skip = productsPage.nextSkip;
        if (cached && products.isEmpty) {
          error = 'No matching cached products. Connect and retry.';
          emit(ProductsHomeError());
        } else {
          error = null;
          emit(ProductsHomeSuccess());
        }
      },
    );
  }

  /// Invalidates pending requests and closes the Cubit.
  @override
  Future<void> close() {
    searchDebounce?.cancel();
    ++requestGeneration;
    return super.close();
  }
}
