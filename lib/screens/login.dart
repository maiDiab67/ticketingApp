import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart'; // <-- Don't forget this!
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

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Center(
        child: Container(
          width: width > 600 ? 400 : width * 0.9,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
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
                alignment: Alignment.centerLeft,
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
                alignment: Alignment.centerLeft,
                child: Text(
                  'password'.tr,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: controller.passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: '••••••••',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
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
                      controller.isLoading.value ? null : controller.login();
                      // context.read<LoginCubit>().emitLoginStates(
                      //   LoginRequestBody(
                      //     login:
                      //         context
                      //             .read<LoginCubit>()
                      //             .emailController
                      //             .text,
                      //     password:
                      //         context
                      //             .read<LoginCubit>()
                      //             .passwordController
                      //             .text,
                      //   ),
                      // );
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

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF9FAFB),
//       body: Center(
//         child: Container(
//           width: width > 600 ? 400 : width * 0.9,
//           padding: const EdgeInsets.all(24),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black12,
//                 blurRadius: 10,
//               ),
//             ],
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 'Team Ticketing App', // Optional: add localization if needed
//                 style: const TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF195D52),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 'welcome'.tr, // Localized version of welcome
//                 style: const TextStyle(fontSize: 14, color: Colors.black54),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 24),
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   'email'.tr, // Localized label
//                   style: Theme.of(context).textTheme.labelLarge,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               TextField(
//                 decoration: InputDecoration(
//                   hintText: 'email'.tr, // Localized hint
//                   border: const OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(12)),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'password'.tr,
//                     style: Theme.of(context).textTheme.labelLarge,
//                   ),
//                   TextButton(
//                     onPressed: () {},
//                     child: Text(
//                       'forgot_password'.tr,
//                       style: const TextStyle(color: Color(0xFF195D52)),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 4),
//               const TextField(
//                 obscureText: true,
//                 decoration: InputDecoration(
//                   hintText: '••••••••',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(12)),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 24),
//               SizedBox(
//                 width: double.infinity,
//                 height: 48,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF195D52),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   onPressed: () {
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => TicketsListScreen()),
//                     );
//                   },
//                   child: Text(
//                     'sign_in'.tr,
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ),

//               // Uncomment below if you want to use the biometric button
//               // const SizedBox(height: 16),
//               // OutlinedButton.icon(
//               //   icon: const Icon(Icons.fingerprint, size: 20),
//               //   label: Text('use_biometric'.tr),
//               //   style: OutlinedButton.styleFrom(
//               //     padding: const EdgeInsets.symmetric(vertical: 14),
//               //     shape: RoundedRectangleBorder(
//               //       borderRadius: BorderRadius.circular(12),
//               //     ),
//               //   ),
//               //   onPressed: () {},
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
