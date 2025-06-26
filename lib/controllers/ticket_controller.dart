import 'package:get/get.dart';
import '/services/tickets_service.dart';
import '/models/ticket_model.dart';

class TicketController extends GetxController {
  final TicketService _ticketService = TicketService();
  var tickets = <Ticket>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadTickets();
  }

  void loadTickets() async {
    try {
      isLoading.value = true;
      tickets.value = await _ticketService.fetchTickets();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
