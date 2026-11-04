class Product {
  const Product({
    required this.id,
    required this.title,
    this.description = '',
    this.category = '',
    this.price = 0,
    this.discount = 0,
    this.rating = 0,
    this.stock = 0,
    this.thumbnail = '',
    this.images = const [],
  });
  final int id;
  final String title, description, category, thumbnail;
  final double price, discount, rating;
  final int stock;
  final List<String> images;
}
