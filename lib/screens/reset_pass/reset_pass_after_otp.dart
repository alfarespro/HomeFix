import 'package:flutter/material.dart';
import 'package:aabu_project/library/themes/button_theme.dart';
import 'package:aabu_project/library/themes/text_field_theme.dart';
import 'package:aabu_project/library/themes/app_bar_theme.dart';
import 'package:aabu_project/library/themes/text_theme.dart';
import 'package:aabu_project/services/auth/auth_service.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () {
            Navigator.pop(context);
          },
          style: getBackButtonStyle(),
        ),
        title: const Text('إعادة كلمة السر'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              maxLines: 1,
              style: getTextFieldTextStyle(),
              decoration: const InputDecoration(
                labelText: 'كلمة السر الجديدة',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              maxLines: 1,
              style: getTextFieldTextStyle(),
              decoration: const InputDecoration(
                labelText: 'إعادة كلمة السر الجديدة',
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'يرجى حفظ كلمة السر الجديدة حتى تتمكن من الرجوع إلى حسابك في أي وقت.',
              style: getDescriptionTextStyle(),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 30),
            Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_newPasswordController.text.isEmpty ||
                        _confirmPasswordController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'يرجى إدخال كلمة المرور الجديدة وتأكيدها')),
                      );
                      return;
                    }
                    if (_newPasswordController.text !=
                        _confirmPasswordController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('كلمات المرور غير متطابقة')),
                      );
                      return;
                    }
                    await _authService.resetPassword(
                      phoneNumber: arguments?['phoneNumber'],
                      newPassword: _newPasswordController.text,
                      onSuccess: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('تم تحديث كلمة المرور بنجاح')),
                        );
                        Navigator.pushReplacementNamed(context, '/LoginPage');
                      },
                      onError: (String error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(error)),
                        );
                      },
                    );
                  },
                  child: const Text('تأكيد'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
