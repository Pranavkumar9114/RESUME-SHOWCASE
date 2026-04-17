import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/models.dart' as square_models;
import 'cart_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems;

    double subtotal = 0.0;
    double shoppingCost = 0.0;
    for (var product in cartItems) {
      subtotal += double.tryParse(product['price'] ?? '0.0') ?? 0.0;
      shoppingCost += double.tryParse(product['shippingCost'] ?? '0.1') ?? 0.0;
    }

    double taxes = subtotal * 0.08;
    double totalPrice = subtotal + shoppingCost + taxes;

    const double usdToInrRate = 83.0;
    double subtotalInr = subtotal * usdToInrRate;
    double shoppingCostInr = shoppingCost * usdToInrRate;
    double taxesInr = taxes * usdToInrRate;
    double totalPriceInr = totalPrice * usdToInrRate;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 5,
      ),
      body: cartItems.isEmpty
          ? const Center(
              child: Text(
                "Your cart is empty",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            )
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final product = cartItems[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? Colors.grey[800]
                        : Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 3,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      if (product['imageUrl'] != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: product['imageUrl']!,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error, size: 50),
                          ),
                        )
                      else
                        const Icon(Icons.image, size: 50),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product['productName'] ?? 'Product',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Quantity: ${product['quantity'] ?? ''}",
                              style: TextStyle(
                                color: isDarkMode ? Colors.grey : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _showDeleteConfirmationDialog(
                              context, cartProvider, index);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 3,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildPriceRow('Subtotal', subtotalInr, isDarkMode: isDarkMode),
                  _buildPriceRow('Shipping Cost', shoppingCostInr,
                      isDarkMode: isDarkMode),
                  _buildPriceRow('Taxes', taxesInr, isDarkMode: isDarkMode),
                  Divider(
                      color: isDarkMode ? Colors.white : Colors.grey[400],
                      thickness: 1),
                  _buildPriceRow('Total', totalPriceInr,
                      isDarkMode: isDarkMode, isTotal: true),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _startSquarePayment(context, totalPrice,shoppingCostInr,taxesInr,subtotalInr);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isDarkMode ? Colors.deepPurple : Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              child: Text(
                'Proceed to Checkout',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount,
      {bool isTotal = false, bool isDarkMode = false}) {
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
              color: isTotal
                  ? (isDarkMode ? Colors.green[300] : Colors.green[700])
                  : (isDarkMode ? Colors.white : Colors.black),
            ),
          ),
          Text(
            '₹${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal
                  ? (isDarkMode ? Colors.green[300] : Colors.green[700])
                  : (isDarkMode ? Colors.white : Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, CartProvider cartProvider, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text(
              'Do you really want to delete this item from your cart?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes, Delete'),
              onPressed: () {
                cartProvider.removeItem(index);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

void _startSquarePayment(BuildContext context, double totalPrice,double shoppingCostInr,double taxesInr,double subtotalInr) async {
  const double usdToInrRate = 83.0; // Conversion rate
  double totalPriceInr = totalPrice * usdToInrRate; // Convert to INR

  try {
    await InAppPayments.startCardEntryFlow(
      onCardNonceRequestSuccess: (square_models.CardDetails result) {
        InAppPayments.completeCardEntry(
          onCardEntryComplete: () {
            _showPaymentSuccessDialog(context, totalPriceInr,shoppingCostInr,taxesInr,subtotalInr); // Use INR total here
          },
        );
      },
      onCardEntryCancel: () {
        _showPaymentErrorDialog(context, "Payment was canceled.");
      },
    );
  } catch (e) {
    // ignore: use_build_context_synchronously
    _showPaymentErrorDialog(context, "Error: $e");
  }
}

void _showPaymentSuccessDialog(BuildContext context, double totalPrice,double shoppingCostInr,double taxesInr,double subtotalInr) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Payment Successful'),
        content: Column(
          mainAxisSize: MainAxisSize.min,  // Makes sure the content fits in the dialog
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Thank you for your purchase! Total: ₹${totalPrice.toStringAsFixed(2)}'),
            const SizedBox(height: 10),
            // Button for downloading the bill
            ElevatedButton(
              onPressed: () {
                generateBill(context, totalPrice,taxesInr,subtotalInr,shoppingCostInr);  // Call the generateBill function
                //Navigator.of(context).pop();  // Close the dialog after generating the bill
              },
              child: const Text('Download Bill'),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              final cartProvider = Provider.of<CartProvider>(context, listen: false);
              cartProvider.clearCart();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

  void _showPaymentErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Payment Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

void generateBill(BuildContext context, double totalPrice,double shoppingCostInr,double taxesInr,double subtotalInr) async {
  final pdf = pw.Document();
  // const double usdToInrRate = 83.0;  // Conversion rate for USD to INR
  // double totalPriceInr = totalPrice * usdToInrRate;  // Convert total price to INR

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Bill Title
            pw.Text('INVOICE', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Text('Marche App - Order Summary', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            
            // Bill Rows: Add details here for subtotal, shipping, taxes, and total
            _buildBillRow(pdf, 'Subtotal',shoppingCostInr),
            pw.SizedBox(height: 10),
            _buildBillRow(pdf, 'Shipping Cost',subtotalInr),  // Example shipping cost
            pw.SizedBox(height: 10),
            _buildBillRow(pdf, 'Taxes',taxesInr),  // Example taxes
            pw.SizedBox(height: 10),
            _buildBillRow(pdf, 'Total', totalPrice, isTotal: true),
            
            pw.SizedBox(height: 20),
            pw.Text('Thank you for your purchase!', style: const pw.TextStyle(fontSize: 16)),
            pw.Text('Marche App', style: const pw.TextStyle(fontSize: 14)),
            pw.Text('www.marcheapp.com', style: const pw.TextStyle(fontSize: 14)),
            pw.Text('Contact us at: support@marcheapp.com', style: const pw.TextStyle(fontSize: 14)),
          ],
        );
      },
    ),
  );

  // Save or share the PDF file
  Printing.layoutPdf(onLayout: (PdfPageFormat format) async {
    return pdf.save();
  });
}

pw.Widget _buildBillRow(pw.Document pdf, String label, double amount, {bool isTotal = false}) {
  // Format the amount to match the currency format (₹)
  String formattedAmount = '₹${amount.toStringAsFixed(2)}';

  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    children: [
      // Label for each row (e.g., Subtotal, Shipping Cost, etc.)
      pw.Text(label, style: pw.TextStyle(fontSize: 14, fontWeight: isTotal ? pw.FontWeight.bold : pw.FontWeight.normal)),
      
      // The formatted amount, in INR
      pw.Text(formattedAmount, style: pw.TextStyle(fontSize: 14, fontWeight: isTotal ? pw.FontWeight.bold : pw.FontWeight.normal)),
    ],
  );
}
