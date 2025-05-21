// lib/services/api/job_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../library/classes/Classes.dart';

class JobService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String _postsCollection = 'posts';
  final String _savedPostsCollection = 'savedPosts';

  // إنشاء منشور جديد
  Future<String?> createJob(Jop job) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return 'لا يوجد مستخدم مسجل';
      }
      job.userId = user.uid;
      final docRef = _firestore.collection(_postsCollection).doc();
      await docRef.set({
        ...job.toJson(),
        'id': docRef.id,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return null;
    } catch (e) {
      return 'فشل في إنشاء المنشور: $e';
    }
  }

  // جلب كل المنشورات
  Future<List<Jop>> getAllJobs() async {
    try {
      final snapshot = await _firestore.collection(_postsCollection).get();
      return snapshot.docs
          .map((doc) => Jop.fromJson({
                ...doc.data(),
                'id': doc.id,
              }))
          .toList();
    } catch (e) {
      throw Exception('فشل في جلب المنشورات: $e');
    }
  }

  // جلب منشورات المستخدم
  Future<List<Jop>> getUserJobs(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(_postsCollection)
          .where('userId', isEqualTo: userId)
          .get();
      return snapshot.docs
          .map((doc) => Jop.fromJson({
                ...doc.data(),
                'id': doc.id,
              }))
          .toList();
    } catch (e) {
      throw Exception('فشل في جلب منشورات المستخدم: $e');
    }
  }

  // جلب منشور بمعرفه
  Future<Jop?> getJobById(String id) async {
    try {
      final doc = await _firestore.collection(_postsCollection).doc(id).get();
      if (!doc.exists) return null;
      return Jop.fromJson({
        ...doc.data()!,
        'id': doc.id,
      });
    } catch (e) {
      throw Exception('فشل في جلب المنشور: $e');
    }
  }

  // تحديث منشور
  Future<String?> updateJob(Jop job) async {
    try {
      final user = _auth.currentUser;
      if (user == null || job.userId != user.uid) {
        return 'غير مخول أو لا يوجد مستخدم مسجل';
      }
      await _firestore
          .collection(_postsCollection)
          .doc(job.id)
          .update(job.toJson());
      return null;
    } catch (e) {
      return 'فشل في تحديث المنشور: $e';
    }
  }

  // حذف منشور
  Future<String?> deleteJob(String id) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return 'لا يوجد مستخدم مسجل';
      }
      final doc = await _firestore.collection(_postsCollection).doc(id).get();
      if (!doc.exists || doc.data()!['userId'] != user.uid) {
        return 'غير مخول أو المنشور غير موجود';
      }
      await _firestore.collection(_postsCollection).doc(id).delete();
      return null;
    } catch (e) {
      return 'فشل في حذف المنشور: $e';
    }
  }

  // حفظ منشور
  Future<String?> saveJob(String jobId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return 'لا يوجد مستخدم مسجل';
      }
      await _firestore
          .collection(_savedPostsCollection)
          .doc(user.uid)
          .collection('jobs')
          .doc(jobId)
          .set({
        'jobId': jobId,
        'savedAt': FieldValue.serverTimestamp(),
      });
      return null;
    } catch (e) {
      return 'فشل في حفظ المنشور: $e';
    }
  }

  // إلغاء حفظ منشور
  Future<String?> unsaveJob(String jobId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return 'لا يوجد مستخدم مسجل';
      }
      await _firestore
          .collection(_savedPostsCollection)
          .doc(user.uid)
          .collection('jobs')
          .doc(jobId)
          .delete();
      return null;
    } catch (e) {
      return 'فشل في إلغاء حفظ المنشور: $e';
    }
  }

  // جلب المنشورات المحفوظة
  Future<List<Jop>> getSavedJobs(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(_savedPostsCollection)
          .doc(userId)
          .collection('jobs')
          .get();
      final jobIds =
          snapshot.docs.map((doc) => doc.data()['jobId'] as String).toList();
      final jobs = <Jop>[];
      for (final id in jobIds) {
        final job = await getJobById(id);
        if (job != null) {
          jobs.add(job);
        }
      }
      return jobs;
    } catch (e) {
      throw Exception('فشل في جلب المنشورات المحفوظة: $e');
    }
  }

  // إضافة تعليق وتقييم
  Future<String?> addCommentAndRating(String jobId, Comment comment) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return 'لا يوجد مستخدم مسجل';
      }
      // التحقق من عدم وجود تعليق سابق للمستخدم على هذا المنشور
      final existingComment = await _firestore
          .collection(_postsCollection)
          .doc(jobId)
          .collection('comments')
          .where('userId', isEqualTo: user.uid)
          .get();
      if (existingComment.docs.isNotEmpty) {
        return 'لقد قمت بإضافة تعليق على هذا المنشور بالفعل';
      }
      final commentRef = _firestore
          .collection(_postsCollection)
          .doc(jobId)
          .collection('comments')
          .doc();
      await commentRef.set({
        ...comment.toJson(),
        'id': commentRef.id,
        'createdAt': FieldValue.serverTimestamp(),
      });
      await updateAverageRating(jobId);
      return null;
    } catch (e) {
      return 'فشل في إضافة التعليق: $e';
    }
  }

  // تحديث متوسط التقييم
  Future<void> updateAverageRating(String jobId) async {
    try {
      final commentsSnapshot = await _firestore
          .collection(_postsCollection)
          .doc(jobId)
          .collection('comments')
          .get();
      final comments = commentsSnapshot.docs
          .map((doc) => Comment.fromJson(doc.data()))
          .toList();
      if (comments.isEmpty) {
        await _firestore.collection(_postsCollection).doc(jobId).update({
          'rating': {'rate': 0.0, 'count': 0},
        });
        return;
      }
      final totalRating = comments.fold<double>(
          0.0, (sum, comment) => sum + comment.rating.rate);
      final averageRating = totalRating / comments.length;
      final ratingCount = comments.length;
      await _firestore.collection(_postsCollection).doc(jobId).update({
        'rating': {
          'rate': averageRating,
          'count': ratingCount,
        },
      });
    } catch (e) {
      throw Exception('فشل في تحديث متوسط التقييم: $e');
    }
  }

  // حذف تعليق
  Future<String?> deleteComment(String jobId, String commentId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return 'لا يوجد مستخدم مسجل';
      }
      final commentDoc = await _firestore
          .collection(_postsCollection)
          .doc(jobId)
          .collection('comments')
          .doc(commentId)
          .get();
      if (!commentDoc.exists) {
        return 'التعليق غير موجود';
      }
      if (commentDoc.data()!['userId'] != user.uid) {
        return 'غير مخول لحذف هذا التعليق';
      }
      await _firestore
          .collection(_postsCollection)
          .doc(jobId)
          .collection('comments')
          .doc(commentId)
          .delete();
      await updateAverageRating(jobId);
      return null;
    } catch (e) {
      return 'فشل في حذف التعليق: $e';
    }
  }
}
