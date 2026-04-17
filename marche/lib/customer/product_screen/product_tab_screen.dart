import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marche/customer/productgrid1.dart';
import 'package:marche/customer/productgrid2.dart';
import 'package:marche/customer/productgrid3.dart';
import 'package:marche/customer/productgrid4.dart';

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  late bool isDarkMode;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Products"),
        backgroundColor: isDarkMode
            ? Colors.black
            : const Color.fromARGB(255, 191, 244, 99),
        titleTextStyle: GoogleFonts.aboreto(
          fontSize: 30,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              children: [
                Icon(
                  Icons.shopping_cart,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                const SizedBox(width: 8.0),
                Text(
                  'Grocery',
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                ),
              ],
            ),
          ),
          const ProductGridWidget(productGrid: productgrid1()),
          const ProductGridWidget(productGrid: productgrid2()),
          const ProductGridWidget(productGrid: productgrid3()),
          const ProductGridWidget(productGrid: productgrid4()),
        ],
      ),
    );
  }
}

class ProductGridWidget extends StatelessWidget {
  final Widget productGrid;
  
  const ProductGridWidget({super.key, required this.productGrid});

  @override
  Widget build(BuildContext context) {
    return KeepAliveWidget(
      child: productGrid,
    );
  }
}

class KeepAliveWidget extends StatefulWidget {
  final Widget child;

  const KeepAliveWidget({super.key, required this.child});

  @override
  // ignore: library_private_types_in_public_api
  _KeepAliveWidgetState createState() => _KeepAliveWidgetState();
}

class _KeepAliveWidgetState extends State<KeepAliveWidget>
    with AutomaticKeepAliveClientMixin<KeepAliveWidget> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
