import 'package:flutter/material.dart';


class RequestStatusScreen extends StatefulWidget {
  @override
  _RequestStatusScreenState createState() => _RequestStatusScreenState();
}

class _RequestStatusScreenState extends State<RequestStatusScreen> {
  TextEditingController _searchController = TextEditingController();
  
  // Sample data for requested dishes
  List<Request> requests = [
    Request(
      name: 'Pizza',
      flavor: 'Salty',
      category: 'Food',
      vendorName: 'Pizza Hut',
      price: 12.99,
      mapLink: 'https://www.google.com/maps',
      imageUrl: 'https://via.placeholder.com/100', // Image URL for the dish
      status: 'Accepted', // "Accepted" status
    ),
    Request(
      name: 'Burger',
      flavor: 'Savory',
      category: 'Food',
      vendorName: 'McDonalds',
      price: 8.50,
      mapLink: 'https://www.google.com/maps',
      imageUrl: 'https://via.placeholder.com/100', // Image URL for the dish
      status: 'Accepted', // "Accepted" status
    ),
    // Add more Request objects here
  ];

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
                decoration: InputDecoration(
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
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(12.0),
                      leading: Image.network(requests[index].imageUrl),
                      title: Text(requests[index].name, style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Flavor: ${requests[index].flavor}'),
                          Text('Category: ${requests[index].category}'),
                          Text('Vendor: ${requests[index].vendorName}'),
                          Text('Price: \$${requests[index].price.toStringAsFixed(2)}'),
                          Text('Map Link: ${requests[index].mapLink}'),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Display "Accepted" status as a Text widget
                          Text(
                            requests[index].status,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
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

class Request {
  final String name;
  final String flavor;
  final String category;
  final String vendorName;
  final double price;
  final String mapLink;
  final String imageUrl;
  final String status;

  Request({
    required this.name,
    required this.flavor,
    required this.category,
    required this.vendorName,
    required this.price,
    required this.mapLink,
    required this.imageUrl,
    required this.status,
  });
}