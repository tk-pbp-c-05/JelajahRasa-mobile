import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import '../model/report.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  String _searchQuery = '';
  String _statusFilter = 'all';

  Future<List<Datum>> fetchReports(CookieRequest request) async {
    final response = await request.get(
        'https://daffa-desra-jelajahrasa.pbp.cs.ui.ac.id/report/api/reports/');
    var reportResponse = ReportResponse.fromJson(response);
    return reportResponse.data;
  }

  Future<void> updateReportStatus(
      CookieRequest request, int reportId, String status) async {
    try {
      final response = await request.post(
        'https://daffa-desra-jelajahrasa.pbp.cs.ui.ac.id/report/api/reports/$reportId/status/',
        jsonEncode({'status': status}),
      );
      if (response['status']) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Report ${status.toLowerCase()} successfully!"),
              backgroundColor: status == 'approved' ? Colors.green : Colors.red,
            ),
          );
          setState(() {});
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to update status: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> deleteReport(CookieRequest request, int reportId) async {
    try {
      final response = await request.post(
        'https://daffa-desra-jelajahrasa.pbp.cs.ui.ac.id/report/api/reports/$reportId/delete/',
        {},
      );
      if (response['status']) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Report deleted successfully!"),
              backgroundColor: Colors.green,
            ),
          );
          setState(() {});
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to delete report: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  List<Datum> _filterReports(List<Datum> reports) {
    return reports.where((report) {
      final matchesSearch = report.fields.food
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          report.fields.issueType
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
      final matchesStatus =
          _statusFilter == 'all' || report.fields.status == _statusFilter;
      return matchesSearch && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Reports'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search Bar
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Search reports...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Status Filter
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Filter by Status',
                  border: OutlineInputBorder(),
                ),
                value: _statusFilter,
                items: const [
                  DropdownMenuItem(value: 'all', child: Text('All')),
                  DropdownMenuItem(value: 'pending', child: Text('Pending')),
                  DropdownMenuItem(value: 'approved', child: Text('Approved')),
                  DropdownMenuItem(value: 'rejected', child: Text('Rejected')),
                ],
                onChanged: (value) {
                  setState(() {
                    _statusFilter = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Reports List
              FutureBuilder(
                future: fetchReports(request),
                builder: (context, AsyncSnapshot<List<Datum>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text("No reports found");
                  }

                  final filteredReports = _filterReports(snapshot.data!);

                  if (filteredReports.isEmpty) {
                    return const Text("No matching reports found");
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredReports.length,
                    itemBuilder: (context, index) {
                      var report = filteredReports[index];
                      return Card(
                        child: ListTile(
                          title: Text(report.fields.food),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Issue: ${report.fields.issueType}'),
                              Text('Description: ${report.fields.description}'),
                              Text('Status: ${report.fields.status}'),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (request.jsonData['is_admin'] == true &&
                                  report.fields.status == 'pending') ...[
                                IconButton(
                                  icon: const Icon(Icons.check,
                                      color: Colors.green),
                                  onPressed: () => updateReportStatus(
                                      request, report.pk, 'approved'),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close,
                                      color: Colors.red),
                                  onPressed: () => updateReportStatus(
                                      request, report.pk, 'rejected'),
                                ),
                              ],
                              if (request.jsonData['is_admin'] == true &&
                                  (report.fields.status == 'approved' ||
                                      report.fields.status == 'rejected')) ...[
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Delete Report'),
                                          content: const Text(
                                              'Are you sure you want to delete this report?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                deleteReport(
                                                    request, report.pk);
                                              },
                                              child: const Text(
                                                'Delete',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ] else ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: report.fields.status == 'approved'
                                        ? Colors.green.withOpacity(0.2)
                                        : report.fields.status == 'rejected'
                                            ? Colors.red.withOpacity(0.2)
                                            : Colors.grey.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    report.fields.status,
                                    style: TextStyle(
                                      color: report.fields.status == 'approved'
                                          ? Colors.green
                                          : report.fields.status == 'rejected'
                                              ? Colors.red
                                              : Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
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
