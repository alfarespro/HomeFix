import 'package:flutter/material.dart';
import 'package:aabu_project/app_theme/app_theme.dart';

class NavigationTest extends StatelessWidget {
  NavigationTest({super.key});

  // قائمة المسارات مع أسماء الأزرار المعروضة
  final List<Map<String, String>> routes = [
    {'name': 'تسجيل الدخول', 'route': '/LoginPage'},
    {'name': 'إنشاء حساب', 'route': '/SignupPage'},
    {'name': 'رمز التحقق', 'route': '/OTPScreen'},
    {'name': 'إنشاء حساب جديد', 'route': '/create_account'},
    {'name': 'إعادة كلمة المرور 1', 'route': '/reset_pass_with_old_pass'},
    {'name': 'إعادة كلمة المرور 2', 'route': '/reset_pass_after_otp'},
    {'name': 'MyPost', 'route': '/MyPost'},
    {'name': 'MyPosts', 'route': '/MyPosts'},
    {'name': 'NotPost', 'route': '/NotMyPost'},
    {'name': 'SavedPosts', 'route': '/SavedPosts'},
    {'name': 'إنشاء ملف شخصي', 'route': '/CreateProfilePage'},
    {'name': 'اعادة كلمة السر عبر رقم الهاتف', 'route': '/verify_code_page'},
    {
      'name': 'صفحة تجريبية',
      'route': '/reset_pass_after_otp',
    }, // مكررة كمثال لتكملة 10 أزرار
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A2526), // نفس خلفية home_page
      appBar: AppBar(
        title: const Text(
          'القائمة',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(routes.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (routes[index]['route'] == '/OTPScreen') {
                        // تمرير المتغيرات المطلوبة لصفحة OTPScreen
                        Navigator.pushNamed(
                          context,
                          routes[index]['route']!,
                          arguments: {'isSignUp': true},
                        );
                      } else {
                        Navigator.pushNamed(context, routes[index]['route']!);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 50),
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      routes[index]['name']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
