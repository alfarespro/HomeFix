import 'package:flutter/material.dart';
import 'package:aabu_project/library/themes/button_theme.dart';
import 'package:aabu_project/library/themes/text_field_theme.dart';
import 'package:aabu_project/library/themes/app_bar_theme.dart';
import 'package:aabu_project/library/themes/text_theme.dart';
import 'package:aabu_project/services/auth/auth_service.dart';

class VerifyCodePage extends StatefulWidget {
  const VerifyCodePage({super.key});

  @override
  _VerifyCodePageState createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  final TextEditingController _codeController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
          style: getBackButtonStyle(),
        ),
        title: const Text('إعادة كلمة السر'),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _codeController,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              maxLines: 1,
              keyboardType: TextInputType.phone,
              style: getTextFieldTextStyle(),
              decoration: const InputDecoration(
                labelText: 'رقم الهاتف',
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'سنرسل لك رسالة SMS بها رمز لإعادة تعيين كلمة المرور الخاصة بك، يرجى إدخال رقم الهاتف المرتبط بحسابك.',
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
                    if (_codeController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('يرجى إدخال رقم الهاتف'),
                        ),
                      );
                      return;
                    }
                    await _authService.sendOTP(
                      _codeController.text.trim(),
                      (String verificationId, int? resendToken) {
                        Navigator.pushNamed(context, '/OTPScreen', arguments: {
                          'verificationId': verificationId,
                          'phoneNumber': _codeController.text.trim(),
                          'isSignUp': false,
                          'isResetPassword': true,
                        });
                      },
                      (String error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(error)),
                        );
                      },
                      () {},
                    );
                  },
                  child: const Text('إرسال الرمز'),
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
    _codeController.dispose();
    super.dispose();
  }
}
