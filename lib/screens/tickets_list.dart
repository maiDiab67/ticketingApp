import 'package:flutter/material.dart';
import '/widgets/custom_app_bar.dart';
import 'ticket_details.dart';
import 'package:get/get.dart';
import '/controllers/ticket_controller.dart';
import '/models/ticket_model.dart';

class TicketsListScreen extends StatelessWidget {
  final TicketController controller = Get.put(TicketController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tickets')),
      backgroundColor: Color(0xFFF5F6F8),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        final grouped = _groupTicketsByPriority(controller.tickets);

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children:
                grouped.entries.map((entry) {
                  final priority = entry.key;
                  final tickets = entry.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$priority (${tickets.length})',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: 10),
                      Column(
                        children:
                            tickets.map((ticket) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: TicketCard(
                                  ticket: {
                                    'id': ticket.id,
                                    'name': ticket.name,
                                    'status': ticket.stageName,
                                    'color': _getStatusColor(ticket.stageName),
                                    'date': ticket.dateCreated ?? '',
                                    'number': ticket.name,
                                    'requestTime': "48",
                                    'requestStarted': "8789",
                                    'serviceId': ticket.serviceId,
                                    // 'category': ticket.categoryName,
                                    'priority': ticket.priority,
                                    'type': ticket.type,
                                    'full':
                                        ticket, // pass full object if needed in detail screen
                                  },
                                ),
                              );
                            }).toList(),
                      ),
                      SizedBox(height: 20),
                    ],
                  );
                }).toList(),
          ),
        );
      }),
    );
  }

  /// Group tickets by priority (High, Medium, Low)
  Map<String, List<Ticket>> _groupTicketsByPriority(List<Ticket> tickets) {
    Map<String, List<Ticket>> grouped = {
      'High Priority': [],
      'Medium Priority': [],
      'Low Priority': [],
    };

    for (var ticket in tickets) {
      switch (ticket.priority) {
        case 0:
        case 'low':
          grouped['Low Priority']!.add(ticket);
          break;
        case 1:
        case 'medium':
          grouped['Medium Priority']!.add(ticket);
          break;
        case 2:
        case 'high':
        default:
          grouped['High Priority']!.add(ticket);
          break;
      }
    }

    return grouped;
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'waiting':
        return Colors.amber;
      case 'resolved':
        return Colors.green;
      case 'draft':
        return Colors.grey;
      case 'in progress':
        return Colors.deepPurple;
      default:
        return Colors.blueGrey;
    }
  }
}

// class TicketsListScreen extends StatelessWidget {
//   final Map<String, List<Map<String, dynamic>>> ticketsByPriority = {
//     'High Priority': [
//       {
//         'name': 'Water Pipe Repair #1234',
//         'status': 'Waiting',
//         'color': Colors.amber,
//         'date': '04/20/2025',
//         'number': 5,
//         'requestTime': '20/05/2024',
//         'requestStarted': '20/05/2024 12:11:00',
//         'category': 'None',
//       },
//       {
//         'name': 'Security System Upgrade',
//         'status': 'Resolved',
//         'color': Colors.green,
//         'date': '04/20/2025',
//         'number': 3,
//         'requestTime': '20/05/2024',
//         'requestStarted': '20/05/2024 12:11:00',
//         'category': 'None',
//       },
//     ],
//     'Medium Priority': [
//       {
//         'name': 'HVAC Maintenance #2345',
//         'status': 'Draft',
//         'color': Colors.black12,
//         'date': '04/20/2025',
//         'number': 2,
//         'requestTime': '20/05/2024',
//         'requestStarted': '20/05/2024 12:11:00',
//         'category': 'None',
//       },
//       {
//         'name': 'Electrical Panel Update #...',
//         'status': 'Draft',
//         'color': Colors.black12,
//         'date': '04/20/2025',
//         'number': 8,
//         'requestTime': '20/05/2024',
//         'requestStarted': '20/05/2024 12:11:00',
//         'category': 'None',
//       },
//     ],
//     'Low Priority': [
//       {
//         'name': 'Solar Panel Installation...',
//         'status': 'In Progress',
//         'color': Colors.purple,
//         'date': '04/20/2025',
//         'number': 6,
//         'requestTime': '20/05/2024',
//         'requestStarted': '20/05/2024 12:11:00',
//         'category': 'None',
//       },
//     ],
//   };

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children:
//               ticketsByPriority.entries.map((entry) {
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       '${entry.key} (${entry.value.length})',
//                       style: Theme.of(context).textTheme.titleMedium,
//                     ),
//                     const SizedBox(height: 8),
//                     // Wrap(
//                     //   spacing: 12,
//                     //   runSpacing: 12,
//                     //   children: entry.value.map((ticket) {
//                     //     return TicketCard(ticket: ticket);
//                     //   }).toList(),
//                     // ),
//                     Column(
//                       children:
//                           entry.value.map((ticket) {
//                             return Padding(
//                               padding: const EdgeInsets.only(bottom: 12),
//                               child: TicketCard(ticket: ticket),
//                             );
//                           }).toList(),
//                     ),

//                     const SizedBox(height: 20),
//                   ],
//                 );
//               }).toList(),
//         ),
//       ),
//     );
//   }
// }

class TicketCard extends StatelessWidget {
  final Map<String, dynamic> ticket;

  const TicketCard({super.key, required this.ticket});

  Widget _buildStatusBadge(String status, Color color) {
    IconData icon;
    switch (status.toLowerCase()) {
      case 'waiting':
        icon = Icons.hourglass_top;
        break;
      case 'resolved':
        icon = Icons.check_circle;
        break;
      case 'draft':
        icon = Icons.radio_button_unchecked;
        break;
      default:
        icon = Icons.info_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            status,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => TicketDetailScreen(ticket: ticket));
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ticket Title
            Text(
              ticket['name'],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Color(0xFF263238),
              ),
            ),
            const SizedBox(height: 12),

            // Status badge
            _buildStatusBadge(ticket['status'], ticket['color']),
            const SizedBox(height: 12),

            // Date row
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 14,
                  color: Colors.grey,
                ),
                const SizedBox(width: 6),
                Text(
                  ticket['date'],
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
