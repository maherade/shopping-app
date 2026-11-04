abstract final class EndPoints {
  static const baseUrl = 'https://dummyjson.com';
  static const login = '/auth/login';
  static const me = '/auth/me';
  static const products = '/products';
  static const searchProducts = '/products/search';
  static const categories = '/products/categories';
  static const addCart = '/carts/add';

  static String categoryProducts(String slug) =>
      '$products/category/${Uri.encodeComponent(slug)}';

  static String product(int id) => '$products/$id';
}
