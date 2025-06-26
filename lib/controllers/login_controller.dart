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

    const baseUrl = 'http://91.109.114.131:18102'; // Replace this
    final url = Uri.parse('$baseUrl/api/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/Text'},
        body: jsonEncode({
          'email': emailController.text.trim(),
          'password': passwordController.text,
        }),
      );
      print(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = jsonDecode(response.body)['data']['token'];
        print('cookies');
        print(response.body);
        if (token != null) {
          box.write('token', token);
        }

        // Navigate on success
        Get.offNamed('/tickets');
      } else {
        final error = jsonDecode(response.body)['error'] ?? 'Login failed';
        Get.snackbar('Error', error, snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print(e);
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
