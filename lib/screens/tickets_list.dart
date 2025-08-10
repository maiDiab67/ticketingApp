import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ticketing/controllers/locale_controller.dart';
import 'package:ticketing/controllers/theme_controller.dart';
import 'package:ticketing/controllers/ticket_controller.dart';

import '../core/helpers/spacing.dart';
import '../core/widgets/ticket_card.dart';
import '../models/ticket_model.dart';

class TicketsListScreen extends StatelessWidget {
  final TicketController controller = Get.put(TicketController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final themeController = Get.find<ThemeController>();
  final localeController = Get.find<LocaleController>();
  final box = GetStorage();

  TicketsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final textColor =
        theme.appBarTheme.foregroundColor ??
        (isDark ? Colors.white : Colors.black);

    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      key: _scaffoldKey,

      // Attach drawer to correct side based on language
      drawer: !isRtl ? _buildDrawer(context, textColor) : null,
      endDrawer: isRtl ? _buildDrawer(context, textColor) : null,

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
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // Instant open without delay
              if (isRtl) {
                _scaffoldKey.currentState?.openEndDrawer();
              } else {
                _scaffoldKey.currentState?.openDrawer();
              }
            },
          ),
        ],
      ),

      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.tickets.isEmpty) {
          // Case 1: Network error
          if (controller.lastError.value == 'network') {
            return RefreshIndicator(
              onRefresh: controller.refreshTickets,
              child: ListView(
                children: const [
                  SizedBox(height: 100),
                  Center(
                    child: Text(
                      'Unable to load tickets.\nCheck your internet connection.',
                    ),
                  ),
                ],
              ),
            );
          }

          // Case 2: No data but no error
          return RefreshIndicator(
            onRefresh: controller.refreshTickets,
            child: ListView(
              children: const [
                SizedBox(height: 100),
                Center(child: Text('No tickets available')),
              ],
            ),
          );
        }

        // Case 3: Data exists
        final grouped = _groupTicketsByPriority(controller.tickets);
        return RefreshIndicator(
          onRefresh: controller.refreshTickets,
          child: ListView.builder(
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
          ),
        );
      }),
    );
  }

  Widget _buildDrawer(BuildContext context, Color textcolor) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(box.read('userName') ?? 'John Doe'),
            accountEmail: Text(box.read('email') ?? 'john.doe@example.com'),
            currentAccountPicture: const CircleAvatar(
              child: Icon(Icons.person),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Get.back();
              Get.toNamed('/tickets');
            },
          ),
          ListTile(
            leading: Icon(Icons.brightness_6, color: textcolor),
            title: const Text('Settings'),
            onTap: () {
              themeController.toggleTheme();
              Navigator.of(context).pop(); // Close instantly
            },
          ),
          ListTile(
            leading: Icon(Icons.language, color: textcolor),
            title: Text('language'.tr, style: TextStyle(color: textcolor)),
            onTap: () {
              final isArabic = localeController.locale.languageCode == 'ar';
              localeController.switchLanguage(isArabic ? 'en' : 'ar');
              Navigator.of(context).pop(); // Close instantly
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text('logout'.tr, style: TextStyle(color: textcolor)),
            onTap: () {
              Get.offNamed('/');
              box.write('session', "");
            },
          ),
        ],
      ),
    );
  }
}

Map<String, List<Ticket>> _groupTicketsByPriority(List<Ticket> tickets) {
  final map = <String, List<Ticket>>{
    'high_priority': [],
    'medium_priority': [],
    'low_priority': [],
    'other': [],
  };

  for (final t in tickets) {
    final p = t.priority!.toLowerCase();
    if (p == '3' || p == 'low') {
      map['low_priority']!.add(t);
    } else if (p == '2' || p == 'medium') {
      map['medium_priority']!.add(t);
    } else if (p == '1' || p == 'high') {
      map['high_priority']!.add(t);
    } else {
      map['other']!.add(t);
    }
  }

  if (map['other']!.isEmpty) {
    map.remove('other');
  }
  return map;
}
