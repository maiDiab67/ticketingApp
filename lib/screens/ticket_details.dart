import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/widgets/custom_app_bar.dart';
import '../core/widgets/dropdownn_field.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';

import '../models/ticket_model.dart';

class TicketDetailScreen extends StatefulWidget {
  final Ticket ticket;

  const TicketDetailScreen({required this.ticket});

  @override
  _TicketDetailScreenState createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  Timer? _timer;
  Duration _elapsed = Duration.zero;
  bool _isRunning = false;
  String base_url = "http://91.109.114.135:18102";
  int? selectedIssueType;
  int? selectedReason;
  int? selectedDyagnosisSystem;
  int? selectedAction;
  final box = GetStorage();

  void _startTimer() {
    if (_isRunning) return;
    setState(() => _isRunning = true);

    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() => _elapsed += Duration(seconds: 1));
    });
  }

  void _stopTimer({required int? activityId}) async {
    _timer?.cancel();
    setState(() => _isRunning = false);

    // Convert elapsed time to hours in decimal (e.g. 6 mins = 0.1 hours)
    double elapsedHours = _elapsed.inSeconds / 3600.0;

    print("Elapsed hours (decimal): $elapsedHours");

    final url = Uri.parse(
      '$base_url/api/stop_timer?ticket_id=${widget.ticket.id}&activity_id=$activityId&amount=$elapsedHours',
    );
    final token = box.read('token');

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${token}", // if needed
        },
        // body: jsonEncode({
        //   "elapsed_hours": elapsedHours.toStringAsFixed(2), // optional rounding
        // }),
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Timer stopped and time logged.");
      } else {
        Get.snackbar("Error", "Failed to stop timer: ${response.body}");
      }
    } catch (e) {
      Get.snackbar("Exception", "Network error: $e");
    }
  }

  // void _stopTimer() {
  //   _timer?.cancel();
  //   setState(() => _isRunning = false);

  //   // Save passed time
  //   print(
  //     "Elapsed time: ${_elapsed.inHours}:${_elapsed.inMinutes % 60}:${_elapsed.inSeconds % 60}",
  //   );
  //   // You can now save _elapsed to the backend or elsewhere
  // }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(d.inHours)}:${twoDigits(d.inMinutes % 60)}:${twoDigits(d.inSeconds % 60)}";
  }

  Widget _buildDetailRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              "$label:",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value != null && value.toString().isNotEmpty
                  ? value.toString()
                  : '-',
              style: TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildDropdownField(String label) {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 16),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           label,
  //           style: TextStyle(
  //             color: Colors.black87,
  //             fontWeight: FontWeight.w500,
  //           ),
  //         ),
  //         SizedBox(height: 4),
  //         DropdownButtonFormField<String>(
  //           value: null,
  //           hint: Text('Select'),
  //           items: [],
  //           onChanged: (value) {},
  //           decoration: InputDecoration(
  //             contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  //             border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
  //             filled: true,
  //             fillColor: Colors.white,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _submitTicketUpdate() async {
    final url = Uri.parse(
      '$base_url/api/tickets/update_ticket/${widget.ticket.id}',
    );

    final body = {
      "reason_ids": selectedReason != null ? [selectedReason!] : [],
      "action_ids": selectedAction != null ? [selectedAction!] : [],
      "issue_id": selectedIssueType != null ? [selectedIssueType!] : [],
      "system_used_id":
          selectedDyagnosisSystem != null ? [selectedDyagnosisSystem!] : [],
    };
    final token = box.read('token');
    try {
      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${token}", // if required
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Ticket updated successfully');
      } else {
        Get.snackbar(
          'Error',
          'Failed to update ticket: ${response.statusCode}',
        );
      }
    } catch (e) {
      Get.snackbar('Exception', 'Failed to submit: $e');
    }
  }

  void _showStopTimerDialog() {
    int? selectedReason;
    TextEditingController noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('stop_timer'.tr),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Backend Dropdown
              DynamicDropdownField(
                label: 'select_reason'.tr,
                url: '$base_url/api/activities/${widget.ticket.type}',
                onChanged: (value) {
                  selectedReason = value;
                },
              ),
              SizedBox(height: 12),

              // Text Input
              TextField(
                controller: noteController,
                decoration: InputDecoration(
                  labelText: 'notes'.tr,
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('cancel'.tr),
            ),
            ElevatedButton(
              onPressed: () {
                // if (selectedReason != null) {
                _stopTimer(
                  activityId: selectedReason,
                ); // Call your timer stop logic
                Navigator.of(context).pop();

                // Optionally send selectedReason + noteController.text to backend here
                print('Selected Stop Reason: $selectedReason');
                print('Notes: ${noteController.text}');
                // } else {
                //   Get.snackbar('Validation', 'Please select a reason');
                // }
              },
              child: Text('confirm_stop'.tr),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ticket = widget.ticket;

    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${ticket.name}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('ticket_number'.tr, "ticket.number"),
                _buildDetailRow('request_time'.tr, "ticket.requestTime"),
                _buildDetailRow('request_started'.tr, "ticket.requestStarted"),
                _buildDetailRow('category'.tr, "ticket.category"),
                _buildDetailRow('partner'.tr, "ticket.partner"),
                _buildDetailRow('related_dealer'.tr, "ticket.dealer"),
                _buildDetailRow('partner_type'.tr, "ticket.partnerType"),
                _buildDetailRow('area'.tr, "ticket.area"),
              ],
            ),
            SizedBox(height: 16),

            // Timer UI
            Row(
              children: [
                Text('timer'.tr, style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _formatDuration(_elapsed),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _isRunning ? null : _startTimer,
                  child: Text('start'.tr),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isRunning ? _showStopTimerDialog : null,
                  child: Text('stop'.tr),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade300,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Issue Form
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'issue_details'.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  SizedBox(height: 16),
                  // _buildDropdownField('Select the issue type *'),
                  DynamicDropdownField(
                    label: 'select_issue_type'.tr,
                    url: '${base_url}/api/ticket/issues/${ticket.serviceId}',
                    onChanged: (value) {
                      selectedIssueType = value;
                      print('Selected reason id: $value');
                    },
                  ),

                  DynamicDropdownField(
                    label: 'reasons'.tr,
                    url: '${base_url}/api/ticket/reasons/${ticket.serviceId}',
                    onChanged: (value) {
                      selectedReason = value;
                      print('Selected reason id: $value');
                    },
                  ),
                  DynamicDropdownField(
                    label: 'diagnosis_system'.tr,
                    url:
                        '${base_url}/api/ticket/dyagnosis-systems/${ticket.serviceId}',
                    onChanged: (value) {
                      selectedDyagnosisSystem = value;
                      print('Selected reason id: $value');
                    },
                  ),
                  DynamicDropdownField(
                    label: 'actions'.tr,
                    url: '${base_url}/api/ticket/actions/${ticket.serviceId}',
                    onChanged: (value) {
                      selectedAction = value;
                      print('Selected reason id: $value');
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            Center(
              child: TextButton(
                onPressed: () {
                  Get.back();
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.grey.shade200,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text('cancel'.tr),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _submitTicketUpdate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: Text('submit_ticket_update'.tr),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
