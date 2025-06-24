import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

import 'Booking_List.dart';
import 'home_screen.dart';

class BookScreen extends StatefulWidget {
  const BookScreen({Key? key}) : super(key: key);

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _carIdController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  String _status = 'pending';
  String _responseMessage = '';
  bool _isLoading = false;

  List<Map<String, dynamic>> bookings =
      []; // Global or lifted state depending on architecture

  Future<void> _submitBooking() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _responseMessage = '';
    });

    final payload = {
      "user_id": int.tryParse(_userIdController.text),
      "car_id": int.tryParse(_carIdController.text),
      "start_date": _startDateController.text,
      "end_date": _endDateController.text,
      "location": _locationController.text,
      "status": _status,
    };

    await Future.delayed(Duration(seconds: 1)); // simulate processing delay

    // 🔴 Commented real backend request
    /*
  try {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/bookings'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(payload),
    );
    ...
  } catch (e) {
    ...
  }
  */

    setState(() {
      _isLoading = false;
      bookings.add(payload); // Add to in-memory simulated booking list
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("✅ Booking created successfully!")),
    );

    // Navigate to booking list
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => BookingListPage(bookings: bookings)),
    );
  }

  String? _validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  Widget _buildInputField(String label, TextEditingController controller,
      [TextInputType? inputType]) {
    return TextFormField(
      controller: controller,
      decoration: _inputDecoration(label),
      keyboardType: inputType ?? TextInputType.text,
      validator: _validateRequired,
      style: const TextStyle(color: Colors.white), // Make typed text white
      cursorColor: Colors.cyanAccent, // Optional: Matches your theme
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white24),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white30),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.cyanAccent, width: 2),
      ),
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
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
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.blueAccent),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
            ),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.directions_car, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Book Car 🚗',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.skip_next, color: Colors.blueAccent),
                tooltip: 'Go to Book List',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => BookingListPage(bookings: bookings)),
                  );
                },
              ),
            ],
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Center(
            child: Card(
              elevation: 12,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Colors.black.withOpacity(0.4),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      const Text(
                        "🚗 Book Your Car",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      _buildInputField(
                          "User ID", _userIdController, TextInputType.number),
                      const SizedBox(height: 16),
                      _buildInputField(
                          "Car ID", _carIdController, TextInputType.number),
                      const SizedBox(height: 16),
                      _buildInputField(
                          "Start Date (YYYY-MM-DD)", _startDateController),
                      const SizedBox(height: 16),
                      _buildInputField(
                          "End Date (YYYY-MM-DD)", _endDateController),
                      const SizedBox(height: 16),
                      _buildInputField("Pickup Location", _locationController),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        dropdownColor: const Color(0xFF2C5364),
                        value: _status,
                        items: const [
                          DropdownMenuItem(
                              value: 'pending', child: Text('Pending')),
                          DropdownMenuItem(
                              value: 'confirmed', child: Text('Confirmed')),
                          DropdownMenuItem(
                              value: 'cancelled', child: Text('Cancelled')),
                        ],
                        onChanged: (value) => setState(() => _status = value!),
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration("Booking Status"),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton.icon(
                        onPressed: _isLoading ? null : _submitBooking,
                        icon: const Icon(Icons.send),
                        label: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text("Submit Booking"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyanAccent.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          elevation: 6,
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (_responseMessage.isNotEmpty)
                        Text(
                          _responseMessage,
                          style: TextStyle(
                            fontSize: 16,
                            color: _responseMessage.contains("successfully")
                                ? Colors.greenAccent
                                : Colors.redAccent,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
