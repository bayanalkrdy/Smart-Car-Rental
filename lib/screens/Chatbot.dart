import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String responseText = '';
  bool isLoading = false;
  Map<String, bool> expandedCategories = {};

  final Map<String, List<String>> groupedQuestions = {
    'Rental Process': [
      "What documents are required to rent a car?",
    ],
    'Insurance': [
      "What insurance options do I have when renting a car?",
    ],
    'Age Requirements': [
      "Are there age-based restrictions for luxury cars?",
      "Are there extra charges for young drivers?",
    ],
    'Pickup & Dropoff': [
      "Can I return the car to a different location?",
      "Is it possible to pick up a car at the airport?",
    ],
    'Vehicle Options': [
      "Are electric vehicles available?",
    ],
    'Late Returns': [
      "What fees apply for late returns?",
      "Is there a grace period for late returns?",
      "How is a late return calculated?",
    ],
    'Cancellation': [
      "Can I cancel my reservation?",
      "How long before pickup can I cancel?",
    ],
    'Fuel Policy': [
      "What are your fuel policy options?",
      "Is fuel included in the rental price?",
      "Can I pay for fuel in advance?",
    ],
    'Loyalty Programs': [
      "Do you offer a loyalty program?",
      "What are the benefits of your loyalty program?",
      "How can I earn points when renting?",
    ],
    'Damage Handling': [
      "What happens if I damage the car?",
      "Do I have to pay for minor scratches?",
      "Is there a deductible for damages?",
    ],
  };

  Future<void> askQuestion(
      BuildContext context, String prompt, IconData icon) async {
    setState(() {
      isLoading = true;
      responseText = '';
    });

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/car_rental/chatbot/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'prompt': prompt}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        responseText = data['response'] ?? 'No response.';
      } else {
        responseText = 'Server error: ${response.statusCode}';
      }
    } catch (e) {
      responseText = 'Error: $e';
    }

    setState(() {
      isLoading = false;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Hero(
              tag: prompt,
              child: Icon(icon, color: Colors.blueAccent, size: 28),
            ),
            const SizedBox(width: 8),
            const Text("Chatbot Response"),
          ],
        ),
        content: SingleChildScrollView(
          child: Text(responseText),
        ),
        actions: [
          TextButton(
            child: const Text("Close"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, IconData> categoryIcons = {
      'Rental Process': Icons.assignment,
      'Insurance': Icons.security,
      'Age Requirements': Icons.cake,
      'Pickup & Dropoff': Icons.location_on,
      'Vehicle Options': Icons.electric_car,
      'Late Returns': Icons.access_time,
      'Cancellation': Icons.cancel,
      'Fuel Policy': Icons.local_gas_station,
      'Loyalty Programs': Icons.card_giftcard,
      'Damage Handling': Icons.build,
    };

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.child_care_outlined, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "Chatbot",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                letterSpacing: 1.2,
                color: Colors.white,
              ),
            ),
          ],
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
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
        backgroundColor: Colors.transparent,
        shadowColor: Colors.black.withOpacity(0.4),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        elevation: 10,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: groupedQuestions.entries.map((entry) {
                final category = entry.key;
                final icon = categoryIcons[category] ?? Icons.help_outline;
                final isExpanded = expandedCategories[category] ?? false;

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ExpansionTile(
                    leading: Hero(
                      tag: category,
                      child: Icon(icon, color: Colors.blueAccent),
                    ),
                    title: Text(
                      category,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    initiallyExpanded: isExpanded,
                    onExpansionChanged: (expanded) {
                      setState(() {
                        expandedCategories[category] = expanded;
                      });
                    },
                    children: entry.value.map((question) {
                      return ListTileTheme(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        child: ListTile(
                          title: Text(
                            question,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          trailing:
                              const Icon(Icons.send, color: Colors.blueAccent),
                          onTap: () => askQuestion(context, question, icon),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }).toList(),
            ),
          ),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
