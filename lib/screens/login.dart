import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Container(
          width: width > 600.w ? 400.w : width * 0.9,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              if (!isDark)
                const BoxShadow(color: Colors.black12, blurRadius: 10),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Team Ticketing App',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
               SizedBox(height: 8.h),
              Text('welcome'.tr, style: Theme.of(context).textTheme.bodyMedium),
               SizedBox(height: 24.h),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  'email'.tr,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
               SizedBox(height: 4.h
               ),
              TextField(
                controller: controller.emailController,

                decoration: InputDecoration(
                  hintText: 'email'.tr,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
               SizedBox(height: 16.h),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  'password'.tr,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
               SizedBox(height: 4.h),
              Obx(
                () => TextField(
                  controller: controller.passwordController,
                  obscureText: controller.obscureText.value,
                  decoration: InputDecoration(
                    hintText: '••••••••',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.obscureText.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        controller.obscureText.value =
                            !controller.obscureText.value;
                      },
                    ),
                  ),
                ),
              ),

               SizedBox(height: 24.h),
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF195D52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed:
                        controller.isLoading.value ? null : controller.login,

                    child:
                        controller.isLoading.value
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : Text(
                              'sign_in'.tr,
                              style: const TextStyle(color: Colors.white),
                            ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
