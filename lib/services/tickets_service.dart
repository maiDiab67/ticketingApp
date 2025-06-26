import '/models/ticket_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';

class TicketService {
  final box = GetStorage();

  Future<List<Ticket>> fetchTickets() async {
    const baseUrl = 'http://91.109.114.131:18102'; // Replace this
    final url = Uri.parse('$baseUrl/api/tickets');
    final token = box.read('token');
    print(token);
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/Text',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
      final data = jsonDecode(response.body);
      final results = data['data'] as List;
      return results.map((json) => Ticket.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tickets');
    }
  }
}
