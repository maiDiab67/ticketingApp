import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; // ⬅️ هذه مهمة

import '../../models/ticket_model.dart';
import '../../screens/ticket_details.dart';

class TicketCard extends StatelessWidget {
  final Ticket ticket;

  const TicketCard({Key? key, required this.ticket}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(ticket.stageName);

    return InkWell(
      onTap: () => Get.to(() => TicketDetailScreen(ticket: ticket)),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: ID + Date + Status
            Row(
              children: [
                const Icon(
                  Icons.confirmation_number_outlined,
                  size: 18,
                  color: Colors.teal,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    ticket.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.access_time_outlined,
                  size: 14,
                  color: Colors.grey,
                ),
                const SizedBox(width: 2),
                Text(
                  DateFormat.yMMMMEEEEd(
                    Get.locale?.languageCode ?? 'en',
                  ).format(DateTime.parse(ticket.dateCreated)),
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
                const SizedBox(width: 8),
                _statusBadge(ticket.stageName, statusColor),
              ],
            ),

            const SizedBox(height: 6),

            // Rating Stars
            Row(
              children: List.generate(5, (i) {
                return Icon(
                  i < (3 ?? 4) ? Icons.star : Icons.star_border,
                  size: 18,
                  color: Colors.amber,
                );
              }),
            ),

            const SizedBox(height: 8),

            // Partner & Category
            Row(
              children: [
                const Icon(Icons.person_outline, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    ticket.authorName ?? 'N/A',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),

            Row(
              children: [
                const Icon(
                  Icons.category_outlined,
                  size: 16,
                  color: Colors.grey,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    ticket.typeName ?? 'N/A',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),

            // Date & Time
            Row(
              children: [
                const Icon(
                  Icons.event_note_outlined,
                  size: 16,
                  color: Colors.grey,
                ),
                const SizedBox(width: 6),
                Text(
                  ticket.dateCreated.replaceAll('T', ' ').substring(0, 16),
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(String? status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(_statusIcon(status), size: 12, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            status?.tr ?? 'N/A',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  IconData _statusIcon(String? status) {
    switch (status?.toLowerCase()) {
      case 'waiting':
        return Icons.hourglass_top;
      case 'resolved':
        return Icons.check_circle;
      case 'draft':
        return Icons.radio_button_unchecked;
      default:
        return Icons.info_outline;
    }
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'waiting':
        return Colors.orange;
      case 'resolved':
        return Colors.green;
      case 'draft':
        return Colors.grey;
      default:
        return Colors.blueGrey;
    }
  }
}
