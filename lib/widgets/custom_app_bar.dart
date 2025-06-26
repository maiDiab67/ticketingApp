import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/theme_controller.dart';
import '../controllers/locale_controller.dart';
import 'package:get_storage/get_storage.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;
  final box = GetStorage();

  CustomAppBar({Key? key})
      : preferredSize = const Size.fromHeight(60.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final localeController = Get.find<LocaleController>();

    return AppBar(
      title: Text('welcome'.tr),
      actions: [
        TextButton(
          onPressed: () {
            final isArabic = localeController.locale.languageCode == 'ar';
            localeController.switchLanguage(isArabic ? 'en' : 'ar');
          },
          child: Text('language'.tr, style: TextStyle(color: Colors.black)),
        ),
        IconButton(
          icon: Icon(Icons.brightness_6),
          onPressed: themeController.toggleTheme,
        ),
        TextButton(
          onPressed: () {
            // TODO: Add logout logic
            Get.offNamed('/');
            box.write('session', "");
          },
          child: Text('logout'.tr, style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }
}
