import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/theme_controller.dart';
import 'controllers/locale_controller.dart';
import 'core/di/dependancy_injection.dart';
import 'screens/login.dart';
import 'utils/translations.dart';
import 'package:get_storage/get_storage.dart';
import 'screens/tickets_list.dart';

void main() async {
  setupGetIt();

  await GetStorage.init(); // Initialize storage
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeController themeController = Get.put(ThemeController());
  final LocaleController localeController = Get.put(LocaleController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => LoginScreen()),
          GetPage(name: '/tickets', page: () => TicketsListScreen()),
        ],
        title: 'Agile',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: themeController.themeMode.value,
        translations: AppTranslations(),
        locale: localeController.locale,
        fallbackLocale: Locale('en', 'US'),
        home: LoginScreen(),
      ),
    );
  }
}
