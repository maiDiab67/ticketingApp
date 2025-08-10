import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ItemsPage extends StatefulWidget {
  @override
  _ItemsPageState createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  final List<Map<String, dynamic>> items = [
    {"name": "Power Adapter", "stock": 20, "qty": 0},
    {"name": "HDMI Cable", "stock": 45, "qty": 0},
    {"name": "Ethernet Cable", "stock": 32, "qty": 0},
    {"name": "Wireless Mouse", "stock": 12, "qty": 0},
    {"name": "Keyboard", "stock": 10, "qty": 0},
    {"name": "Monitor Stand", "stock": 8, "qty": 0},
    {"name": "USB Hub", "stock": 22, "qty": 0},
    {"name": "Laptop Cooler", "stock": 9, "qty": 0},
    {"name": "Webcam", "stock": 17, "qty": 0},
    {"name": "Headphones", "stock": 25, "qty": 0},
  ];

  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: const Text('items'),
        backgroundColor: isDark ? Colors.black87 : Colors.white,
        foregroundColor: textColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: isDark ? Colors.white54 : Colors.black54,
                ),
                hintText: 'Search products',
                hintStyle: TextStyle(
                  color: isDark ? Colors.white54 : Colors.black54,
                ),
                filled: true,
                fillColor: isDark ? Colors.black54 : Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),

          // Header row
          Container(
            color: isDark ? Colors.grey[900] : Colors.grey[300],
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: Text(
                    'product',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
                // Expanded(
                //   flex: 2,
                //   child: Text(
                //     'uom',
                //     style: TextStyle(
                //       fontWeight: FontWeight.bold,
                //       color: textColor,
                //     ),
                //   ),
                // ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'quantity',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Items list
          Expanded(
            child: ListView(
              children:
                  items
                      .where(
                        (item) =>
                            item['name'].toLowerCase().contains(searchQuery),
                      )
                      .map(
                        (item) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: isDark ? Colors.white12 : Colors.black12,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              // Product name
                              Expanded(
                                flex: 6,
                                child: Text(
                                  "${item['name']} (${item['stock']} Units)",
                                  style: TextStyle(color: textColor),
                                ),
                              ),
                              // // UOM
                              // const Expanded(flex: 2, child: Text("Units")),
                              // Quantity controls
                              Expanded(
                                flex: 3,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Minus button
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (item['qty'] > 0) item['qty']--;
                                        });
                                      },
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color:
                                              isDark
                                                  ? Colors.grey[800]
                                                  : Colors.grey[300],
                                          shape: BoxShape.circle,
                                        ),
                                        padding: const EdgeInsets.all(6),
                                        child: Icon(
                                          Icons.remove,
                                          color: textColor,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    // Quantity text
                                    Text(
                                      item['qty'].toString(),
                                      style: TextStyle(color: textColor),
                                    ),
                                    SizedBox(width: 8.w),
                                    // Plus button
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          item['qty']++;
                                        });
                                      },
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color:
                                              isDark
                                                  ? Colors.grey[800]
                                                  : Colors.grey[300],
                                          shape: BoxShape.circle,
                                        ),
                                        padding: const EdgeInsets.all(6),
                                        child: Icon(
                                          Icons.add,
                                          color: textColor,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),

          // Footer
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "customer: John Doe\nticket: TICKET-4",
              style: TextStyle(color: isDark ? Colors.white54 : Colors.black54),
            ),
          ),

          // Create Warehouse Transfer Button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? Colors.teal : Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  // TODO: Add your warehouse transfer logic here
                  Get.snackbar("Success", "Timer stopped and time logged.");
                },
                child: Text(
                  "Create Warehouse Transfer",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
