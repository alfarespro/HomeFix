import 'package:aabu_project/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class OTPScreen extends StatefulWidget {
  final bool isSignUp;
  final bool isResetPassword;

  const OTPScreen(
      {super.key, this.isSignUp = true, this.isResetPassword = false});

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  String? _errorMessage;
  final AuthService _authService = AuthService();

  Future<void> _verifyOTP(Map<String, dynamic> arguments) async {
    final String verificationId = arguments['verificationId'];
    final String phoneNumber = arguments['phoneNumber'];
    final String firstName = arguments['firstName'];
    final String lastName = arguments['lastName'];
    final String password = arguments['password'];

    final String smsCode = _otpControllers.map((c) => c.text).join();
    if (smsCode.length != 6) {
      setState(() {
        _errorMessage = 'يرجى إدخال رمز OTP مكون من 6 أرقام';
      });
      return;
    }

    await _authService.verifyOTP(
      verificationId: verificationId,
      smsCode: smsCode,
      onSuccess: () {
        if (mounted) {
          if (widget.isSignUp) {
            Navigator.pushNamed(context, '/create_account', arguments: {
              'phoneNumber': phoneNumber,
              'firstName': firstName,
              'lastName': lastName,
              'password': password,
            });
          } else if (widget.isResetPassword) {
            Navigator.pushNamed(context, '/reset_pass_after_otp', arguments: {
              'phoneNumber': phoneNumber,
            });
          } else {
            Navigator.pushReplacementNamed(context, '/home_page');
          }
        }
      },
      onError: (String error) {
        setState(() {
          _errorMessage = error;
        });
      },
    );
  }

  Future<void> _resendOTP(Map<String, dynamic> arguments) async {
    await _authService.sendOTP(
      arguments['phoneNumber'],
      (String verificationId, int? resendToken) {
        Navigator.pushNamed(context, '/OTPScreen', arguments: {
          'verificationId': verificationId,
          'phoneNumber': arguments['phoneNumber'],
          'firstName': arguments['firstName'],
          'lastName': arguments['lastName'],
          'password': arguments['password'],
          'isSignUp': widget.isSignUp,
          'isResetPassword': widget.isResetPassword,
        });
      },
      (String error) {
        setState(() {
          _errorMessage = error;
        });
      },
      () {
        if (mounted) {
          if (widget.isSignUp) {
            Navigator.pushNamed(context, '/create_account', arguments: {
              'phoneNumber': arguments['phoneNumber'],
              'firstName': arguments['firstName'],
              'lastName': arguments['lastName'],
              'password': arguments['password'],
            });
          } else if (widget.isResetPassword) {
            Navigator.pushNamed(context, '/reset_pass_after_otp', arguments: {
              'phoneNumber': arguments['phoneNumber'],
            });
          } else {
            Navigator.pushReplacementNamed(context, '/home_page');
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 70),
            const Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 28.0),
                child: Text(
                  "تأكيد رقم الهاتف",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) {
                return Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _otpControllers[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    decoration: const InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    onChanged: (value) {
                      if (value.length == 1 && index < 5) {
                        FocusScope.of(context).nextFocus();
                      } else if (value.isEmpty && index > 0) {
                        FocusScope.of(context).previousFocus();
                      }
                    },
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            const Text(
              '01:00',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "ستصلك رسالة SMS على رقم الهاتف ${arguments['phoneNumber']}.",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => _resendOTP(arguments),
              child: const Text(
                'لم تتلقى الرسالة؟ أعد الإرسال',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.teal,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 30),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _verifyOTP(arguments),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFFff9800),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
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
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
