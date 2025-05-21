// lib/NotMyPost.dart
import 'package:flutter/material.dart';
import 'package:aabu_project/library/custom/CustomWidgets.dart';
import 'package:aabu_project/library/GV.dart';
import 'package:aabu_project/services/api/job_api.dart';
import 'package:aabu_project/library/classes/Classes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';
import 'package:aabu_project/library/media_viewer.dart';

class NotMyPost extends StatefulWidget {
  NotMyPost({super.key});

  @override
  State<NotMyPost> createState() => _NotMyPostState();
}

class _NotMyPostState extends State<NotMyPost> {
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
  bool addComment = false;
  final TextEditingController _commentController = TextEditingController();
  double _rating = 0.0;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _postsCollection = 'posts';
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _commentCardKey = GlobalKey();
  Jop? _job;
  bool _hasCommented = false;
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _checkIfCommented();
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _scrollController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _checkIfCommented() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || _job == null) return;
    try {
      final commentSnapshot = await _firestore
          .collection(_postsCollection)
          .doc(_job!.id)
          .collection('comments')
          .where('userId', isEqualTo: user.uid)
          .get();
      setState(() {
        _hasCommented = commentSnapshot.docs.isNotEmpty;
      });
    } catch (e) {
      print('Error checking comment status: $e');
    }
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
        await _checkIfCommented();
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

  Future<void> _addComment(String jobId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('يرجى تسجيل الدخول لإضافة تعليق')),
      );
      return;
    }
    if (_commentController.text.isEmpty || _rating == 0.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('يرجى إدخال تعليق وتقييم')),
      );
      return;
    }
    final commentData = {
      'comment': _commentController.text,
      'rating': {'rate': _rating, 'count': 1},
    };
    final response = await _jobApi.addCommentAndRating(jobId, commentData);
    if (response['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم إضافة التعليق بنجاح')),
      );
      setState(() {
        addComment = false;
        _commentController.clear();
        _rating = 0.0;
        _hasCommented = true;
      });
      await _fetchComments(jobId);
      await _fetchJob(jobId);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل في إضافة التعليق: ${response['error']}')),
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
        setState(() {
          _hasCommented = false;
        });
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

  void launchDialer(String data) async {
    final Uri uri = Uri(scheme: 'tel', path: data);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  void _scrollToCommentCard() {
    final context = _commentCardKey.currentContext;
    if (context != null) {
      final RenderBox box = context.findRenderObject() as RenderBox;
      final position = box.localToGlobal(Offset.zero).dy;
      final offset = position + _scrollController.offset - 100;
      _scrollController.animateTo(
        offset,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
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

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 350,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: PageView.builder(
              reverse: true, // عكس ترتيب الوسائط
              itemCount: media.length,
              controller: PageController(initialPage: 0),
              onPageChanged: (index) {
                setState(() {
                  photoIndex = index;
                  if (_videoController != null && index != (media.length - 1)) {
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
      ],
    );
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
    fullRating = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(rating, style: GS),
        RatingIcon(rate: J.rating.rate),
        Text(rating2, style: GM),
      ],
    );

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: lightgray,
        body: Column(
          children: [
            Expanded(
              child: ListView(
                controller: _scrollController,
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
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (!_hasCommented)
                                    CustomButton(
                                      label: "تقييم",
                                      action: () {
                                        setState(() {
                                          addComment = true;
                                        });
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          _scrollToCommentCard();
                                        });
                                      },
                                    ),
                                  Text(title, style: BBM),
                                ],
                              ),
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
                            if (addComment)
                              CustomContainer(
                                key: _commentCardKey,
                                Children: [
                                  AddRating(
                                    onRatingChanged: (value) {
                                      setState(() {
                                        _rating = value;
                                      });
                                    },
                                  ),
                                  SizedBox(height: 10),
                                  TextField(
                                    controller: _commentController,
                                    textAlign: TextAlign.right,
                                    textDirection: TextDirection.rtl,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(18)),
                                        borderSide: BorderSide(
                                            color: Color(0xFFE0E8FF), width: 1),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(18)),
                                        borderSide: BorderSide(
                                            color: Color(0xFFE0E8FF), width: 1),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(18)),
                                        borderSide:
                                            BorderSide(color: orange, width: 1),
                                      ),
                                      hintText: "أخبر الاخرين برأيك",
                                      hintTextDirection: TextDirection.rtl,
                                      hintStyle: GS,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 15),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  CustomButton(
                                    label: "إرسال التعليق",
                                    action: () => _addComment(J.id),
                                  ),
                                ],
                              ),
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomButton(
                    label: "تواصل معه",
                    action: () {
                      print("رقم الهاتف: $mobileNumber");
                      launchDialer(mobileNumber);
                    },
                  ),
                  Spacer(flex: 1),
                  Text("السعر لكل خروج ", style: GS),
                  Text(price, style: WS),
                ],
              ),
            ),
            Container(color: black, height: 40, width: double.infinity),
          ],
        ),
      ),
    );
  }
}
