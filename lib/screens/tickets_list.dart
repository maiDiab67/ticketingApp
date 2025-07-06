import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ticketing/controllers/ticket_controller.dart';

import '../core/helpers/spacing.dart';
import '../core/widgets/ticket_card.dart';
import '../models/ticket_model.dart';

class TicketsListScreen extends StatelessWidget {
  final TicketController controller = Get.put(TicketController());

  TicketsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: false,
        title: Text(
          'tickets'.tr,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
      ),

      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final grouped = _groupTicketsByPriority(controller.tickets);

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: grouped.length,
          itemBuilder: (_, sectionIndex) {
            final sectionKey = grouped.keys.elementAt(sectionIndex);
            final sectionItems = grouped[sectionKey]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${sectionKey.tr} (${sectionItems.length})',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                verticalSpace(10),
                ...sectionItems.map(
                  (t) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TicketCard(ticket: t),
                  ),
                ),
                verticalSpace(20),
              ],
            );
          },
        );
      }),
    );
  }

  Map<String, List<Ticket>> _groupTicketsByPriority(List<Ticket> tickets) {
    final map = <String, List<Ticket>>{
      'high_priority': [],
      'medium_priority': [],
      'low_priority': [],
    };

    for (final t in tickets) {
      switch (t.priority) {
        case 0:
        case 'low':
          map['low_priority']!.add(t);
          break;
        case 1:
        case 'medium':
          map['medium_priority']!.add(t);
          break;
        default:
          map['high_priority']!.add(t);
          break;
      }
    }
    return map;
  }
}
