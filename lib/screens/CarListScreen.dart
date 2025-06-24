// import 'dart:convert'; // Only needed for real API
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http; // Uncomment when using real API

class CarListScreen extends StatefulWidget {
  @override
  _CarListScreenState createState() => _CarListScreenState();
}

class _CarListScreenState extends State<CarListScreen>
    with TickerProviderStateMixin {
  List<Map<String, dynamic>> cars = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchCars();
  }

// ####################
// ####################
// ####################

  List<Map<String, dynamic>> staticCars = [
    {
      'id': 1,
      'model': 'Tesla Model S',
      'year': 2020,
      'status': 'Available',
      'daily_price': 150,
      'image': 'assets/images/Tesla-Model-S-Plaid.png',
    },
    {
      'id': 2,
      'model': 'BMW 3 Series',
      'year': 2021,
      'status': 'Sold',
      'daily_price': 120,
      'image': 'assets/images/Sunset-Orange.png',
    },
    {
      'id': 3,
      'model': 'Ford Mustang',
      'year': 2022,
      'status': 'Available',
      'daily_price': 180,
      'image': 'assets/images/ford-mustang-2767124_960_720.png',
    },
  ];

// ####################
// ####################
// ####################

  Future<void> fetchCars() async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(Duration(seconds: 2));

    setState(() {
      cars = staticCars;
      isLoading = false;
    });

    // === Real server fetch logic (disabled for now) ===
    /*
    final url = Uri.parse('http://127.0.0.1:8000/api/cars');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        setState(() {
          cars = List<Map<String, dynamic>>.from(decoded);
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load cars.')),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
    */
  }

// ####################
// ####################
// ####################

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 6,
        toolbarHeight: 70,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.blueAccent, // 🔵 Back icon color
        ),
        title: Text(
          "All Cars",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: Colors.white,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.blueAccent),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Icon(Icons.directions_car, color: Colors.white),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.deepPurple))
          : ListView.builder(
              itemCount: cars.length,
              itemBuilder: (context, index) {
                final car = cars[index];
                return AnimatedContainer(
                  duration: Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                        color: Colors.deepPurple.withOpacity(0.1), width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.2),
                        blurRadius: 12,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CarDetailScreen(car: car),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Hero(
                          tag: 'carImage_${car['id']}',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Image.asset(
                              car['image'],
                              width: 200,
                              height: 90,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                car['model'],
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple[900],
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Year: ${car['year']}',
                                style: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 6),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: car['status'] == 'Available'
                                      ? Colors.green[50]
                                      : Colors.red[50],
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: car['status'] == 'Available'
                                        ? Colors.green[300]!
                                        : Colors.red[300]!,
                                  ),
                                ),
                                child: Text(
                                  car['status'],
                                  style: TextStyle(
                                    color: car['status'] == 'Available'
                                        ? Colors.green[800]
                                        : Colors.red[800],
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '\$${car['daily_price']}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[800],
                              ),
                            ),
                            SizedBox(height: 4),
                            Icon(Icons.arrow_forward_ios,
                                size: 16, color: Colors.deepPurple),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// ####################
// ####################
// ####################

class CarDetailScreen extends StatelessWidget {
  final Map<String, dynamic> car;

  CarDetailScreen({required this.car});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true, // Image goes under AppBar
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.blueAccent),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Full-screen hero image with gradient overlay
              Hero(
                tag: car['image'],
                child: Stack(
                  children: [
                    Container(
                      height: 300,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(car['image']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.6),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Car detail section
              Container(
                transform: Matrix4.translationValues(0, -30, 0),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 15,
                      offset: Offset(0, -8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      car['model'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                        color: Colors.deepPurple.shade700,
                      ),
                    ),
                    SizedBox(height: 16),

                    // Year
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calendar_today_rounded,
                            size: 20, color: Colors.grey[600]),
                        SizedBox(width: 6),
                        Text(
                          'Year: ${car['year']}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 14),

                    // Status badge
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: car['status'] == 'Available'
                            ? Colors.green.shade100
                            : Colors.red.shade100,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        car['status'],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: car['status'] == 'Available'
                              ? Colors.green.shade800
                              : Colors.red.shade800,
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Daily price
                    Column(
                      children: [
                        Text(
                          'Daily Price',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '\$${car['daily_price']} / day',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 30),

                    // Rent button
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 8,
                      ),
                      icon: Icon(Icons.car_rental, size: 24),
                      label: Text(
                        "Rent This Car",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('You Rent ${car['model']}'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
