import 'package:aabu_project/library/const_var.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:aabu_project/screens/edit_post/edit_post_step2.dart';
import '../../library/classes/Classes.dart';

class EditPostStep1 extends StatefulWidget {
  final Jop job;

  const EditPostStep1({super.key, required this.job});

  @override
  State<EditPostStep1> createState() => _EditPostStep1State();
}

class _EditPostStep1State extends State<EditPostStep1> {
  File? _videoFile;
  List<File> _imageFiles = [];
  bool _isVideoDeleted = false; // تتبع حالة حذف الفيديو الحالي
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // تهيئة الصور الحالية إذا كانت موجودة
    if (widget.job.images.isNotEmpty) {
      _imageFiles = [];
    }
    // تهيئة الفيديو
    _videoFile = null;
    _isVideoDeleted = false;
  }

  Future<void> _pickVideo() async {
    final XFile? picked = await picker.pickVideo(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _videoFile = File(picked.path);
        _isVideoDeleted = false; // إعادة تعيين حالة الحذف عند اختيار فيديو جديد
      });
    }
  }

  Future<void> _pickImages() async {
    final List<XFile> picked = await picker.pickMultiImage();
    if (picked.isNotEmpty) {
      setState(() {
        int remaining = 9 - _imageFiles.length;
        _imageFiles
            .addAll(picked.take(remaining).map((xfile) => File(xfile.path)));
      });
    }
  }

  Widget _buildVideoContainer() {
    return GestureDetector(
      onTap: _pickVideo,
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Center(
              child: _videoFile != null
                  ? Text(
                      "✅ تم اختيار فيديو\n${_videoFile!.path.split('/').last}",
                      textAlign: TextAlign.center,
                    )
                  : widget.job.videoUrl != null && !_isVideoDeleted
                      ? Text(
                          "📹 فيديو الحالي\n${widget.job.videoUrl!.split('/').last}",
                          textAlign: TextAlign.center,
                        )
                      : const Icon(Icons.video_library, size: 60),
            ),
            if (_videoFile != null ||
                (widget.job.videoUrl != null && !_isVideoDeleted))
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _videoFile = null;
                      _isVideoDeleted = true; // تعيين حالة الحذف
                    });
                  },
                  child: const CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.red,
                    child: Icon(Icons.close, size: 14, color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagesGrid() {
    return GridView.builder(
      itemCount: 9,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        if (index < _imageFiles.length) {
          return Stack(
            alignment: Alignment.topRight,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  _imageFiles[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _imageFiles.removeAt(index);
                  });
                },
                child: const CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.red,
                  child: Icon(Icons.close, size: 14, color: Colors.white),
                ),
              )
            ],
          );
        } else if (index < _imageFiles.length + widget.job.images.length) {
          return Stack(
            alignment: Alignment.topRight,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  widget.job.images[index - _imageFiles.length],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    widget.job.images.removeAt(index - _imageFiles.length);
                  });
                },
                child: const CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.red,
                  child: Icon(Icons.close, size: 14, color: Colors.white),
                ),
              )
            ],
          );
        } else {
          return GestureDetector(
            onTap: _pickImages,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: const Center(child: Icon(Icons.image_outlined)),
            ),
          );
        }
      },
    );
  }

  void _submit() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("تمت الموافقة وحفظ البيانات")),
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPostStep2(
          job: widget.job,
          videoFile: _videoFile,
          imageFiles: _imageFiles,
          isVideoDeleted: _isVideoDeleted, // تمرير حالة حذف الفيديو
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.all(32.0),
                child: Center(
                  child: Text(
                    "تعديل منشور",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              _buildVideoContainer(),
              const SizedBox(height: 16),
              _buildImagesGrid(),
              const SizedBox(height: 24),
              const Text(
                "اختر صورًا واضحة وجذابة تعبر عن مهارتك في المهنة، فالصورة الجيدة تساعدك في جذب المزيد من العملاء!",
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "الخطوة",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const Text(
                        "1/2",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(width: 200),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: (_videoFile != null ||
                                _imageFiles.isNotEmpty ||
                                widget.job.images.isNotEmpty ||
                                (widget.job.videoUrl != null &&
                                    !_isVideoDeleted))
                            ? _submit
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: my_Color,
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "موافقة",
                          style: TextStyle(fontSize: 16, color: Colors.white),
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
    );
  }
}
