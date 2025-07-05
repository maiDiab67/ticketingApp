import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;

  final box = GetStorage();
  Future<void> login() async {
    isLoading.value = true;
    final url = Uri.parse('http://91.109.114.135:18102/odoo_connect');

    final login = emailController.text.trim();
    final password = passwordController.text;

    print("Trying login with:");
    print("db: ERP_250619");
    print("login: [$login]");
    print("password: [$password]");

    try {
      final response = await http.post(
        url,
        headers: {
          'db': 'ERP_250619',
          'login': 'abdulkhaliq.yas@agile.iq',
          'password': '123',
          'Cookie':
              'frontend_lang=en_US; session_id=KbVwLfSDfWMKsPeesoH9vJKt94TrLMTp2dX-wuJvVLW1IE5Njttq-S-UIT3N0wVQXllNCC_Ggja3vU8urqFQ',
        },
        body: {},
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200 && response.body.contains('api-key')) {
        final data = jsonDecode(response.body);
        final apiKey = data['api-key'];
        box.write('api_key', apiKey);
        // 🟢 استخراج وتخزين session_id
        final rawCookies = response.headers['set-cookie'];
        if (rawCookies != null) {
          final sessionCookie = rawCookies
              .split(';')
              .firstWhere(
                (cookie) => cookie.trim().startsWith('session_id='),
                orElse: () => '',
              );

          if (sessionCookie.isNotEmpty) {
            box.write('session_id', sessionCookie);
          }
        }

        box.write('login', login);
        box.write('password', password);

        Get.offNamed('/tickets');
      } else if (response.body.contains('Wrong login credentials')) {
        Get.snackbar(
          'Login Failed',
          'Wrong login credentials',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          'Unexpected server response',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print("Exception: $e");
      Get.snackbar(
        'Error',
        'Connection error',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
