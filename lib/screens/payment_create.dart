import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

import 'PaymentsList.dart';

class PaymentsPage extends StatefulWidget {
  final Map<String, dynamic> booking;

  const PaymentsPage({super.key, required this.booking});

  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  final _formKey = GlobalKey<FormState>();

  String _paymentMethod = 'credit_card';
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _invoiceController = TextEditingController();

  bool _isSubmitting = false;
  String? _errorMessage;
// Somewhere globally accessible for simulation (e.g., top of file or separate service class)
  List<Map<String, dynamic>> simulatedPayments = [];

  Future<void> _submitPayment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final payload = {
      "id": DateTime.now().millisecondsSinceEpoch, // unique simulated ID
      "booking_id": widget.booking['id'],
      "payment_method": _paymentMethod,
      "amount": double.tryParse(_amountController.text),
      "status": "completed",
      "invoice":
          _invoiceController.text.isNotEmpty ? _invoiceController.text : null,
    };

    // =========================
    // ✅ REAL API CALL SECTION
    // =========================
    /*
try {
  final response = await http.post(
    Uri.parse("http://127.0.0.1:8000/payments"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(payload),
  );

  final data = jsonDecode(response.body);

  if (response.statusCode == 201) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✅ Payment added successfully")),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => PaymentsListPage()),
    );
  } else if (response.statusCode == 422) {
    setState(() {
      _errorMessage = data['message'] ?? "Validation error";
    });
  } else {
    setState(() {
      _errorMessage = "Unexpected error: ${response.statusCode}";
    });
  }
} catch (e) {
  setState(() {
    _errorMessage = "Network error: $e";
  });
}
*/

    // =========================
    // 🧪 SIMULATION SECTION
    // =========================
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      if (payload["amount"] == null || payload["amount"]! <= 0) {
        setState(() {
          _errorMessage = "Amount must be greater than 0.";
          _isSubmitting = false;
        });
        return;
      }

      // Save payment to local simulation store
      simulatedPayments.add(payload);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Payment added successfully")),
      );

      // Navigate to PaymentDetailsPage with newly created payment
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentsListPage(payments: simulatedPayments),
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = "Simulation error: $e";
      });
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _invoiceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create Payment",
          style: TextStyle(
            color: Colors.white, // Title color set to white
            fontWeight: FontWeight.bold, // Make the font bold
            fontSize: 20, // Adjust font size for a more modern look
            fontFamily:
                'Roboto', // Modern font family (you can change it to any other modern font)
          ),
        ),
        centerTitle: true, // Keep the title centered
        backgroundColor: Colors
            .transparent, // Make AppBar background transparent so the gradient can show through
        iconTheme: IconThemeData(
          color: Colors.blueAccent, // Set back icon color to blue accent
        ),
        actions: [
          IconButton(
            icon: Icon(Icons
                .skip_next), // Use an icon for skipping (could be an arrow or similar)
            onPressed: () {
              // Navigate to the PaymentsListPage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentsListPage(
                      payments:
                          simulatedPayments), // Navigate to your PaymentsListPage
                ),
              );
            },
            color: Colors.blueAccent, // Ensure the icon is blue accent
          ),
        ],
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Booking ID
              Text(
                "Booking ID: ${widget.booking['id'] ?? 'saved'}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4CAF50), // Green accent for fresh feel
                ),
              ),
              const SizedBox(height: 20),

              // Payment Method Dropdown
              DropdownButtonFormField<String>(
                value: _paymentMethod,
                decoration: InputDecoration(
                  labelText: "Payment Method",
                  labelStyle: const TextStyle(
                    color:
                        Color.fromARGB(255, 73, 114, 114), // Green accent label
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.9),
                ),
                items: const [
                  DropdownMenuItem(
                      value: "credit_card", child: Text("Credit Card")),
                  DropdownMenuItem(value: "paypal", child: Text("PayPal")),
                  DropdownMenuItem(value: "cash", child: Text("Cash")),
                ],
                onChanged: (value) {
                  setState(() {
                    _paymentMethod = value!;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Amount Field
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: "Amount",
                  labelStyle:
                      const TextStyle(color: Color.fromARGB(255, 73, 114, 114)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.9),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Amount is required";
                  }
                  final parsed = double.tryParse(value);
                  if (parsed == null || parsed <= 0) {
                    return "Enter a valid amount";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Invoice Field
              TextFormField(
                controller: _invoiceController,
                decoration: InputDecoration(
                  labelText: "Invoice (optional)",
                  labelStyle:
                      const TextStyle(color: Color.fromARGB(255, 73, 114, 114)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 30),

              // Error Message
              if (_errorMessage != null) ...[
                Text(
                  _errorMessage!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
              ],

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(
                    Icons.payment,
                    size: 24,
                  ),
                  label: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Text(
                          "Submit Payment",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight.w600, // Slightly lighter weight
                            color: Colors
                                .white, // White text on button for contrast
                          ),
                        ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Color(0xFF4CAF50), // Green background
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12), // Rounded corners
                    ),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold, // Bold text
                      fontSize: 18, // Larger text for emphasis
                    ),
                  ),
                  onPressed: _isSubmitting ? null : _submitPayment,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
