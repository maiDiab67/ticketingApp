import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../features/login/data/models/login_request_body.dart';
import '../features/login/logic/login/login_cubit.dart';
import 'tickets_list.dart';
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
              const SizedBox(height: 8),
              Text('welcome'.tr, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 24),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  'email'.tr,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: controller.emailController,
                decoration: InputDecoration(
                  hintText: 'email'.tr,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  'password'.tr,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: controller.passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: '••••••••',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF195D52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      if (!controller.isLoading.value) {
                        Get.offNamed('/tickets');
                      }
                    },
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
