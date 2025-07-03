import '/models/ticket_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';

class TicketService {
  final box = GetStorage();

  Future<List<Ticket>> fetchTickets() async {
    final session = box.read('session_id');
    final apiKey = box.read('api_key');
    final login = box.read('login') ?? 'abdulkhaliq.yas@agile.iq';
    final password = box.read('password') ?? '123';

    final url = Uri.parse(
      'http://91.109.114.135:18102/send_request?model=request.request',
    );

    var request = http.Request('GET', url);

    // ✅ body كما في postman
    request.body = json.encode({
      "fields": [
        "id",
        "name",
        "stage_id",
        "date_created",
        "date_assigned",
        "action_ids",
        "partner_id",
        "partner_ticket_phone",
        "partner_type_id",
        "related_site_survey_id",
        "area_id",
        "customer_service_type",
        "supercell_account_no",
        "company_id",
        "request_start_datetime",
        "priority",
      ],
    });

    // ✅ headers
    request.headers.addAll({
      'Content-Type': 'application/json',
      if (session != null) 'Cookie': session,
      if (apiKey != null) 'api-key': apiKey,
      'login': login,
      'password': password,
    });

    // ⏳ إرسال الطلب
    http.StreamedResponse streamedResponse = await request.send();

    // 📥 تحويل الاستجابة إلى string
    final responseBody = await streamedResponse.stream.bytesToString();

    print("Status Code: ${streamedResponse.statusCode}");
    print("Response Body: $responseBody");

    if (streamedResponse.statusCode == 200) {
      final data = jsonDecode(responseBody);
      final results = data['records'] as List;
      return results.map((json) => Ticket.fromJson(json)).toList();
    } else {
      throw Exception('❌ Failed to load tickets');
    }
  }
}
