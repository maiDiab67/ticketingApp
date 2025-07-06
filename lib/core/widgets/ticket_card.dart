import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../models/ticket_model.dart';
import '../../screens/ticket_details.dart';
import '../helpers/spacing.dart';

class TicketCard extends StatelessWidget {
  final Ticket ticket;

  const TicketCard({Key? key, required this.ticket}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(ticket.stageName);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () => Get.to(() => TicketDetailScreen(ticket: ticket)),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            if (!isDark)
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
                horizontalSpace(4),
                Expanded(
                  child: Text(
                    ticket.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                ),
                horizontalSpace(4),
                Icon(
                  Icons.access_time_outlined,
                  size: 14,
                  color: Theme.of(context).hintColor,
                ),
                horizontalSpace(2),
                Text(
                  DateFormat.yMMMMEEEEd(
                    Get.locale?.languageCode ?? 'en',
                  ).format(DateTime.parse(ticket.dateCreated)),
                  style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                horizontalSpace(8),
                _statusBadge(ticket.stageName, statusColor),
              ],
            ),

            verticalSpace(6),

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

            verticalSpace(8),

            // Partner & Category
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 16,
                      color: Theme.of(context).hintColor,
                    ),
                    horizontalSpace(4),
                    Text(
                      ticket.authorName ?? 'N/A',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.category_outlined,
                      size: 16,
                      color: Theme.of(context).hintColor,
                    ),
                    horizontalSpace(4),
                    Text(
                      ticket.typeName ?? 'N/A',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),

            verticalSpace(4),

            // Date & Time
            Row(
              children: [
                Icon(
                  Icons.event_note_outlined,
                  size: 16,
                  color: Theme.of(context).hintColor,
                ),
                horizontalSpace(6),
                Text(
                  ticket.dateCreated.replaceAll('T', ' ').substring(0, 16),
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).hintColor,
                  ),
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
