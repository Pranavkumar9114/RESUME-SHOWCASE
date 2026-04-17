import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'description_page.dart';
import 'package:translator/translator.dart'; 

// ignore: camel_case_types
class productgrid2 extends StatefulWidget {
  const productgrid2({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _productgrid2State createState() => _productgrid2State();
}

// ignore: camel_case_types
class _productgrid2State extends State<productgrid2> {
  List<String> barcodeList = [];
  Map<String, Map<String, dynamic>> productCache = {};
  final GoogleTranslator _translator = GoogleTranslator();

  
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
        final quantity = await _translateToEnglish(product['quantity']);
        final packaging = await _translateToEnglish(product['packaging']);
        final brands = await _translateToEnglish(product['brands']);
        final categories = await _translateToEnglish((product['categories'] is List)
            ? (product['categories'] as List).join(', ')
            : product['categories']);
        final labels = await _translateToEnglish((product['labels'] is List)
            ? (product['labels'] as List).join(', ')
            : product['labels']);
        final stores = await _translateToEnglish(product['stores']);
        final countries = await _translateToEnglish((product['countries_tags'] is List)
            ? (product['countries_tags'] as List).join(', ')
            : product['countries_tags']);
        final manufacturingPlaces = await _translateToEnglish((product['manufacturing_places'] is List)
            ? (product['manufacturing_places'] as List).join(', ')
            : product['manufacturing_places']);

        final productData = {
          'imageUrl': product['image_url'] ?? '',
          'productName': productName,
          'quantity': quantity,
          'packaging': packaging,
          'brands': brands,
          'categories': categories,
          'labels': labels,
          'link': product['url'] ?? 'No link available',
          'stores': stores,
          'countries': countries,
          'manufacturingPlaces': manufacturingPlaces,
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


  Future<String> _translateToEnglish(String? text) async {
    if (text == null || text.isEmpty) return 'No translation available';
    var translation = await _translator.translate(text, to: 'en');
    return translation.text;
  }

  Future<void> fetchBarcodeList() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      final snapshot =
          await firestore.collection('barcodes').doc('barcode_data2').get();

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
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 items in a row
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.7, // Adjusted aspect ratio
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
                          children: [
                            Expanded(
                              child: CachedNetworkImage(
                                imageUrl: product['imageUrl']!,
                                fit: BoxFit.cover,
                              ),
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
  runApp(const MaterialApp(home: Scaffold(body: productgrid2()))); 
}
