import 'package:flutter/material.dart';
import 'package:jelajah_rasa_mobile/add_dish/models/newdish_entry.dart';
import 'package:jelajah_rasa_mobile/add_dish/screens/edit_dish.dart'; // Import class EditDish
import 'package:http/http.dart' as http;
import 'dart:convert';

class RequestStatusScreen extends StatefulWidget {
  @override
  _RequestStatusScreenState createState() => _RequestStatusScreenState();
}

class _RequestStatusScreenState extends State<RequestStatusScreen> {
  TextEditingController _searchController = TextEditingController();

  // Sample data for requested dishes
  List<NewDishEntry> requests = [];

  @override
  void initState() {
    super.initState();
    fetchUserRequests();
  }


  Future<void> fetchUserRequests() async {
    final String apiUrl = 'http://127.0.0.1:8000/module4/flutter-get-user-dishes/';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer your-access-token', // Ganti dengan token yang valid
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<NewDishEntry> userRequests = data.map((item) => NewDishEntry.fromJson(item)).toList();

        setState(() {
          requests = userRequests;
        });
      } else {
        throw Exception('Failed to load user requests');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Request Status',
          style: TextStyle(color: Color(0xFFF4B5A4)),
        ),
        backgroundColor: Colors.white70,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5, spreadRadius: 2)
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search Request',
                  border: InputBorder.none,
                  suffixIcon: Icon(Icons.search),
                ),
              ),
            ),
            // Request table
            Expanded(
              child: ListView.builder(
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  final request = requests[index];

                  String statusText;
                  Color statusColor;

                  if (request.status == 'Accepted' && request.isApproved && !request.isRejected) {
                    statusText = 'Accepted';
                    statusColor = Colors.green;
                  } else if (request.status == 'Pending' && !request.isApproved && !request.isRejected) {
                    statusText = 'Pending';
                    statusColor = Colors.yellow;
                  } else if (request.status == 'Rejected' && !request.isApproved && request.isRejected) {
                    statusText = 'Rejected';
                    statusColor = Colors.red;
                  } else {
                    statusText = 'Unknown';
                    statusColor = Colors.grey;
                  }

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12.0),
                      leading: Image.network(request.image),
                      title: Text(request.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Flavor: ${request.flavor}'),
                          Text('Category: ${request.category}'),
                          Text('Vendor: ${request.vendorName}'),
                          Text('Price: \$${request.price.toStringAsFixed(2)}'),
                          Text('Map Link: ${request.mapLink}'),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            statusText,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                          if (request.status == 'Rejected' && !request.isApproved && request.isRejected)
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => EditDish(dish: request)),
                                ).then((updatedDish) {
                                  if (updatedDish != null) {
                                    setState(() {
                                      int index = requests.indexWhere((element) => element.uuid == updatedDish.uuid);
                                      if (index != -1) {
                                        requests[index] = updatedDish;
                                      }
                                    });
                                  }
                                });
                              },
                              child: const Text(
                                'Edit',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}
