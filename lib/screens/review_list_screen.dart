// import 'dart:convert'; // For future real API use
import 'package:car_rental_app/screens/review_detail_page.dart';
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http; // Uncomment when using real API

class ReviewListScreen extends StatefulWidget {
  @override
  _ReviewListScreenState createState() => _ReviewListScreenState();
}

class _ReviewListScreenState extends State<ReviewListScreen> {
// ####################
// ####################
// ####################

  List<Map<String, dynamic>> reviews = [];
  bool isLoading = false;

// ####################
// ####################
// ####################

  // Simulated static review data
  final List<Map<String, dynamic>> staticReviews = [
    {
      "id": 1,
      "user_id": 2,
      "car_id": 10,
      "rating": 5,
      "comment": "Very excellent car",
    },
    {
      "id": 2,
      "user_id": 3,
      "car_id": 5,
      "rating": 4,
      "comment": "Smooth ride and great handling.",
    },
    {
      "id": 3,
      "user_id": 1,
      "car_id": 3,
      "rating": 3,
      "comment": "Average experience, could be better.",
    },
  ];

// ####################
// ####################
// ####################

  void showAddReviewDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final userIdController = TextEditingController();
    final carIdController = TextEditingController();
    final ratingController = TextEditingController();
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        title: const Text(
          "Add Review",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.teal,
            letterSpacing: 0.8,
          ),
        ),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildStyledField(
                  controller: userIdController,
                  label: "User ID",
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? "User ID is required" : null,
                ),
                const SizedBox(height: 12),
                _buildStyledField(
                  controller: carIdController,
                  label: "Car ID",
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? "Car ID is required" : null,
                ),
                const SizedBox(height: 12),
                _buildStyledField(
                  controller: ratingController,
                  label: "Rating (1-5)",
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Rating required";
                    }
                    final rating = int.tryParse(value);
                    if (rating == null || rating < 1 || rating > 5) {
                      return "Enter a valid rating (1-5)";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                _buildStyledField(
                  controller: commentController,
                  label: "Comment",
                  maxLines: 2,
                  validator: (value) =>
                      value!.isEmpty ? "Comment is required" : null,
                ),
              ],
            ),
          ),
        ),
        actionsPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancel",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final newReview = {
                  "id": reviews.length + 1,
                  "user_id": int.parse(userIdController.text),
                  "car_id": int.parse(carIdController.text),
                  "rating": int.parse(ratingController.text),
                  "comment": commentController.text,
                };

                setState(() {
                  reviews.add(newReview);
                });

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Review added successfully")),
                );

                // Uncomment and replace this block to send to real API
              }
            },
            icon: const Icon(Icons.send),
            label: const Text("Submit"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

// ####################
// ####################
// ####################

  Widget _buildStyledField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(color: Colors.white), // Input text color
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Color.fromARGB(255, 37, 44, 44),
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        filled: true,
        fillColor:
            const Color(0xFF2C5364).withOpacity(0.2), // Subtle background tint
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.cyanAccent, width: 2),
          borderRadius: BorderRadius.circular(14),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.cyanAccent.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(14),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.redAccent),
          borderRadius: BorderRadius.circular(14),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

// ####################
// ####################
// ####################

  @override
  void initState() {
    super.initState();
    fetchReviews();
  }

// ####################
// ####################
// ####################

  Future<void> fetchReviews() async {
    setState(() {
      isLoading = true;
    });

    // Simulate loading delay
    await Future.delayed(Duration(seconds: 1));

    // === Uncomment for real API connection ===
    /*
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/reviews'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          reviews = List<Map<String, dynamic>>.from(data['reviews']);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load reviews')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
    */

// Future<void> getReviewById(BuildContext context) async {
//   final TextEditingController idController = TextEditingController();

//   await showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       title: const Text("Find Review by ID"),
//       content: TextFormField(
//         controller: idController,
//         keyboardType: TextInputType.number,
//         decoration: const InputDecoration(
//           labelText: "Enter Review ID",
//           border: OutlineInputBorder(),
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text("Cancel"),
//         ),
//         ElevatedButton(
//           onPressed: () async {
//             final id = idController.text.trim();
//             Navigator.pop(context);
//             if (id.isNotEmpty) {
//               final url = Uri.parse('http://127.0.0.1:8000/api/reviews/$id');

//               try {
//                 final response = await http.get(url);

//                 if (response.statusCode == 200) {
//                   final data = jsonDecode(response.body);
//                   showDialog(
//                     context: context,
//                     builder: (context) => AlertDialog(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       title: const Text("Review Details"),
//                       content: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text("ID: ${data['id']}"),
//                           Text("User ID: ${data['user_id']}"),
//                           Text("Car ID: ${data['car_id']}"),
//                           Text("Rating: ${data['rating']} / 5"),
//                           Text("Comment: ${data['comment']}"),
//                         ],
//                       ),
//                       actions: [
//                         TextButton(
//                           onPressed: () => Navigator.pop(context),
//                           child: const Text("Close"),
//                         ),
//                       ],
//                     ),
//                   );
//                 } else {
//                   final error = jsonDecode(response.body);
//                   final message = error["message"] ?? "Rating not found";
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text(message)),
//                   );
//                 }
//               } catch (e) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text("Error: $e")),
//                 );
//               }
//             }
//           },
//           child: const Text("Search"),
//         ),
//       ],
//     ),
//   );
// }

    // Use static data
    setState(() {
      reviews = staticReviews;
      isLoading = false;
    });
  }

// ####################
// ####################
// ####################

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showAddReviewDialog(context),
        backgroundColor: const Color(0xFF203A43), // Matches AppBar gradient
        foregroundColor: Colors.white, // Keeps icon/text readable
        icon: const Icon(
          Icons.rate_review,
          size: 26,
          color: Colors.cyanAccent, // Accent color for icon pop
        ),
        label: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            "Add Review",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
              color: Colors.white,
            ),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Smoother curve
          side: BorderSide(
            color:
                Colors.cyanAccent.withOpacity(0.7), // Subtle border highlight
            width: 1.2,
          ),
        ),
        elevation: 10,
        splashColor: Colors.cyanAccent.withOpacity(0.3),
        hoverElevation: 12,
        tooltip: "Click to add a new review",
      ),
      appBar: AppBar(
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
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(10),
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.blueAccent, // Set back icon color here
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Reviews',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        elevation: 8,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.blueAccent),
            onPressed: () {
              fetchReviews(); // Refresh reviews
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: ListView.builder(
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  final review = reviews[index];
                  return GestureDetector(
                    onTap: () {
                      // Navigate to the ReviewDetailPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ReviewDetailPage(review: review),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: Colors.blueGrey[50],
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    color: Colors.amber, size: 24),
                                const SizedBox(width: 6),
                                Text(
                                  'Rating: ${review['rating']} / 5',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              review['comment'],
                              style: const TextStyle(
                                fontSize: 15,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Chip(
                                  label: Text('Car ID: ${review['car_id']}'),
                                  backgroundColor: Colors.teal[100],
                                ),
                                Chip(
                                  label: Text('User ID: ${review['user_id']}'),
                                  backgroundColor: Colors.teal[100],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

// ####################
// ####################
// ####################

