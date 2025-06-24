import 'package:flutter/material.dart';

class DiscountDetailPage extends StatelessWidget {
  final Map<String, dynamic> discount;

  const DiscountDetailPage({super.key, required this.discount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(35),
          ),
        ),
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
        shadowColor: Colors.black.withOpacity(0.4),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 28,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        centerTitle: true,
        title: Text(
          "Discount Details",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Card(
          elevation: 14,
          shadowColor: Colors.black.withOpacity(0.15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: Container(
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
              borderRadius: BorderRadius.circular(28),
            ),
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "🎯 Discount ID: ${discount['id']}",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.1,
                  ),
                ),
                SizedBox(height: 24),
                buildDetailRow(
                  icon: Icons.directions_car,
                  text: "Car ID: ${discount['car_id']}",
                ),
                SizedBox(height: 18),
                buildDetailRow(
                  icon: Icons.percent,
                  text: "Discount Value: ${discount['discount_value']}%",
                ),
                SizedBox(height: 18),
                buildDetailRow(
                  icon: Icons.timeline,
                  text: "Type: ${discount['discount_type']}",
                ),
                SizedBox(height: 18),
                buildDetailRow(
                  icon: Icons.event_available,
                  text: "Expires on: ${discount['expiration_date']}",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ####################
// ####################
// ####################
Widget buildDetailRow({required IconData icon, required String text}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(
        icon,
        size: 26,
        color: Colors.white,
      ),
      SizedBox(width: 14),
      Expanded(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ),
    ],
  );
}
