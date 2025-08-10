import 'package:get/get.dart';
import '/services/tickets_service.dart';
import '/models/ticket_model.dart';

class TicketController extends GetxController {
  final TicketService _ticketService = TicketService();
  var tickets = <Ticket>[].obs;
  var isLoading = true.obs;
  var lastError = ''.obs; // <--- track error message

  @override
  void onInit() {
    super.onInit();
    loadTickets();
  }

  Future<bool> loadTickets({bool showLoading = true}) async {
    if (showLoading) isLoading.value = true;
    lastError.value = ''; // reset error state

    try {
      final result = await _ticketService.fetchTickets().timeout(
        const Duration(seconds: 15),
      );

      tickets.assignAll(result ?? []);

      if (tickets.isEmpty) {
        lastError.value = ''; // empty but no error
      }

      return true;
    } catch (e) {
      lastError.value = 'network'; // mark as network error
      return false;
    } finally {
      if (showLoading) isLoading.value = false;
    }
  }

  Future<void> refreshTickets() async {
    final backup = List<Ticket>.from(tickets);
    final success = await loadTickets(showLoading: false);
    if (!success) {
      tickets.assignAll(backup);
    }
  }
}
