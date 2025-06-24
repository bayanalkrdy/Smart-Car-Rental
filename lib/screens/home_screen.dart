import 'dart:ui';
import 'package:car_rental_app/screens/book_screen.dart';
import 'package:car_rental_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'CarListScreen.dart';
import 'CategoryListScreen.dart';
import 'Chatbot.dart';
import 'Recommendation.dart';
import 'cheak_card.dart';
import 'discount_page.dart';
import 'review_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  double _opacity = 1.0;

// ####################
// ####################
// ####################

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() => _opacity = 1);
    });
  }

// ####################
// ####################
// ####################

  Future<void> _logout(BuildContext context) async {
    // 🔒 Actual logout logic using POST /api/logout (Sanctum)
    // This logic is currently disabled. Uncomment to activate.

    /*
  final url = Uri.parse('https://your-api-url.com/api/logout');
  try {
    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer YOUR_ACCESS_TOKEN', // Replace with actual token
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['message'] == 'Successfully logged out') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Server: Successfully logged out.')),
        );
      }
    } else {
      final error = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout error: ${error['message']}')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Network error: $e')),
    );
  }
  */

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

// ####################
// ####################
// ####################

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 12,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              tooltip: 'Open Menu',
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              splashRadius: 24,
            );
          },
        ),
        centerTitle: true,
        title: const Text(
          '🚗 HomeCar',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: 1.2,
            shadows: [
              Shadow(
                color: Colors.black45,
                blurRadius: 4,
                offset: Offset(2, 2),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.car_crash, color: Colors.white),
              onPressed: () => ()),
        ],
      ),
      drawer: Drawer(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF1E3C72),
                Color(0xFF2A5298),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF00C6FF),
                      Color(0xFF0072FF),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Icon(Icons.car_rental_sharp, color: Colors.white, size: 70),
                    SizedBox(height: 12),
                    Text(
                      'Navigation Menu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        shadows: [
                          Shadow(
                            color: Colors.black54,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              _buildDrawerItem(
                icon: Icons.discount,
                text: 'Discount',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DiscountPage()),
                  );
                },
              ),
              _buildDrawerItem(
                icon: Icons.rate_review,
                text: 'Review',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReviewListScreen()),
                  );
                },
              ),
              _buildDrawerItem(
                icon: Icons.logout,
                text: 'Logout',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: AnimatedOpacity(
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeInOut,
        opacity: _opacity,
        child: Container(
          width: size.width,
          height: size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0F2027),
                Color(0xFF203A43),
                Color(0xFF2C5364),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: Text(
                    '🚀 Car Rental Services',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: const [
                        Shadow(
                          blurRadius: 6,
                          color: Colors.black45,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      children: [
                        _buildGridItem(
                            context, "Car Service", Icons.directions_car),
                        _buildGridItem(
                            context, "Booking Service", Icons.book_online),
                        _buildGridItem(context, "Categories", Icons.category),
                        // Add more if needed
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 12,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white60,
              selectedIconTheme: const IconThemeData(size: 30, shadows: [
                Shadow(
                    color: Colors.white38, blurRadius: 10, offset: Offset(0, 2))
              ]),
              unselectedIconTheme: const IconThemeData(size: 26),
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.chat_bubble), label: 'Chatbot'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.recommend), label: 'Recommend'),
              ],
              onTap: (index) {
                switch (index) {
                  case 1:
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ChatPage()),
                    );
                    break;
                  case 2:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RecommendationPage()),
                    );
                    break;
                  default:
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Home clicked'),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.blueGrey.shade800,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                }
              }),
        ),
      ),
    );
  }

// ####################
// ####################
// ####################

  Widget _buildGridItem(BuildContext context, String title, IconData icon) {
    return GestureDetector(
      onTap: () {
        if (title == "Categories") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CategoryListScreen()),
          );
        } else if (title == "Car Service") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CarListScreen()),
          );
          // Navigate to Car Service page
        } else if (title == "Booking Service") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CheckCardPage()),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0x55FFFFFF), Color(0x30BBDEFB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 14,
                offset: Offset(4, 6),
              ),
              BoxShadow(
                color: Colors.white24,
                blurRadius: 10,
                offset: Offset(-4, -4),
              ),
            ],
            border: Border.all(
              color: Colors.white.withOpacity(0.25),
              width: 1.5,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Colors.amber, Colors.lightBlueAccent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Icon(
                        icon,
                        size: 36,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.8,
                          shadows: [
                            Shadow(
                              color: Colors.black38,
                              blurRadius: 6,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 18,
                      color: Colors.white70,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

// ####################
// ####################
// ####################

  Widget _buildDrawerItem(
      {required IconData icon,
      required String text,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.cyanAccent),
      title: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          shadows: [
            Shadow(
              color: Colors.black26,
              blurRadius: 2,
              offset: Offset(1, 1),
            ),
          ],
        ),
      ),
      onTap: onTap,
      hoverColor: Colors.white12,
      splashColor: Colors.cyan.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
