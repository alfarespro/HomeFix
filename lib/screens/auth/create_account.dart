import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:aabu_project/services/auth/auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:aabu_project/library/data_provider.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final AuthService _authService = AuthService();

  File? _profileImage;
  String? _profileImageUrl;
  String? _selectedCity;
  String? _selectedArea;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final arguments =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      if (arguments != null) {
        _firstNameController.text = arguments['firstName'] ?? '';
        _lastNameController.text = arguments['lastName'] ?? '';
      }
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _addProfilePicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لم يتم اختيار صورة')),
      );
    }
  }

  Future<String?> _uploadToCloudinary(File image) async {
    final url =
        Uri.parse('https://api.cloudinary.com/v1_1/dul7f7pmx/image/upload');
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = 'profile_pictures'
      ..files.add(await http.MultipartFile.fromPath('file', image.path));

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final jsonData = jsonDecode(responseData);
        return jsonData['secure_url'];
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final dataProvider = Provider.of<DataProvider>(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'إنشاء ملف',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[200],
                backgroundImage:
                    _profileImage != null ? FileImage(_profileImage!) : null,
                child: _profileImage == null
                    ? Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.grey[800],
                      )
                    : null,
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _addProfilePicture,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.grey[200],
                  ),
                  width: 140,
                  height: 60,
                  child: const Center(
                    child: Text(
                      'اضف صورة',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFff9800),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _firstNameController,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                          borderSide:
                              BorderSide(color: Color(0xFFE0E8FF), width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                          borderSide:
                              BorderSide(color: Color(0xFFE0E8FF), width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                          borderSide:
                              BorderSide(color: Color(0xFFE0E8FF), width: 1),
                        ),
                        hintText: "الاسم الأول",
                        hintTextDirection: TextDirection.rtl,
                        hintStyle: TextStyle(color: Colors.grey),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _lastNameController,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                          borderSide:
                              BorderSide(color: Color(0xFFE0E8FF), width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                          borderSide:
                              BorderSide(color: Color(0xFFE0E8FF), width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                          borderSide:
                              BorderSide(color: Color(0xFFE0E8FF), width: 1),
                        ),
                        hintText: "الاسم الثاني",
                        hintTextDirection: TextDirection.rtl,
                        hintStyle: TextStyle(color: Colors.grey),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedCity,
                onChanged: (value) {
                  setState(() {
                    _selectedCity = value;
                    _selectedArea = null;
                    dataProvider.setCity(value);
                  });
                },
                items: dataProvider.cities.map((city) {
                  return DropdownMenuItem<String>(
                    value: city,
                    child: Text(
                      city,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                    borderSide: BorderSide(color: Color(0xFFE0E8FF), width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                    borderSide: BorderSide(color: Color(0xFFE0E8FF), width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                    borderSide: BorderSide(color: Color(0xFFE0E8FF), width: 1),
                  ),
                  hintText: "المدينة",
                  hintTextDirection: TextDirection.rtl,
                  hintStyle: TextStyle(color: Colors.grey),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                isExpanded: true,
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey,
                  size: 24,
                ),
                validator: (value) {
                  if (value == null) {
                    return 'يرجى اختيار المدينة';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedArea,
                onChanged: dataProvider.areas.isNotEmpty
                    ? (value) {
                        setState(() {
                          _selectedArea = value;
                          dataProvider.setArea(value);
                        });
                      }
                    : null,
                items: dataProvider.areas.map((area) {
                  return DropdownMenuItem<String>(
                    value: area,
                    child: Text(
                      area,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                    borderSide: BorderSide(color: Color(0xFFE0E8FF), width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                    borderSide: BorderSide(color: Color(0xFFE0E8FF), width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                    borderSide: BorderSide(color: Color(0xFFE0E8FF), width: 1),
                  ),
                  hintText: "المنطقة",
                  hintTextDirection: TextDirection.rtl,
                  hintStyle: TextStyle(color: Colors.grey),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
                isExpanded: true,
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey,
                  size: 24,
                ),
                validator: (value) {
                  if (value == null && dataProvider.areas.isNotEmpty) {
                    return 'يرجى اختيار المنطقة';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_firstNameController.text.isEmpty ||
                        _lastNameController.text.isEmpty ||
                        _selectedCity == null ||
                        (_selectedArea == null &&
                            dataProvider.areas.isNotEmpty)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('يرجى ملء جميع الحقول')),
                      );
                      return;
                    }

                    // Upload profile image to Cloudinary if selected
                    if (_profileImage != null) {
                      _profileImageUrl =
                          await _uploadToCloudinary(_profileImage!);
                      if (_profileImageUrl == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('فشل في رفع الصورة')),
                        );
                        return;
                      }
                    }

                    await _authService.completeSignUp(
                      phoneNumber: arguments['phoneNumber'],
                      firstName: _firstNameController.text,
                      lastName: _lastNameController.text,
                      password: arguments['password'],
                      city: _selectedCity ?? '',
                      area: _selectedArea ?? '',
                      profileImageUrl: _profileImageUrl,
                      onSuccess: () {
                        Navigator.pushReplacementNamed(context, '/home_page');
                      },
                      onError: (String error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(error)),
                        );
                      },
                    );
                  },
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
                  child: const Text('حفظ'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
