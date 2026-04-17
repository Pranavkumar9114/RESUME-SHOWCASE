class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final List<String> images;
  final double rating;
  final List<String> reviews;
  final String category;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.images,
    required this.rating,
    required this.reviews,
    required this.category,
  });
}