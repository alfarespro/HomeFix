// lib/MyPost.dart
import 'package:flutter/material.dart';
import 'package:aabu_project/library/custom/CustomWidgets.dart';
import 'package:aabu_project/library/GV.dart';
import 'package:aabu_project/services/api/job_api.dart';
import 'package:aabu_project/library/classes/Classes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';
import 'package:aabu_project/library/media_viewer.dart';

class MyPost extends StatefulWidget {
  MyPost({super.key});

  @override
  State<MyPost> createState() => _MyPostState();
}

class _MyPostState extends State<MyPost> {
  String title = '';
  String price = '';
  List<String> photos = [];
  String location = '';
  String description = '';
  String mobileNumber = '';
  String rating = '';
  String rating2 = '';
  Widget fullRating = SizedBox();
  List<Comment> commentsList = [];
  int photoIndex = 0;
  final JobApi _jobApi = JobApi();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _postsCollection = 'posts';
  Jop? _job;
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _fetchJob(String jobId) async {
    try {
      final response = await _jobApi.getJobById(jobId);
      if (response['success']) {
        setState(() {
          _job = Jop.fromJson(response['data']);
          if (_job?.videoUrl != null) {
            _videoController = VideoPlayerController.network(_job!.videoUrl!)
              ..initialize().then((_) {
                setState(() {});
              });
          }
        });
      } else {
        throw Exception(response['error']);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل في جلب بيانات المنشور: $e')),
      );
    }
  }

  Future<void> _fetchComments(String jobId) async {
    try {
      final commentsSnapshot = await _firestore
          .collection(_postsCollection)
          .doc(jobId)
          .collection('comments')
          .orderBy('createdAt', descending: true)
          .get();
      setState(() {
        commentsList = commentsSnapshot.docs
            .map((doc) => Comment.fromJson(doc.data()))
            .toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل في جلب التعليقات: $e')),
      );
    }
  }

  Future<void> _deleteComment(String jobId, String commentId) async {
    try {
      final response = await _jobApi.deleteComment(jobId, commentId);
      if (response['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم حذف التعليق بنجاح')),
        );
        await _fetchComments(jobId);
        await _fetchJob(jobId);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل في حذف التعليق: ${response['error']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء الحذف: $e')),
      );
    }
  }

  Widget _buildMedia() {
    List<dynamic> media = [];
    if (_job?.videoUrl != null) {
      media.add({'type': 'video', 'url': _job!.videoUrl});
    }
    media.addAll(photos.map((photo) => {'type': 'image', 'url': photo}));

    if (media.isEmpty) {
      return Container(
        height: 350,
        width: double.infinity,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child:
              Image.asset("assets/PlaceholderFull.jpg", fit: BoxFit.fitWidth),
        ),
      );
    }

    return Stack(alignment: Alignment.bottomCenter, children: [
      Container(
        height: 350,
        width: double.infinity,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: PageView.builder(
            itemCount: media.length,
            controller: PageController(initialPage: photoIndex),
            onPageChanged: (index) {
              setState(() {
                photoIndex = index;
                if (_videoController != null && index != 0) {
                  _videoController!.pause();
                }
              });
            },
            itemBuilder: (context, index) {
              final item = media[index];
              if (item['type'] == 'video' && _videoController != null) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MediaViewer(
                          videoUrl: _job?.videoUrl,
                          images: photos,
                        ),
                      ),
                    );
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      _videoController!.value.isInitialized
                          ? VideoPlayer(_videoController!)
                          : Center(child: CircularProgressIndicator()),
                      if (!_videoController!.value.isPlaying)
                        IconButton(
                          icon: Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 60,
                          ),
                          onPressed: () {
                            setState(() {
                              _videoController!.play();
                            });
                          },
                        ),
                    ],
                  ),
                );
              } else {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MediaViewer(
                          videoUrl: _job?.videoUrl,
                          images: photos,
                        ),
                      ),
                    );
                  },
                  child: Image.network(
                    item['url'],
                    fit: BoxFit.fitWidth,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                        "assets/PlaceholderFull.jpg",
                        fit: BoxFit.fitWidth),
                  ),
                );
              }
            },
          ),
        ),
      ),
      if (media.length > 1)
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                media.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  width: 8.0,
                  height: 8.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: photoIndex == (index) ? Colors.white : Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final J = _job ?? (ModalRoute.of(context)!.settings.arguments as Jop);
    if (_job == null) {
      _job = J;
      if (_job?.videoUrl != null) {
        _videoController = VideoPlayerController.network(_job!.videoUrl!)
          ..initialize().then((_) {
            setState(() {});
          });
      }
      if (commentsList.isEmpty) {
        _fetchComments(J.id);
      }
    }

    title = J.title;
    price = "\$ ${J.price}";
    photos = J.images;
    location = "${J.city}، ${J.town}";
    description = J.description;
    mobileNumber = J.mobileNumber;
    rating = "[ عدد التقييمات : ${J.rating.count} ]";
    rating2 = " ${J.rating.rate.toStringAsFixed(1)}";
    fullRating = Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(rating, style: GS),
          RatingIcon(rate: J.rating.rate),
          Text(rating2, style: GM),
        ],
      ),
    );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: lightgray,
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Column(
                    children: [
                      Container(
                        color: white,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildMedia(),
                            SizedBox(height: 20),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(title, style: BBM),
                            ),
                            SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(location, style: GS),
                            ),
                            SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: fullRating,
                            ),
                            SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text("الوصف", style: BS),
                            ),
                            SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                description,
                                style: GS,
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text("أبرز التعليقات", style: BS),
                            ),
                            SizedBox(height: 10),
                            commentsList.isEmpty
                                ? Center(
                                    child:
                                        Text("لا توجد تعليقات بعد", style: GS))
                                : Column(
                                    children: [
                                      for (int i = 0;
                                          i < commentsList.length;
                                          i++)
                                        CommentCard(
                                          comment: commentsList[i],
                                          onDelete: () => _deleteComment(
                                              J.id, commentsList[i].id),
                                        ),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: black,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              height: 80,
              width: double.infinity,
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomButton(
                      label: "حذف المنشور",
                      action: () {
                        showDeleteConfirmationBottomSheet(J.id);
                      },
                      BG: WarningRed,
                    ),
                    Spacer(flex: 1),
                    Text("السعر لكل خروج ", style: GS),
                    Text(price, style: WS),
                  ],
                ),
              ),
            ),
            Container(color: black, height: 40, width: double.infinity),
          ],
        ),
      ),
    );
  }

  void showDeleteConfirmationBottomSheet(String jobId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "تأكيد الحذف",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, size: 30),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              "هل أنت متأكد من حذف هذا المنشور؟",
              style: TextStyle(fontSize: 16, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            Text(
              "لن تتمكن من استرجاع المنشور بعد حذفه .",
              style: TextStyle(fontSize: 16, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(cyan),
                    foregroundColor: WidgetStateProperty.all(black),
                    padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                    ),
                  ),
                  child: Container(
                    width: 100,
                    child: Center(
                      child: Text(
                        "إلغاء",
                        style: TextStyle(
                          color: black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    try {
                      final response = await _jobApi.deleteJob(jobId);
                      Navigator.pop(context);
                      if (response['success']) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('تم حذف المنشور بنجاح')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(response['error'])),
                        );
                      }
                    } catch (e) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('حدث خطأ أثناء الحذف: $e')),
                      );
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(WarningRed),
                    foregroundColor: WidgetStateProperty.all(Colors.white),
                    padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                    ),
                  ),
                  child: Container(
                    width: 100,
                    child: Center(
                      child: Text(
                        "حذف",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
