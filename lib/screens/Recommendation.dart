import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RecommendationPage extends StatefulWidget {
  const RecommendationPage({super.key});

  @override
  _RecommendationPageState createState() => _RecommendationPageState();
}

class _RecommendationPageState extends State<RecommendationPage> {
  final TextEditingController _queryController = TextEditingController();
  int? _minPrice;
  int? _maxPrice;
  bool _isLoading = false;
  List<dynamic> _recommendations = [];

  final List<int> priceOptions = List.generate(10, (index) => (index + 1) * 10);

  final List<String> queryExamples = [
    'Toyota SUV automatic GPS',
    'BMW sedan leather seats',
    'manual SUV sunroof',
  ];

  // Function to fetch recommendations
  Future<void> fetchRecommendations() async {
    if (_queryController.text.isEmpty ||
        _minPrice == null ||
        _maxPrice == null) {
      return; // Do not proceed if any field is empty
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/car_rental/recommend/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'query': _queryController.text,
          'min_price': _minPrice,
          'max_price': _maxPrice,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _recommendations = data['recommendations'] ?? [];
        });
      } else {
        // Handle server error
        setState(() {
          _recommendations = [];
        });
      }
    } catch (e) {
      // Handle error
      setState(() {
        _recommendations = [];
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Recommendations",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 1.2,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 10,
        shadowColor: Colors.black.withOpacity(0.4),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dream Car Label
            Row(
              children: const [
                Icon(Icons.directions_car, color: Colors.amber, size: 28),
                SizedBox(width: 10),
                Text(
                  'Search your dream car',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF203A43),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Search Field + Examples
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _queryController,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Toyota SUV automatic GPS',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Color(0xFFE1ECF4),
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: queryExamples.map((example) {
                    return ActionChip(
                      label: Text(
                        example,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                      backgroundColor: const Color(0xFFB0BEC5),
                      labelStyle: const TextStyle(color: Colors.black),
                      onPressed: () {
                        _queryController.text = example;
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Min Price Dropdown
            DropdownButtonFormField<int>(
              value: _minPrice,
              onChanged: (value) => setState(() => _minPrice = value),
              decoration: const InputDecoration(
                labelText: 'Min Price',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color(0xFFCFD8DC),
              ),
              items: priceOptions.map((price) {
                return DropdownMenuItem<int>(
                  value: price,
                  child: Text('\$$price'),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Max Price Dropdown
            DropdownButtonFormField<int>(
              value: _maxPrice,
              onChanged: (value) => setState(() => _maxPrice = value),
              decoration: const InputDecoration(
                labelText: 'Max Price',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color(0xFFCFD8DC),
              ),
              items: priceOptions.map((price) {
                return DropdownMenuItem<int>(
                  value: price,
                  child: Text('\$$price'),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.recommend, color: Colors.white),
                onPressed: fetchRecommendations,
                label: const Text('Get Recommendations'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF203A43),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),

            if (_isLoading) const Center(child: CircularProgressIndicator()),

            if (!_isLoading && _recommendations.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _recommendations.length,
                  itemBuilder: (context, index) {
                    final car = _recommendations[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      color: const Color(0xFFE0F7FA),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text('${car['brand']} ${car['model']}'),
                        subtitle: Text(
                          'Click for details',
                          style: TextStyle(color: Colors.blueGrey.shade700),
                        ),
                        trailing: const Icon(Icons.info_outline,
                            color: Colors.blueGrey),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              title: Text('${car['brand']} ${car['model']}'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Price: \$${car['price_per_day']} / day'),
                                  const SizedBox(height: 8),
                                  Text('Transmission: ${car['transmission']}'),
                                  const SizedBox(height: 8),
                                  Text(
                                      'Features: ${car['features'].join(', ')}'),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Close"),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),

            if (!_isLoading && _recommendations.isEmpty)
              const Center(child: Text("No recommendations found")),
          ],
        ),
      ),
    );
  }
}
