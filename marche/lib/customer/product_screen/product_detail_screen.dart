import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:marche/customer/product_screen/product.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarouselSlider(
                items: product.images.map((imgUrl) {
                  // Use Image.network to load images from a URL
                  return Image.network(
                    imgUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  );
                }).toList(),
                options: CarouselOptions(
                  height: 250,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                product.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text('\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 20, color: Colors.green)),
              const SizedBox(height: 16),
              Text(
                'Description',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(product.description),
              const SizedBox(height: 16),
              _buildAddToCartButton(context),
              const Divider(height: 40),
              _buildReviewsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddToCartButton(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () {},
          child: const Text('Add to Cart'),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Buy Now'),
        ),
      ],
    );
  }

  Widget _buildReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Reviews', style: TextStyle(fontSize: 18)),
        const SizedBox(height: 8),
        ...product.reviews.map((review) => ListTile(
              leading: const Icon(Icons.star, color: Colors.yellow),
              title: Text(review),
            )),
      ],
    );
  }
}
