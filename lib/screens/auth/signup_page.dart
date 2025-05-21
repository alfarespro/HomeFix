import 'package:aabu_project/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  String? _firstNameError;
  String? _lastNameError;
  String? _phoneNumberError;
  String? _passwordError;
  String? _confirmPasswordError;
  final AuthService _authService = AuthService();

  // Validate inputs
  bool _validateInputs() {
    bool isValid = true;
    setState(() {
      _firstNameError = null;
      _lastNameError = null;
      _phoneNumberError = null;
      _passwordError = null;
      _confirmPasswordError = null;
    });

    if (_firstName.text.trim().isEmpty) {
      _firstNameError = 'يرجى إدخال الاسم الأول';
      isValid = false;
    }
    if (_lastName.text.trim().isEmpty) {
      _lastNameError = 'يرجى إدخال الاسم الأخير';
      isValid = false;
    }
    if (_phoneNumber.text.trim().isEmpty) {
      _phoneNumberError = 'يرجى إدخال رقم الهاتف';
      isValid = false;
    } else if (!_phoneNumber.text.trim().startsWith('07') &&
        !_phoneNumber.text.trim().startsWith('+962')) {
      _phoneNumberError = 'رقم الهاتف يجب أن يبدأ بـ 07 أو +962';
      isValid = false;
    } else if (_phoneNumber.text.trim().startsWith('07') &&
        _phoneNumber.text.trim().length != 10) {
      _phoneNumberError = 'رقم الهاتف يجب أن يكون 10 أرقام';
      isValid = false;
    }
    if (_password.text.trim().isEmpty) {
      _passwordError = 'يرجى إدخال كلمة المرور';
      isValid = false;
    } else if (_password.text.trim().length < 6) {
      _passwordError = 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
      isValid = false;
    }
    if (_confirmPassword.text.trim().isEmpty) {
      _confirmPasswordError = 'يرجى تأكيد كلمة المرور';
      isValid = false;
    } else if (_password.text.trim() != _confirmPassword.text.trim()) {
      _confirmPasswordError = 'كلمات المرور غير متطابقة';
      isValid = false;
    }

    return isValid;
  }

  // Start phone authentication
  Future<void> _startPhoneAuth() async {
    if (!_validateInputs()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.sendOTP(
        _phoneNumber.text.trim(),
        (String verificationId, int? resendToken) {
          Navigator.pushNamed(context, '/OTPScreen', arguments: {
            'verificationId': verificationId,
            'phoneNumber': _phoneNumber.text.trim(),
            'firstName': _firstName.text.trim(),
            'lastName': _lastName.text.trim(),
            'password': _password.text.trim(),
            'isSignUp': true,
            'isResetPassword': false,
          });
        },
        (String error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error)),
          );
        },
        () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم التحقق تلقائيًا')),
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Image.asset(
                  "assets/logo.png",
                  height: 200,
                ),
              ),
              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "ابدأ بإنشاء الحساب",
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _firstName,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                          borderSide:
                              BorderSide(color: Color(0xFFE0E8FF), width: 1),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                          borderSide:
                              BorderSide(color: Color(0xFFE0E8FF), width: 1),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                          borderSide:
                              BorderSide(color: Color(0xFFE0E8FF), width: 1),
                        ),
                        hintText: "الاسم الأول",
                        hintTextDirection: TextDirection.rtl,
                        hintStyle: const TextStyle(color: Colors.grey),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        errorText: _firstNameError,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: TextField(
                      controller: _lastName,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                          borderSide:
                              BorderSide(color: Color(0xFFE0E8FF), width: 1),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                          borderSide:
                              BorderSide(color: Color(0xFFE0E8FF), width: 1),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                          borderSide:
                              BorderSide(color: Color(0xFFE0E8FF), width: 1),
                        ),
                        hintText: "الاسم الأخير",
                        hintTextDirection: TextDirection.rtl,
                        hintStyle: const TextStyle(color: Colors.grey),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        errorText: _lastNameError,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _phoneNumber,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                    borderSide: BorderSide(color: Color(0xFFE0E8FF), width: 1),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                    borderSide: BorderSide(color: Color(0xFFE0E8FF), width: 1),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                    borderSide: BorderSide(color: Color(0xFFE0E8FF), width: 1),
                  ),
                  hintText: "رقم الهاتف",
                  hintTextDirection: TextDirection.rtl,
                  hintStyle: const TextStyle(color: Colors.grey),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  errorText: _phoneNumberError,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _password,
                obscureText: !_isPasswordVisible,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                    borderSide: BorderSide(color: Color(0xFFE0E8FF), width: 1),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                    borderSide: BorderSide(color: Color(0xFFE0E8FF), width: 1),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                    borderSide: BorderSide(color: Color(0xFFE0E8FF), width: 1),
                  ),
                  hintText: "كلمة السر",
                  hintTextDirection: TextDirection.rtl,
                  hintStyle: const TextStyle(color: Colors.grey),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey[700],
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  errorText: _passwordError,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _confirmPassword,
                obscureText: !_isConfirmPasswordVisible,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                    borderSide: BorderSide(color: Color(0xFFE0E8FF), width: 1),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                    borderSide: BorderSide(color: Color(0xFFE0E8FF), width: 1),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                    borderSide: BorderSide(color: Color(0xFFE0E8FF), width: 1),
                  ),
                  hintText: "تأكيد كلمة السر",
                  hintTextDirection: TextDirection.rtl,
                  hintStyle: const TextStyle(color: Colors.grey),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey[700],
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                  errorText: _confirmPasswordError,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color(0xFFff9800),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    onPressed: _isLoading ? null : _startPhoneAuth,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('إنشاء حساب'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () =>
                          Navigator.pop(context), // Return to previous screen
                      child: const Text(
                        "تسجيل الدخول",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "لديك حساب؟",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Image.asset(
                  "assets/photo.png",
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _phoneNumber.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }
}
