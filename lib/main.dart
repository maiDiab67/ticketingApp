import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'controllers/theme_controller.dart';
import 'controllers/locale_controller.dart';
import 'core/di/dependancy_injection.dart';
import 'screens/login.dart';
import 'utils/translations.dart';
import 'package:get_storage/get_storage.dart';
import 'screens/tickets_list.dart';
import 'package:intl/date_symbol_data_local.dart'; // ⬅️ هذه مهمة

void main() async {
  setupGetIt();
  await initializeDateFormatting(Get.locale?.languageCode ?? 'ar');

  await GetStorage.init(); // Initialize storage
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeController themeController = Get.put(ThemeController());
  final LocaleController localeController = Get.put(LocaleController());

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      child: Obx(
        () => GetMaterialApp(
          initialRoute: '/',
          getPages: [
            GetPage(name: '/', page: () => LoginScreen()),
            GetPage(name: '/tickets', page: () => TicketsListScreen()),
          ],
          // title: 'Agile',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light().copyWith(
            scaffoldBackgroundColor: const Color(0xFFF9FAFB),
            cardColor: Colors.white,
            // other light theme settings
          ),
          darkTheme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: const Color(0xFF121212),
            cardColor: const Color(0xFF1E1E1E),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: const Color(0xFF2C2C2C),
              hintStyle: TextStyle(color: Colors.grey.shade500),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            textTheme: ThemeData.dark().textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
          ),
          themeMode: themeController.themeMode.value,
          translations: AppTranslations(),
          locale: localeController.locale,
          fallbackLocale: Locale('en', 'US'),
          builder: (context, child) {
            return Directionality(
              textDirection:
                  Get.locale?.languageCode == 'ar'
                      ? TextDirection.rtl
                      : TextDirection.ltr,
              child: child!,
            );
          },
          home: LoginScreen(),
        ),
      ),
    );
  }
}
