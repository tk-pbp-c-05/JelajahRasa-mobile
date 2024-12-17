import 'package:flutter/material.dart';
import 'package:jelajah_rasa_mobile/add_dish/models/newdish_entry.dart';
import 'package:jelajah_rasa_mobile/add_dish/screens/edit_dish.dart'; // Import class EditDish
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class RequestStatusScreen extends StatefulWidget {
  const RequestStatusScreen({super.key});

  @override
  _RequestStatusScreenState createState() => _RequestStatusScreenState();
}

class _RequestStatusScreenState extends State<RequestStatusScreen> {
  List<NewDishEntry> requests = [];

  @override
  void initState() {
    super.initState();
    fetchUserRequests();
  }

  Future<void> fetchUserRequests() async {
    final request = context.read<CookieRequest>();
    const String apiUrl =
        'http://127.0.0.1:8000/module4/flutter-get-user-dishes/';

    try {
      final response = await request.get(apiUrl);

      if (response is List) {
        List<NewDishEntry> userRequests =
            response.map((item) => NewDishEntry.fromJson(item)).toList();

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

  Future<void> deleteDish(String uuid) async {
    final request = context.read<CookieRequest>();
    final String apiUrl =
        'http://127.0.0.1:8000/module4/flutter-delete-rejected-dish/$uuid/';

    try {
      // Menggunakan form-data untuk mengirim parameter _method
      final response = await request.post(
        apiUrl,
        {'_method': 'DELETE'}, // Kirim sebagai form-data, bukan JSON
      );

      bool? isSuccess = response['success'];

      if (isSuccess == true) {
        setState(() {
          requests.removeWhere((dish) => dish.uuid == uuid);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dish deleted successfully!')),
        );
      } else {
        throw Exception(response['error'] ?? 'Failed to delete dish');
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
      body: ListView.builder(
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final request = requests[index];

          String statusText;
          Color statusColor;
          Widget actionWidget;

          if (request.status == 'Approved' &&
              request.isApproved &&
              !request.isRejected) {
            statusText = 'Accepted';
            statusColor = Colors.green;
            actionWidget = const Text(
              'Your request is accepted.',
              style:
                  TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            );
          } else if (request.status == 'Pending' &&
              !request.isApproved &&
              !request.isRejected) {
            statusText = 'Pending';
            statusColor = Colors.yellow;
            actionWidget = const Text(
              'Please wait, we are checking your request.',
              style:
                  TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            );
          } else if (request.status == 'Rejected' &&
              !request.isApproved &&
              request.isRejected) {
            statusText = 'Rejected';
            statusColor = Colors.red;
            actionWidget = Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Your request is rejected, please change the data requested.',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditDish(dish: request)),
                        ).then((updatedDish) {
                          if (updatedDish != null) {
                            setState(() {
                              int index = requests.indexWhere((element) =>
                                  element.uuid == updatedDish.uuid);
                              if (index != -1) {
                                requests[index] = updatedDish;
                              }
                            });
                          }
                        });
                      },
                      child: const Text('Edit',
                          style: TextStyle(color: Colors.blue)),
                    ),
                    TextButton(
                      onPressed: () => deleteDish(request.uuid),
                      child: const Text('Delete',
                          style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              ],
            );
          } else {
            statusText = 'Unknown';
            statusColor = Colors.grey;
            actionWidget = const SizedBox.shrink();
          }

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(5),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(3),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  const TableRow(
                    decoration: BoxDecoration(color: Color(0xFFF1F1F1)),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Data',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Status',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                            textAlign: TextAlign.center),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Action',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                            textAlign: TextAlign.center),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Image.network(
                              request.image,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.network(
                                  'https://i.imgur.com/qCP9R4y.jpeg', // Gambar default
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    request.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Text('Flavor: ${request.flavor}'),
                                  Text('Category: ${request.category}'),
                                  Text('Vendor: ${request.vendorName}'),
                                  Text(
                                      'Price: \$${request.price.toStringAsFixed(2)}'),
                                  Text('Map Link: ${request.mapLink}'),
                                  Text('Address: ${request.address}'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          statusText,
                          style: TextStyle(
                              color: statusColor, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: actionWidget,
                      ),
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
