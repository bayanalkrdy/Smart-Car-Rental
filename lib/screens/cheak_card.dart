import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'book_screen.dart';

class CheckCardPage extends StatefulWidget {
  const CheckCardPage({Key? key}) : super(key: key);

  @override
  State<CheckCardPage> createState() => _CheckCardPageState();
}

class _CheckCardPageState extends State<CheckCardPage> {
  File? _selectedImage;
  final picker = ImagePicker();

  String _statusMessage = '';
  Map<String, String> _fields = {};
  bool _loading = false;
  bool _showBookButton = false;

  Future<void> _pickImage() async {
    // Reset the _showBookButton to false before selecting a new image
    setState(() {
      _showBookButton = false;
    });
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _statusMessage = '';
        _fields = {};
      });
    }
  }

  Future<void> _submitImage() async {
    if (_selectedImage == null) return;

    setState(() {
      _loading = true;
      _statusMessage = 'Processing...';
    });

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://127.0.0.1:8000/car_rental/analyze-id/'),
    );
    request.files
        .add(await http.MultipartFile.fromPath('image', _selectedImage!.path));

    try {
      var response = await request.send();
      var responseData = await http.Response.fromStream(response);

      final data = json.decode(responseData.body);

      setState(() {
        _statusMessage =
            "${data['status'].toString().toUpperCase()}: ${data['message']}";
        _fields = {
          'License Number': data['fields']?['license_number'] ?? '',
          'Full Name': data['fields']?['name'] ?? '',
          'Date of Birth': data['fields']?['dob'] ?? '',
          'Issue Date': data['fields']?['issue_date'] ?? '',
          'Expiry Date': data['fields']?['expiry_date'] ?? '',
        };

        _showBookButton =
            response.statusCode == 200; // ✅ Show button only if 200
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.blueAccent),
            onPressed: () => Navigator.pop(context),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
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
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.document_scanner, color: Colors.white),
              SizedBox(width: 8),
              Text('Analyze ID', style: TextStyle(color: Colors.white)),
            ],
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF34515E),
                  foregroundColor: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text('Select ID Image'),
              ),
              const SizedBox(height: 16),
              if (_selectedImage != null)
                Column(
                  children: const [
                    Icon(Icons.check_circle,
                        color: Colors.greenAccent, size: 64),
                    SizedBox(height: 8),
                    Text(
                      'Image selected successfully!',
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3C50),
                  foregroundColor: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: _loading ? null : _submitImage,
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Submit'),
              ),
              const SizedBox(height: 24),
              Text(
                _statusMessage,
                style: TextStyle(
                  color: _statusMessage.contains('ACCEPTED')
                      ? Colors.greenAccent
                      : Colors.redAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              if (_fields.isNotEmpty)
                ..._fields.entries.map((entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(entry.key,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          TextFormField(
                            readOnly: true,
                            initialValue: entry.value,
                            style: const TextStyle(color: Colors.black87),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFE3F2FD),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    const BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              if (_showBookButton)
                ElevatedButton.icon(
                  icon: const Icon(Icons.book_online),
                  label: const Text("Proceed to Book"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BookScreen()),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
