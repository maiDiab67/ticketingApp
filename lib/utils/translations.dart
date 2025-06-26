import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'login': 'Login',
          'email': 'Email',
          'password': 'Password',
          'forgot_password': 'Forgot password?',
          'sign_in': 'Sign In',
          'use_biometric': 'Use Biometric',
          'welcome': 'Welcome',
        },
        'ar_EG': {
          'login': 'تسجيل الدخول',
          'email': 'البريد الإلكتروني',
          'password': 'كلمة المرور',
          'forgot_password': 'هل نسيت كلمة المرور؟',
          'sign_in': 'تسجيل الدخول',
          'use_biometric': 'استخدام البصمة',
          'welcome': 'مرحباً',
        },
      };
}