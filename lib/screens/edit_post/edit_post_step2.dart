// lib/screens/edit_post/edit_post_step2.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:aabu_project/services/auth/auth_service.dart';
import 'package:aabu_project/services/api/job_api.dart';
import 'package:aabu_project/library/data_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../library/classes/Classes.dart';

class EditPostStep2 extends StatefulWidget {
  final Jop job;
  final File? videoFile;
  final List<File> imageFiles;
  final bool isVideoDeleted; // متغير جديد لتتبع حالة حذف الفيديو

  const EditPostStep2({
    super.key,
    required this.job,
    this.videoFile,
    required this.imageFiles,
    this.isVideoDeleted = false,
  });

  @override
  State<EditPostStep2> createState() => _EditPostStep2State();
}

class _EditPostStep2State extends State<EditPostStep2> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  String? _selectedCategory;
  String? _selectedProfession;
  String? _selectedCity;
  String? _selectedRegion;
  bool _isLoading = false;
  String? _videoUrl;
  List<String> _imageUrls = [];
  final AuthService _authService = AuthService();
  final JobApi _jobApi = JobApi();

  @override
  void initState() {
    super.initState();
    // Initialize fields with current job data
    _titleController = TextEditingController(text: widget.job.title);
    _descriptionController =
        TextEditingController(text: widget.job.description);
    _priceController = TextEditingController(text: widget.job.price.toString());
    _selectedCategory =
        widget.job.category.isNotEmpty ? widget.job.category : null;
    _selectedProfession =
        widget.job.subCategory.isNotEmpty ? widget.job.subCategory : null;
    _selectedCity = widget.job.city.isNotEmpty ? widget.job.city : null;
    _selectedRegion = widget.job.town.isNotEmpty ? widget.job.town : null;
    _imageUrls = List.from(widget.job.images);
    _videoUrl = widget.job.videoUrl; // تهيئة videoUrl بالفيديو الحالي

    // Update DataProvider with validation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dataProvider = Provider.of<DataProvider>(context, listen: false);
      // Ensure values are valid before setting
      if (dataProvider.categories.contains(widget.job.category)) {
        dataProvider.setCategory(widget.job.category);
        _selectedCategory = widget.job.category;
      } else {
        _selectedCategory = dataProvider.categories.isNotEmpty
            ? dataProvider.categories.first
            : null;
      }
      if (dataProvider.professions.contains(widget.job.subCategory)) {
        dataProvider.setProfession(widget.job.subCategory);
        _selectedProfession = widget.job.subCategory;
      } else {
        _selectedProfession = dataProvider.professions.isNotEmpty
            ? dataProvider.professions.first
            : null;
      }
      if (dataProvider.cities.contains(widget.job.city)) {
        dataProvider.setCity(widget.job.city);
        _selectedCity = widget.job.city;
      } else {
        _selectedCity =
            dataProvider.cities.isNotEmpty ? dataProvider.cities.first : null;
      }
      if (dataProvider.areas.contains(widget.job.town)) {
        dataProvider.setArea(widget.job.town);
        _selectedRegion = widget.job.town;
      } else {
        _selectedRegion =
            dataProvider.areas.isNotEmpty ? dataProvider.areas.first : null;
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<String?> _uploadToCloudinary(File file) async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dul7f7pmx/upload');
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = 'profile_pictures'
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final jsonData = jsonDecode(responseData);
        return jsonData['secure_url'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> _updateJob() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Upload new video if present
      if (widget.videoFile != null) {
        _videoUrl = await _uploadToCloudinary(widget.videoFile!);
        if (_videoUrl == null) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('فشل في رفع الفيديو')),
          );
          return;
        }
      } else if (widget.isVideoDeleted) {
        _videoUrl = ''; // تعيين videoUrl فارغ إذا تم حذف الفيديو
      } else {
        _videoUrl = widget.job.videoUrl; // الإبقاء على الفيديو الحالي
      }

      // Upload new images
      List<String> newImageUrls = List.from(_imageUrls);
      for (final image in widget.imageFiles) {
        final url = await _uploadToCloudinary(image);
        if (url != null) {
          newImageUrls.add(url);
        } else {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('فشل في رفع إحدى الصور')),
          );
          return;
        }
      }
      _imageUrls = newImageUrls;

      // Fetch user data
      final userData = await _authService.getUserData();
      if (userData == null) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('فشل في جلب بيانات المستخدم')),
        );
        return;
      }
      final mobileNumber = userData['phoneNumber'] ?? '';

      // Prepare updated job data
      final jobData = {
        'id': widget.job.id,
        'title': _titleController.text,
        'price': double.tryParse(_priceController.text) ?? 0.0,
        'description': _descriptionController.text,
        'category': _selectedCategory ?? '',
        'subcategory': _selectedProfession ?? '',
        'mobileNumber': mobileNumber,
        'city': _selectedCity ?? '',
        'town': _selectedRegion ?? '',
        'images': _imageUrls,
        'videoUrl': _videoUrl ?? '', // تضمين videoUrl (جديد، محذوف، أو حالي)
        'rating': widget.job.rating.toJson(),
        'userId': widget.job.userId,
        'createdAt': widget.job.createdAt.toIso8601String(),
      };

      // Call API to update
      try {
        final response = await _jobApi.updateJob(widget.job.id, jobData);
        setState(() {
          _isLoading = false;
        });

        if (response['success']) {
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/home_page');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم تعديل المنشور بنجاح')),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(response['error'] ?? 'فشل في تعديل المنشور')),
            );
          }
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('حدث خطأ: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);

    // Create a list of unique cities to avoid duplicates
    final uniqueCities = dataProvider.cities.toSet().toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'تعديل منشور',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  decoration: const InputDecoration(
                    hintText: 'عنوان المنشور',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(color: Color(0xFFE0E8FF)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(color: Color(0xFFE0E8FF)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(color: Color(0xFFE0E8FF)),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال عنوان المنشور';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value;
                            _selectedProfession = null; // Reset profession
                            dataProvider.setCategory(value);
                          });
                        },
                        items: dataProvider.categories.map((category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(category,
                                textDirection: TextDirection.rtl),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          hintText: 'الفئة',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                            borderSide: BorderSide(color: Color(0xFFE0E8FF)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                            borderSide: BorderSide(color: Color(0xFFE0E8FF)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                            borderSide: BorderSide(color: Color(0xFFE0E8FF)),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                        ),
                        isExpanded: true,
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.grey,
                          size: 24,
                        ),
                        validator: (value) {
                          if (value == null) {
                            return 'يرجى اختيار الفئة';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: dataProvider.professions
                                .contains(_selectedProfession)
                            ? _selectedProfession
                            : null,
                        onChanged: dataProvider.professions.isNotEmpty
                            ? (value) {
                                setState(() {
                                  _selectedProfession = value;
                                  dataProvider.setProfession(value);
                                });
                              }
                            : null,
                        items: dataProvider.professions.map((profession) {
                          return DropdownMenuItem<String>(
                            value: profession,
                            child: Text(profession,
                                textDirection: TextDirection.rtl),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          hintText: 'المهنة',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                            borderSide: BorderSide(color: Color(0xFFE0E8FF)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                            borderSide: BorderSide(color: Color(0xFFE0E8FF)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                            borderSide: BorderSide(color: Color(0xFFE0E8FF)),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                        ),
                        isExpanded: true,
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.grey,
                          size: 24,
                        ),
                        validator: (value) {
                          if (value == null &&
                              dataProvider.professions.isNotEmpty) {
                            return 'يرجى اختيار المهنة';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: uniqueCities.contains(_selectedCity)
                            ? _selectedCity
                            : null,
                        onChanged: (value) {
                          setState(() {
                            _selectedCity = value;
                            _selectedRegion = null;
                            dataProvider.setCity(value);
                          });
                        },
                        items: uniqueCities.map((city) {
                          return DropdownMenuItem<String>(
                            value: city,
                            child: Text(city, textDirection: TextDirection.rtl),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          hintText: 'المدينة',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                            borderSide: BorderSide(color: Color(0xFFE0E8FF)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                            borderSide: BorderSide(color: Color(0xFFE0E8FF)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                            borderSide: BorderSide(color: Color(0xFFE0E8FF)),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
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
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedRegion,
                        onChanged: (value) {
                          setState(() {
                            _selectedRegion = value;
                            dataProvider.setArea(value);
                          });
                        },
                        items: dataProvider.areas.map((region) {
                          return DropdownMenuItem<String>(
                            value: region,
                            child:
                                Text(region, textDirection: TextDirection.rtl),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          hintText: 'المنطقة',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                            borderSide: BorderSide(color: Color(0xFFE0E8FF)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                            borderSide: BorderSide(color: Color(0xFFE0E8FF)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                            borderSide: BorderSide(color: Color(0xFFE0E8FF)),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                        ),
                        isExpanded: true,
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.grey,
                          size: 24,
                        ),
                        validator: (value) {
                          if (value == null) {
                            return 'يرجى اختيار المنطقة';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _descriptionController,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'وصف مختصر يصف خبرتك أو مهنتك',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(color: Color(0xFFE0E8FF)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(color: Color(0xFFE0E8FF)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(color: Color(0xFFE0E8FF)),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال الوصف';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _priceController,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'السعر (ر.س)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(color: Color(0xFFE0E8FF)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(color: Color(0xFFE0E8FF)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(color: Color(0xFFE0E8FF)),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال السعر';
                    }
                    if (double.tryParse(value) == null) {
                      return 'يرجى إدخال رقم صحيح';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                const Text(
                  'تأكد من أن جميع معلوماتك دقيقة وواضحة، فكلما كانت التفاصيل أفضل، زادت فرصتك في الحصول على عملاء جادين!',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 30),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      children: [
                        Text(
                          'الخطوة',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                        Text(
                          '2/2',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                    Flexible(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _updateJob,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFff9800),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: const Text(
                          'تحديث',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
