import 'package:car_rental_app/screens/book_screen.dart';
import 'package:flutter/material.dart';

class PaymentDetailsPage extends StatefulWidget {
  final Map<String, dynamic> payment;

  PaymentDetailsPage({required this.payment});

  @override
  _PaymentDetailsPageState createState() => _PaymentDetailsPageState();
}

class _PaymentDetailsPageState extends State<PaymentDetailsPage> {
  late Map<String, dynamic> payment;

  @override
  void initState() {
    super.initState();
    payment = widget.payment; // Initialize payment with the provided data
  }

  // Function to handle cancel simulation
  void _cancelSimulation() {
    // If you want to navigate back or remove the payment, you can pop the page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const BookScreen()),
    );
  }

  // Function to handle update simulation
  void _updateSimulation() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController amountController =
            TextEditingController(text: payment['amount'].toString());
        TextEditingController methodController =
            TextEditingController(text: payment['payment_method']);
        TextEditingController statusController =
            TextEditingController(text: payment['status']);

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          title: Text(
            "Update Payment Details",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.blueAccent,
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildStyledTextField(
                  controller: amountController,
                  label: "Amount",
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),
                _buildStyledTextField(
                  controller: methodController,
                  label: "Payment Method",
                ),
                SizedBox(height: 16),
                _buildStyledTextField(
                  controller: statusController,
                  label: "Status",
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.redAccent, // Text color
              ),
              child: Text(
                "Cancel",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () {
                // Update the payment data
                setState(() {
                  payment['amount'] = double.tryParse(amountController.text) ??
                      payment['amount'];
                  payment['payment_method'] = methodController.text;
                  payment['status'] = statusController.text;
                });
                Navigator.pop(context); // Close the dialog
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.blueAccent, // Text color
              ),
              child: Text(
                "Update",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

// Helper function for styled TextFields
  Widget _buildStyledTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle:
            TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blueAccent, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blueAccent, width: 2),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Payment Details",
          style: TextStyle(
            color: Colors.white, // Title color set to white
            fontWeight: FontWeight.bold, // Make the font bold
            fontSize: 20, // Adjust font size
          ),
        ),
        centerTitle: true, // Keep the title centered
        backgroundColor: Colors
            .transparent, // Make AppBar background transparent to show gradient
        iconTheme: IconThemeData(
          color: Colors.blueAccent, // Back icon color set to blue accent
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Payment ID
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(Icons.payment, color: Colors.blueAccent),
                title: Text(
                  "Payment ID: ${payment['id']}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ),
            SizedBox(height: 14),

            // Amount
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(Icons.monetization_on, color: Colors.green[700]),
                title: Text(
                  "Amount: \$${payment['amount']}",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.green[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: 14),

            // Payment Method
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(Icons.credit_card, color: Colors.black87),
                title: Text(
                  "Method: ${payment['payment_method']}",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(height: 14),

            // Status
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(
                  payment['status'] == 'Completed'
                      ? Icons.check_circle
                      : Icons.error,
                  color: payment['status'] == 'Completed'
                      ? Colors.green[600]
                      : Colors.red[600],
                ),
                title: Text(
                  "Status: ${payment['status']}",
                  style: TextStyle(
                    fontSize: 18,
                    color: payment['status'] == 'Completed'
                        ? Colors.green[600]
                        : Colors.red[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(height: 14),

            // Invoice
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Icon(Icons.picture_as_pdf, color: Colors.grey[600]),
                title: Text(
                  "Invoice: ${payment['invoice'] ?? 'No invoice'}",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ),
            SizedBox(height: 28),

            // Cancel and Update Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Cancel Button
                ElevatedButton(
                  onPressed: _cancelSimulation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                // Update Button
                ElevatedButton(
                  onPressed: _updateSimulation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: Text(
                    'Update',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}







// ======
// ======
// ======


// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class PaymentDetailsPage extends StatefulWidget {
//   final Map<String, dynamic> payment;

//   PaymentDetailsPage({required this.payment});

//   @override
//   _PaymentDetailsPageState createState() => _PaymentDetailsPageState();
// }

// class _PaymentDetailsPageState extends State<PaymentDetailsPage> {
//   late Map<String, dynamic> payment;

//   @override
//   void initState() {
//     super.initState();
//     payment = widget.payment; // Initialize payment with the provided data
//   }

//   // Function to handle cancel simulation
//   void _cancelSimulation() {
//     // If you want to navigate back or remove the payment, you can pop the page
//     Navigator.pop(context);
//   }

//   // Function to handle update simulation
//   Future<void> _updateSimulation() async {
//     showDialog(
//       context: context,
//       builder: (context) {
//         TextEditingController amountController =
//             TextEditingController(text: payment['amount'].toString());
//         TextEditingController methodController =
//             TextEditingController(text: payment['payment_method']);
//         TextEditingController statusController =
//             TextEditingController(text: payment['status']);

//         return AlertDialog(
//           title: Text("Update Payment Details"),
//           content: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: amountController,
//                 decoration: InputDecoration(labelText: "Amount"),
//                 keyboardType: TextInputType.number,
//               ),
//               TextField(
//                 controller: methodController,
//                 decoration: InputDecoration(labelText: "Payment Method"),
//               ),
//               TextField(
//                 controller: statusController,
//                 decoration: InputDecoration(labelText: "Status"),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 // Close dialog without making changes
//                 Navigator.pop(context);
//               },
//               child: Text("Cancel"),
//             ),
//             TextButton(
//               onPressed: () async {
//                 // Prepare updated payment data
//                 var updatedPayment = {
//                   "payment_method": methodController.text,
//                   "amount": double.tryParse(amountController.text) ??
//                       payment['amount'],
//                   "status": statusController.text,
//                   "invoice": payment['invoice'] ?? 'No invoice',
//                 };

//                 // Call backend API to update payment (currently commented)
//                 try {
//                   final response = await http.put(
//                     Uri.parse(
//                         'https://your-backend-url.com/payments/${payment['id']}'),
//                     headers: {'Content-Type': 'application/json'},
//                     body: json.encode(updatedPayment),
//                   );

//                   if (response.statusCode == 200) {
//                     // Update the local state if successful
//                     setState(() {
//                       payment = json.decode(response.body)['payment'];
//                     });
//                     Navigator.pop(context); // Close the dialog
//                   } else {
//                     // Handle error response
//                     showDialog(
//                       context: context,
//                       builder: (context) {
//                         return AlertDialog(
//                           title: Text("Error"),
//                           content: Text('Failed to update payment'),
//                           actions: [
//                             TextButton(
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               child: Text("Close"),
//                             ),
//                           ],
//                         );
//                       },
//                     );
//                   }
//                 } catch (error) {
//                   // Handle network error
//                   showDialog(
//                     context: context,
//                     builder: (context) {
//                       return AlertDialog(
//                         title: Text("Error"),
//                         content: Text('An error occurred: $error'),
//                         actions: [
//                           TextButton(
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                             child: Text("Close"),
//                           ),
//                         ],
//                       );
//                     },
//                   );
//                 }
//               },
//               child: Text("Update"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // Function to handle delete action
//   Future<void> _deletePayment() async {
//     // Call backend API to delete payment (currently commented)
//     try {
//       final response = await http.delete(
//         Uri.parse('https://your-backend-url.com/payments/${payment['id']}'),
//       );

//       if (response.statusCode == 200) {
//         // On success, show a confirmation and pop the page
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Payment deleted successfully')),
//         );
//         Navigator.pop(context); // Go back to the previous screen
//       } else {
//         // Handle error response
//         showDialog(
//           context: context,
//           builder: (context) {
//             return AlertDialog(
//               title: Text("Error"),
//               content: Text('Failed to delete payment'),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   child: Text("Close"),
//                 ),
//               ],
//             );
//           },
//         );
//       }
//     } catch (error) {
//       // Handle network error
//       showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Text("Error"),
//             content: Text('An error occurred: $error'),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 child: Text("Close"),
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Payment Details",
//           style: TextStyle(
//             color: Colors.white, // Title color set to white
//             fontWeight: FontWeight.bold, // Make the font bold
//             fontSize: 20, // Adjust font size
//           ),
//         ),
//         centerTitle: true, // Keep the title centered
//         backgroundColor:
//             Colors.transparent, // Make AppBar background transparent
//         iconTheme: IconThemeData(
//           color: Colors.blueAccent, // Back icon color set to blue accent
//         ),
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 Color(0xFF0F2027), // Dark color for the gradient
//                 Color(0xFF203A43), // Medium dark
//                 Color(0xFF2C5364), // Lighter blue-green
//               ],
//               begin: Alignment.topLeft, // Gradient begins from the top left
//               end: Alignment.bottomRight, // Ends at the bottom right
//             ),
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Payment ID
//             Text(
//               "Payment ID: ${payment['id']}",
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.blueAccent, // Accent color for the ID
//               ),
//             ),
//             SizedBox(height: 12),

//             // Amount
//             Text(
//               "Amount: \$${payment['amount']}",
//               style: TextStyle(
//                 fontSize: 18,
//                 color: Colors.greenAccent, // Green accent for amount
//                 fontWeight: FontWeight.w600, // Slightly bolder
//               ),
//             ),
//             SizedBox(height: 12),

//             // Payment Method
//             Text(
//               "Method: ${payment['payment_method']}",
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.black87, // Standard dark text color
//               ),
//             ),
//             SizedBox(height: 12),

//             // Status
//             Text(
//               "Status: ${payment['status']}",
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey[700], // Gray for status
//               ),
//             ),
//             SizedBox(height: 12),

//             // Invoice
//             Text(
//               "Invoice: ${payment['invoice'] ?? 'No invoice'}",
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey[600], // Subtle gray for invoice
//               ),
//             ),
//             SizedBox(height: 24),

//             // Cancel and Update Buttons
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 // Cancel Button
//                 ElevatedButton(
//                   onPressed: _cancelSimulation,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.redAccent, // Red for Cancel
//                     padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: Text(
//                     'Cancel Simulation',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//                 // Update Button
//                 ElevatedButton(
//                   onPressed: _updateSimulation,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blueAccent, // Blue for Update
//                     padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: Text(
//                     'Update Simulation',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//                 // Delete Button
//                 ElevatedButton(
//                   onPressed: _deletePayment,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.red, // Red for Delete
//                     padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: Text(
//                     'Delete Payment',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }