import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'description_page.dart';
import 'package:translator/translator.dart'; 

// ignore: camel_case_types
class productgrid4 extends StatefulWidget {
  const productgrid4({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _productgrid4State createState() => _productgrid4State();
}

// ignore: camel_case_types
class _productgrid4State extends State<productgrid4> {
  List<String> barcodeList = [];
  Map<String, Map<String, dynamic>> productCache = {}; 
  final translator = GoogleTranslator(); 


  Future<Map<String, dynamic>> fetchProductData(String barcode) async {
    if (productCache.containsKey(barcode)) {
    
      return productCache[barcode]!;
    }

    final url = 'https://world.openfoodfacts.org/api/v0/product/$barcode.json';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final product = data['product'];

      
        final productName = await _translateToEnglish(product['product_name']);
        final productPrice = await _translateToEnglish(product['price']);

        final productData = {
          'imageUrl': product['image_url'] ?? '',
          'productName': productName ?? 'No product name available',
          'price': productPrice ?? 'No price available', // Added price
          'quantity': product['quantity'] ?? 'No quantity available',
          'packaging': product['packaging'] ?? 'No packaging information available',
          'brands': product['brands'] ?? 'No brand information available',
          'categories': (product['categories'] is List)
              ? (product['categories'] as List).join(', ')
              : product['categories'] ?? 'No categories available',
          'labels': (product['labels'] is List)
              ? (product['labels'] as List).join(', ')
              : product['labels'] ?? 'No label information available',
          'link': product['url'] ?? 'No link available',
          'stores': product['stores'] ?? 'No store information available',
          'countries': (product['countries_tags'] is List)
              ? (product['countries_tags'] as List).join(', ')
              : product['countries_tags'] ?? 'No country information available',
          'manufacturingPlaces': (product['manufacturing_places'] is List)
              ? (product['manufacturing_places'] as List).join(', ')
              : product['manufacturing_places'] ?? 'No manufacturing place available',
        };

 
        productCache[barcode] = productData;
        return productData;
      } else {
        throw Exception('Failed to load product data');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }

  Future<String?> _translateToEnglish(String? text) async {
    if (text == null || text.isEmpty) return text;
    final translation = await translator.translate(text, to: 'en');
    return translation.text;
  }

  Future<void> fetchBarcodeList() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      final snapshot =
          await firestore.collection('barcodes').doc('barcode_data4').get();

      if (snapshot.exists) {
        final data = snapshot.data();
        List<String> barcodes = [];
        data?.forEach((key, value) {
          if (key.startsWith('barcode_')) {
            barcodes.add(value);
          }
        });

        setState(() {
          barcodeList = barcodes;
        });
      } else {
        throw Exception('Document does not exist');
      }
    } catch (e) {
      throw Exception('Failed to load barcodes from Firestore: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBarcodeList();
  }

  @override
  Widget build(BuildContext context) {
    return barcodeList.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : SizedBox(
            height: 500,
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.75,
              ),
              itemCount: barcodeList.length,
              itemBuilder: (context, index) {
                return FutureBuilder<Map<String, dynamic>>(
                  future: fetchProductData(barcodeList[index]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No product found'));
                    }

                    final product = snapshot.data!;
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DescriptionPage(
                              imageUrl: product['imageUrl']!,
                              productDetails: {
                                'productName': product['productName']!,
                                'quantity': product['quantity']!,
                                'packaging': product['packaging']!,
                                'brands': product['brands']!,
                                'categories': product['categories']!,
                                'labels': product['labels']!,
                                'link': product['link']!,
                                'stores': product['stores']!,
                                'countries': product['countries']!,
                                'manufacturingPlaces': product['manufacturingPlaces']!,
                              },
                            ),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CachedNetworkImage(
                              imageUrl: product['imageUrl']!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 150,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                   Text(
                                  product['productName']!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  product['price'] ?? 'No price available',
                                  style: const TextStyle(
                                    fontSize: 10.0,
                                    color: Colors.green,
                                  ),
                                ),
                                Text(
                                  product['quantity']!,
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey,
                                  ),
                                ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
            ),
          );
  }
}

void main() {
  runApp(const MaterialApp(home: Scaffold(body: productgrid4())));
}
