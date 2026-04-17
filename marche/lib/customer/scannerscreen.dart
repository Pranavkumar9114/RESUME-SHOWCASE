// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:marche/customer/description_page.dart';
import 'package:marche/splashscreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      _scanBarcode();
    });
  }

  Future<void> _scanBarcode() async {
    try {
      final scanResult = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.BARCODE,
      );

      if (!mounted) return;

      if (scanResult == '-1') {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const PageViewScreen()),
          (Route<dynamic> route) => false,
        );
      } else {
        _validateBarcode(scanResult);
      }
    } catch (e) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PageViewScreen()),
        );
      }
    }
  }

  Future<void> _validateBarcode(String barcode) async {
    final snapshot =
        await FirebaseFirestore.instance.collection('barcodes').get();

    bool barcodeFound = false;
    for (var productDoc in snapshot.docs) {
      final productDetails = productDoc.data();
      List<String> barcodes = [];
      for (int i = 1; i <= 6; i++) {
        final barcodeField = 'barcode_$i';
        if (productDetails.containsKey(barcodeField)) {
          barcodes.add(productDetails[barcodeField]);
        }
      }

      if (barcodes.contains(barcode)) {
        barcodeFound = true;
        _fetchProductDataFromOpenFoodFacts(barcode, productDetails);
        break; 
      }
    }

    if (!barcodeFound) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product not found in database')),
      );
    }
  }

  Future<void> _fetchProductDataFromOpenFoodFacts(
      String barcode, Map<String, dynamic> productDetails) async {

    final apiUrl =
        'https://world.openfoodfacts.org/api/v0/product/$barcode.json';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final productData = json.decode(response.body);
        if (productData['status'] == 1) {
          final product = productData['product'];

          String manufacturingPlaces = '';
          if (product['manufacturing_places'] is List) {
            manufacturingPlaces = (product['manufacturing_places'] as List)
                .join(', '); 
          } else {
            manufacturingPlaces = product['manufacturing_places'] ?? 'N/A';
          }

          String countries = '';
          if (product['countries_tags'] is List) {
            countries = (product['countries_tags'] as List)
                .join(', ');
          } else {
            countries = product['countries_tags'] ?? 'N/A';
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DescriptionPage(
                imageUrl: product['image_url'] ?? '',
                productDetails: {
                  'productName': product['product_name'] ?? 'Unknown',
                  'quantity': product['quantity'] ?? 'N/A',
                  'packaging': product['packaging'] ?? 'N/A',
                  'brands': product['brands'] ?? 'N/A',
                  'categories': product['categories'] ?? 'N/A',
                  'labels': product['labels'] ?? 'N/A',
                  'manufacturingPlaces': manufacturingPlaces,
                  'stores': product['stores'] ?? 'N/A',
                  'countries': countries,
                },
              ),
            ),
          ).then((_) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const PageViewScreen()),
              (Route<dynamic> route) => false,
            );
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Product not found in Open Food Facts database')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Failed to fetch product details from Open Food Facts')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching product details: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
