// import 'dart:convert'; // Uncomment when using real API
// import 'package:http/http.dart' as http; // Uncomment when using real API

import 'package:flutter/material.dart';

class CategoryListScreen extends StatefulWidget {
  @override
  _CategoryListScreenState createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
// ####################
// ####################
// ####################

  List categories = [
    // Simulated static data
    {
      'id': 1,
      'name': 'Category A',
      'description': 'Description for Category A',
    },
    {
      'id': 2,
      'name': 'Category B',
      'description': 'Description for Category B',
    },
    {
      'id': 3,
      'name': 'Category C',
      'description': 'Description for Category C',
    },
    {
      'id': 4,
      'name': 'Category D',
      'description': 'Description for Category D',
    },
  ];

  bool isLoading = false; // Set to false to simulate static data being loaded

  // Future<void> fetchCategories() async {
  //   final response =
  //       await http.get(Uri.parse('https://your_base_url/api/categories'));

  //   if (response.statusCode == 200) {
  //     setState(() {
  //       categories = jsonDecode(response.body);
  //       isLoading = false;
  //     });
  //   } else {
  //     setState(() => isLoading = false);
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text('Failed to load categories'),
  //       backgroundColor: Colors.red,
  //     ));
  //   }
  // }

// ####################
// ####################
// ####################

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Categories",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          // Gradient background
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0F2027),
                  Color(0xFF203A43),
                  Color(0xFF2C5364)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Custom back icon
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.blueAccent,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.car_rental, color: Colors.blueAccent),
              onPressed: () {
                // Handle search or car rental action
              },
            ),
          ],
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.deepPurple,
                  strokeWidth: 5,
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple.shade50, Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return TweenAnimationBuilder(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                      tween: Tween<double>(begin: 0.9, end: 1),
                      builder: (context, value, child) => Transform.scale(
                        scale: value,
                        child: child,
                      ),
                      child: Card(
                        elevation: 8,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        shadowColor: Colors.deepPurple.withOpacity(0.2),
                        color: Colors.white,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(24),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CategoryDetailScreen(category: category),
                              ),
                            );
                          },
                          splashColor: Colors.deepPurple.withOpacity(0.1),
                          highlightColor: Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 26,
                                  backgroundColor: Colors.deepPurple.shade100,
                                  child: Icon(Icons.category,
                                      color: Colors.deepPurple.shade700,
                                      size: 28),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        category['name'],
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.deepPurple.shade800,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        category['description'],
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade600,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios_rounded,
                                    color: Colors.deepPurple.shade400),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ));
  }
}

// ####################
// ####################
// ####################

class CategoryDetailScreen extends StatelessWidget {
  final Map category;

  CategoryDetailScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        title: Text(
          category['name'],
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        // Gradient background
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        // Custom back icon

        leading: IconButton(
          icon:
              Icon(Icons.arrow_back_ios_new_rounded, color: Colors.blueAccent),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline_rounded, color: Colors.blueAccent),
            tooltip: 'Info',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("This is a sample action.")),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          shadowColor: Colors.deepPurple.withOpacity(0.3),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.deepPurple.shade100,
                      child: Icon(Icons.category,
                          color: Colors.deepPurple, size: 32),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        category['name'],
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.deepPurple.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: 40,
                  thickness: 1.2,
                  color: Colors.deepPurple.shade100,
                ),
                Text(
                  "📝 Description",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.deepPurple.shade700,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  category['description'],
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.4,
                    color: Colors.grey.shade800,
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  "🆔 Category ID",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.deepPurple.shade700,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  category['id'].toString(),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade800,
                  ),
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
