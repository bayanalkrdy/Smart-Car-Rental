import 'package:flutter/material.dart';
import 'discount_detail_page.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

class DiscountPage extends StatelessWidget {
// ####################
// ####################
// ####################

  // Simulated static data
  final List<Map<String, dynamic>> discounts = [
    {
      "id": 1,
      "car_id": 3,
      "discount_value": 20,
      "discount_type": "daily",
      "expiration_date": "2025-05-01",
    },
    {
      "id": 2,
      "car_id": 5,
      "discount_value": 15,
      "discount_type": "weekly",
      "expiration_date": "2025-06-15",
    },
  ];

// ####################
// ####################
// ####################

  // Future<void> fetchDiscounts() async {
  //   final url = Uri.parse('https://your-base-url.com/api/discount');
  //   final response = await http.get(url);
  //   if (response.statusCode == 200) {
  //     final List<dynamic> data = json.decode(response.body);
  //     // Process the data
  //   } else {
  //     throw Exception("Failed to load discounts");
  //   }
  // }

// ####################
// ####################
// ####################

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F3F7),
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 6,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(28),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Discounts",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "Available Offers",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Icon(
              Icons.local_offer_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0F2027),
                Color(0xFF203A43),
                Color(0xFF2C5364),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: discounts.length,
        itemBuilder: (context, index) {
          final discount = discounts[index];
          return Card(
            elevation: 10,
            shadowColor: Colors.black26,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            margin: const EdgeInsets.only(bottom: 20),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DiscountDetailPage(discount: discount),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF2C5364),
                      Color(0xFF203A43),
                      Color(0xFF0F2027),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.local_offer_rounded,
                            color: Colors.amberAccent.shade200, size: 30),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Discount #${discount["id"]} • ${discount["discount_type"].toUpperCase()}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.1,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios_rounded,
                            size: 18, color: Colors.white70),
                      ],
                    ),
                    Divider(
                        height: 24,
                        thickness: 1,
                        color: Colors.white.withOpacity(0.15)),
                    buildDetailRow(
                      icon: Icons.directions_car,
                      text: "Car ID: ${discount["car_id"]}",
                      textColor: Colors.white70,
                      iconColor: Colors.amberAccent,
                    ),
                    SizedBox(height: 8),
                    buildDetailRow(
                      icon: Icons.percent,
                      text: "Value: ${discount["discount_value"]}%",
                      textColor: Colors.white70,
                      iconColor: Colors.amberAccent,
                    ),
                    SizedBox(height: 8),
                    buildDetailRow(
                      icon: Icons.date_range,
                      text: "Expires: ${discount["expiration_date"]}",
                      textColor: Colors.white70,
                      iconColor: Colors.amberAccent,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),

// Helper function for creating the row with icon and text
    );
  }
}

// ####################
// ####################
// ####################

Widget buildDetailRow({
  required IconData icon,
  required String text,
  Color iconColor = Colors.grey,
  Color textColor = Colors.black87,
}) {
  return Row(
    children: [
      Icon(icon, size: 20, color: iconColor),
      SizedBox(width: 10),
      Expanded(
        child: Text(
          text,
          style: TextStyle(fontSize: 16, color: textColor),
        ),
      ),
    ],
  );
}
