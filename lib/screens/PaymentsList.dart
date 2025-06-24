import 'package:flutter/material.dart';

import 'p_details_page.dart';

// 🔁 Move this to a separate service file if needed
List<Map<String, dynamic>> simulatedPayments = [];

class PaymentsListPage extends StatefulWidget {
  final List<Map<String, dynamic>>? payments; // nullable list

  const PaymentsListPage({super.key, this.payments});

  @override
  State<PaymentsListPage> createState() => _PaymentsListPageState();
}

class _PaymentsListPageState extends State<PaymentsListPage> {
  late Future<List<Map<String, dynamic>>> _paymentsFuture;

  @override
  void initState() {
    super.initState();
    _paymentsFuture = fetchPayments();
  }

  Future<List<Map<String, dynamic>>> fetchPayments() async {
    await Future.delayed(const Duration(seconds: 1)); // simulate delay

// ===== REAL BACKEND CALL (currently commented for simulation) =====
    // final response =
    //     await http.get(Uri.parse('http://127.0.0.1:8000/payments'));

    // if (response.statusCode == 200) {
    //   final List<dynamic> data = jsonDecode(response.body);
    //   return data.cast<Map<String, dynamic>>();
    // } else {
    //   throw Exception('Failed to load payments: ${response.statusCode}');
    // }

    // Default static payments
    List<Map<String, dynamic>> defaultPayments = [
      {
        "id": 1,
        "booking_id": 5,
        "payment_method": "credit_card",
        "amount": 200.5,
        "status": "completed",
        "invoice": "INV-20250401"
      },
      {
        "id": 2,
        "booking_id": 7,
        "payment_method": "cash",
        "amount": 150.0,
        "status": "pending",
        "invoice": null
      },
      {
        "id": 3,
        "booking_id": 8,
        "payment_method": "paypal",
        "amount": 300.75,
        "status": "completed",
        "invoice": "INV-20250402"
      },
    ];

    // Combine default with any simulated/newly added payments
    if (widget.payments != null && widget.payments!.isNotEmpty) {
      return [...defaultPayments, ...widget.payments!];
    }

    return defaultPayments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "All Payments",
          style: TextStyle(
            color: Colors.white, // Set title color to white
            fontWeight: FontWeight.bold, // Make the title bold
            fontSize: 20, // Adjust font size as needed
            fontFamily: 'Roboto', // You can change to another font if you want
          ),
        ),
        centerTitle: true, // Center the title
        backgroundColor:
            Colors.transparent, // Make AppBar background transparent
        iconTheme: IconThemeData(
          color: Colors.blueAccent, // Set back icon color to blue accent
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0F2027), // Dark color for the gradient
                Color(0xFF203A43), // Medium dark
                Color(0xFF2C5364), // Lighter blue-green
              ],
              begin: Alignment.topLeft, // Gradient begins from the top left
              end: Alignment.bottomRight, // Ends at the bottom right
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _paymentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "❌ ${snapshot.error}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "No payments found.",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.blueAccent,
                ),
              ),
            );
          }

          final payments = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: payments.length,
            itemBuilder: (context, index) {
              final payment = payments[index];

              return GestureDetector(
                onTap: () {
                  // Navigate to the details page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PaymentDetailsPage(payment: payment),
                    ),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 8,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  color: Colors.white,
                  shadowColor: Colors.black.withOpacity(0.1),
                  child: ListTile(
                    leading: Icon(
                      Icons.attach_money,
                      color: Colors.greenAccent,
                    ),
                    title: Text(
                      "Payment #${payment['id']} - \$${payment['amount']}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        "Method: ${payment['payment_method']}\nStatus: ${payment['status']}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    trailing: Text(
                      payment['invoice'] ?? 'No invoice',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
