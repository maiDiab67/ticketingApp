import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';

class DynamicDropdownField extends StatefulWidget {
  final String label;
  final String url;
  final Function(int?) onChanged;
  final int? initialValue;

  const DynamicDropdownField({
    super.key,
    required this.label,
    required this.url,
    required this.onChanged,
    this.initialValue,
  });

  @override
  State<DynamicDropdownField> createState() => _DynamicDropdownFieldState();
}

class _DynamicDropdownFieldState extends State<DynamicDropdownField> {
  late Future<List<Map<String, dynamic>>> _futureItems;
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    _futureItems = fetchDropdownItems(widget.url);
  }

  Future<List<Map<String, dynamic>>> fetchDropdownItems(String url) async {
    print(url);
    final token = box.read('token');
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/Text',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success']) {
        print(data['data']);
        return List<Map<String, dynamic>>.from(data['data']);
      }
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _futureItems,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LinearProgressIndicator();
              } else if (snapshot.hasError) {
                return const Text("Failed to load data");
              } else {
                final items = snapshot.data ?? [];
                return DropdownButtonFormField<int>(
                  value: widget.initialValue,
                  hint: const Text('Select'),
                  isExpanded: true,
                  items:
                      items.map((item) {
                        return DropdownMenuItem<int>(
                          value: item['id'],
                          child: Text(item['name']),
                        );
                      }).toList(),
                  onChanged: widget.onChanged,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
