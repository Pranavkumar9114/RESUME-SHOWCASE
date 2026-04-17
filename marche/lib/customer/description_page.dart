import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:translator/translator.dart'; // Import the translator package
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'cart_page.dart';

class DescriptionPage extends StatefulWidget {
  final String imageUrl;
  final Map<String, String> productDetails;

  const DescriptionPage({
    super.key,
    required this.imageUrl,
    required this.productDetails,
  });

  @override
  // ignore: library_private_types_in_public_api
  _DescriptionPageState createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> {
  late final GoogleTranslator _translator;
  late Map<String, String> _translatedProductDetails;

  @override
  void initState() {
    super.initState();
    _translator = GoogleTranslator();
    _translatedProductDetails = widget.productDetails; 
    _translateProductDetails();
  }

  Future<void> _translateProductDetails() async {
    try {
      final translatedDetails = {...widget.productDetails};

      final futures = <Future>[];

      for (var key in widget.productDetails.keys) {
        futures.add(
          _translator.translate(widget.productDetails[key] ?? '', to: 'en').then((translatedText) {
            translatedDetails[key] = translatedText.text;
          }),
        );
      }


      await Future.wait(futures);

      setState(() {
        _translatedProductDetails = translatedDetails;
      });
    } catch (e) {
      // ignore: avoid_print
      print('Translation error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final productDetails = _translatedProductDetails;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: widget.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            iconTheme: const IconThemeData(color: Colors.black),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productDetails['productName'] ?? 'Product Name',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        productDetails['quantity'] ?? 'Quantity',
                        style: const TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      _buildDetailRow('Packaging:', productDetails['packaging']),
                      _buildDetailRow('Brand:', productDetails['brands']),
                      _buildDetailRow('Categories:', productDetails['categories']),
                      const SizedBox(height: 16),
                      _buildSectionTitle('Description'),
                      const SizedBox(height: 8),
                      Text(productDetails['labels'] ?? 'No labels available'),
                      const SizedBox(height: 16),
                      _buildDetailRow(
                          'Manufactured in:', productDetails['manufacturingPlaces']),
                      _buildDetailRow('Available at:', productDetails['stores']),
                      _buildDetailRow('Available in:', productDetails['countries']),
                      const SizedBox(height: 16),
                      _buildAddToCartButton(),
                      const Divider(height: 40),
                      _buildReviewsSection(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        '$label $value',
        style: const TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .titleLarge
          ?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildAddToCartButton() {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            final productDetailsWithImage = {
              ..._translatedProductDetails,
              'imageUrl': widget.imageUrl,
            };
            Provider.of<CartProvider>(context, listen: false)
                .addItem(productDetailsWithImage);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Product added to cart")),
            );
          },
          child: const Text('Add to Cart'),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartPage()),
            );
          },
          child: const Text('View Cart'),
        ),
      ],
    );
  }

  Widget _buildReviewsSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Reviews', style: TextStyle(fontSize: 18)),
        SizedBox(height: 8),
        ListTile(
          leading: Icon(Icons.star, color: Colors.yellow),
          title: Text('Great product!'),
        ),
        ListTile(
          leading: Icon(Icons.star, color: Colors.yellow),
          title: Text('Highly recommend!'),
        ),
      ],
    );
  }
}
