import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocaleController extends GetxController {
  var locale = Locale('ar', 'EG');

  void switchLanguage(String languageCode) {
    if (languageCode == 'ar') {
      locale = Locale('ar', 'EG');
    } else {
      locale = Locale('en', 'US');
    }
    Get.updateLocale(locale); // 🔥 This triggers UI update
  }
}
