part of 'products_home_cubit.dart';

enum ProductsHomeStatus { loading, ready, error }

@immutable
sealed class ProductsHomeState {}

final class ProductsHomeInitial extends ProductsHomeState {}

final class ProductsHomeLoading extends ProductsHomeState {}

final class ProductsHomeSuccess extends ProductsHomeState {}

final class ProductsHomeError extends ProductsHomeState {}
