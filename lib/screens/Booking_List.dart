import 'package:flutter/material.dart';
import 'BookingDetails.dart';

class BookingListPage extends StatefulWidget {
  final List<Map<String, dynamic>> bookings;

  const BookingListPage({required this.bookings});

  @override
  _BookingListPageState createState() => _BookingListPageState();
}

class _BookingListPageState extends State<BookingListPage> {
  void _cancelBooking(int index) async {
    final booking = widget.bookings[index];

    // === Real Cancel Logic (Commented) ===
    /*
    final bookingId = booking['id']; // Ensure your bookings contain 'id'

    final url = Uri.parse('https://yourapi.com/bookings/$bookingId/cancel');

    try {
      final response = await http.put(url);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          widget.bookings.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("✅ ${responseData['message']}")),
        );
      } else if (response.statusCode == 404) {
        final responseData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("⚠️ ${responseData['message']}")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("⚠️ Unexpected error occurred.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Network error: $e")),
      );
    }
    */

    // === Temporary Local Cancel Logic ===
    setState(() {
      widget.bookings.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("❌ Booking cancelled.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          automaticallyImplyLeading: true,
          iconTheme:
              const IconThemeData(color: Colors.blueAccent), // <-- icon color
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
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Bookings",
            style: TextStyle(
              color: Colors.white, // <-- title color
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: widget.bookings.isEmpty
          ? const Center(
              child: Text(
                "No bookings yet.",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          : ListView.builder(
              itemCount: widget.bookings.length,
              itemBuilder: (context, index) {
                final booking = widget.bookings[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              BookingDetailsPage(booking: booking),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "User #${booking['user_id']} - Car #${booking['car_id']}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF203A43),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  size: 16, color: Colors.blueGrey),
                              const SizedBox(width: 6),
                              Text(
                                "From ${booking['start_date']} to ${booking['end_date']}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  size: 16, color: Colors.blueGrey),
                              const SizedBox(width: 6),
                              Text(
                                "Location: ${booking['location']}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.info,
                                  size: 16, color: Colors.blueGrey),
                              const SizedBox(width: 6),
                              Text(
                                "Status: ${booking['status']}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: booking['status'] == 'Cancelled'
                                      ? Colors.red
                                      : Colors.green,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed: () => _cancelBooking(index),
                              icon: const Icon(Icons.cancel, color: Colors.red),
                              label: const Text(
                                'Cancel',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
