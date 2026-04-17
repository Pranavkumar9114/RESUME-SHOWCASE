import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;

class CheckoutPage extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  final double subtotalInr;
  final double shoppingCostInr;
  final double taxesInr;
  final double totalPriceInr;

  const CheckoutPage({
    super.key,
    required this.subtotalInr,
    required this.shoppingCostInr,
    required this.taxesInr,
    required this.totalPriceInr,
    required this.cartItems, 
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPriceRow('Subtotal', subtotalInr),
            _buildPriceRow('Shipping Cost', shoppingCostInr),
            _buildPriceRow('Taxes', taxesInr),
            const Divider(color: Colors.grey),
            _buildPriceRow('Total', totalPriceInr, isTotal: true),
            const SizedBox(height: 20),
    
            _buildCartItems(cartItems),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _generateBillAndDownload(context); 
              },
              child: const Text('Download Bill'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '₹${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItems(List<Map<String, dynamic>> cartItems) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: cartItems.map((product) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            '${product['productName']} (x${product['quantity']})', 
            style: const TextStyle(fontSize: 16),
          ),
        );
      }).toList(),
    );
  }

  Future<void> _generateBillAndDownload(BuildContext context) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text('Bill', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              _buildPdfRow('Subtotal', subtotalInr),
              _buildPdfRow('Shipping Cost', shoppingCostInr),
              _buildPdfRow('Taxes', taxesInr),
              pw.Divider(),
              _buildPdfRow('Total', totalPriceInr, isTotal: true),
            ],
          );
        },
      ),
    );

    final directory = Directory('/storage/emulated/0/Download/');
    if (await directory.exists()) {
      final filePath = '${directory.path}/bill_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Bill saved to $filePath')));
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not access Downloads folder')));
    }
  }

  pw.Widget _buildPdfRow(String label, double amount, {bool isTotal = false}) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: isTotal ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
        pw.Text(
          '₹${amount.toStringAsFixed(2)}',
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: isTotal ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
