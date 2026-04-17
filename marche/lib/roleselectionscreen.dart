import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart'; 
//import 'customer/homescreen.dart';
import 'package:marche/splashscreen.dart';

class RoleDecisionPage extends StatefulWidget {
  const RoleDecisionPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RoleDecisionPageState createState() => _RoleDecisionPageState();
}

class _RoleDecisionPageState extends State<RoleDecisionPage> {
  @override
  void initState() {
    super.initState();
  }

  void _saveRoleAndNavigate(String role) {
    _navigateToRolePage(role); 
  }

  void _navigateToRolePage(String role) {
    switch (role) {
      case 'Customer':
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const PageViewScreen()),
          (Route<dynamic> route) => false,
        );
        break;
      case 'Admin':
      case 'Validator':
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (_) => const MyHomePage(title: '')),
        // );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final gradientColors = isDarkMode
        ? [Colors.black, Colors.black]
        : [Colors.white, Colors.white];

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/animation/roleselectionpage_animation.json',
                    width: 200,
                    height: 200,
                    fit: BoxFit.fill,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Select Your Role',
                    style: GoogleFonts.aboreto(
                      fontSize: 30,
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildCardSwiper(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardSwiper() {
    List<Map<String, dynamic>> roles = [
      {'role': 'Admin', 'color': Colors.orangeAccent, 'icon': Icons.admin_panel_settings},
      {'role': 'Customer', 'color': Colors.greenAccent, 'icon': Icons.person},
      {'role': 'Validator', 'color': Colors.redAccent, 'icon': Icons.check_circle},
    ];

    return SizedBox(
      width: 400,
      height: 400,
      child: CardSwiper(
        cardsCount: roles.length,
        cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
          return GestureDetector(
            onTap: () => _saveRoleAndNavigate(roles[index]['role']),
            child: _buildCard(roles[index]['role'], roles[index]['color'], roles[index]['icon']),
          );
        },
      ),
    );
  }

  Widget _buildCard(String role, Color color, IconData icon) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: color,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              role,
              style: const TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
