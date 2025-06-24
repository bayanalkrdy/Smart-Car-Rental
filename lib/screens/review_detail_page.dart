import 'package:flutter/material.dart';

class ReviewDetailPage extends StatelessWidget {
  final Map<String, dynamic> review;

  ReviewDetailPage({required this.review});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Review Details",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 1.2,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.blueAccent, // <-- This sets the back icon color
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
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
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        elevation: 12,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.black.withOpacity(0.4),
      ),

      backgroundColor: const Color(0xFFF5F8FA), // Light blue-grey background
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: const Color(0xFFE3F2FD), // Soft light blue background
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Rating
                Row(
                  children: const [
                    Icon(Icons.star_rounded, color: Colors.amber, size: 30),
                    SizedBox(width: 10),
                  ],
                ),
                Text(
                  'Rating: ${review['rating']} / 5',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xFF203A43),
                  ),
                ),
                const SizedBox(height: 20),

                // Review Comment
                const Text(
                  'Comment:',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Color(0xFF2C5364),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  review['comment'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF37474F),
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 24),
                // Chips
                Wrap(
                  spacing: 12,
                  children: [
                    Chip(
                      label: Text(
                        'Car ID: ${review['car_id']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0F2027),
                        ),
                      ),
                      backgroundColor: Colors.cyanAccent.shade100,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                    Chip(
                      label: Text(
                        'User ID: ${review['user_id']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0F2027),
                        ),
                      ),
                      backgroundColor: Colors.cyanAccent.shade100,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
