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
    loadStaticTickets();
    // loadTickets();
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

  void loadStaticTickets() {
    final staticData = [
      Ticket(
        id: 864,
        name: "SDEV_250625_00062",
        priority: 1,
        stageName: "draft",
        typeName: "Fiber Installation",
        requestText: "Install fiber at customer location.",
        authorName: "ahmed mohamed ahmed",
        dateCreated: "2025-06-25T10:02:05",
        dateClosed: null,
        closed: false,
        serviceId: 101,
        type: "fiber",
      ),
      Ticket(
        id: 863,
        name: "SDEV_250625_00063",
        priority: 1,
        stageName: "resolved",
        typeName: "Support",
        requestText: "Customer reported no internet.",
        authorName: "ahmed mohamed ahmed",
        dateCreated: "2025-06-25T10:01:12",
        dateClosed: null,
        closed: false,
        serviceId: 102,
        type: "fiber",
      ),
      Ticket(
        id: 399,
        name: "SDEV_250604_00034",
        priority: 2,
        stageName: "waiting",
        typeName: "Survey",
        requestText: "Survey completed successfully.",
        authorName: "ahmed mohamed ahmed",
        dateCreated: "2025-06-04T06:54:29",
        dateClosed: "2025-06-05T10:00:00",
        closed: true,
        serviceId: 103,
        type: "fiber",
      ),
    ];

    tickets.assignAll(staticData);
    isLoading.value = false;
  }
}
