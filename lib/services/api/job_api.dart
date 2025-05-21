// lib/services/api/job_api.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'api_response.dart';
import '../../library/classes/Classes.dart';
import 'job_service.dart';
import '../auth/auth_service.dart';

class JobApi {
  final JobService _jobService = JobService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthService _authService = AuthService();

  // GET /posts - جلب كل المنشورات
  Future<Map<String, dynamic>> getAllJobs() async {
    try {
      final jobs = await _jobService.getAllJobs();
      return ApiResponse.success(jobs).toJson();
    } catch (e) {
      return ApiResponse.error(e.toString()).toJson();
    }
  }

  // GET /posts/user - جلب منشورات المستخدم
  Future<Map<String, dynamic>> getUserJobs() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return ApiResponse.error('لا يوجد مستخدم مسجل').toJson();
      }
      final jobs = await _jobService.getUserJobs(user.uid);
      return ApiResponse.success(jobs).toJson();
    } catch (e) {
      return ApiResponse.error(e.toString()).toJson();
    }
  }

  // GET /posts/:id - جلب منشور بمعرفه
  Future<Map<String, dynamic>> getJobById(String id) async {
    try {
      final job = await _jobService.getJobById(id);
      if (job == null) {
        return ApiResponse.error('المنشور غير موجود').toJson();
      }
      return ApiResponse.success(job).toJson();
    } catch (e) {
      return ApiResponse.error(e.toString()).toJson();
    }
  }

  // POST /posts - إنشاء منشور جديد
  Future<Map<String, dynamic>> createJob(Map<String, dynamic> jobData) async {
    try {
      final job = Jop.fromJson(jobData);
      final error = await _jobService.createJob(job);
      if (error != null) {
        return ApiResponse.error(error).toJson();
      }
      return ApiResponse.success({'message': 'تم إنشاء المنشور بنجاح'})
          .toJson();
    } catch (e) {
      return ApiResponse.error(e.toString()).toJson();
    }
  }

  // PUT /posts/:id - تحديث منشور
  Future<Map<String, dynamic>> updateJob(
      String id, Map<String, dynamic> jobData) async {
    try {
      final job = Jop.fromJson({...jobData, 'id': id});
      final error = await _jobService.updateJob(job);
      if (error != null) {
        return ApiResponse.error(error).toJson();
      }
      return ApiResponse.success({'message': 'تم تحديث المنشور بنجاح'})
          .toJson();
    } catch (e) {
      return ApiResponse.error(e.toString()).toJson();
    }
  }

  // DELETE /posts/:id - حذف منشور
  Future<Map<String, dynamic>> deleteJob(String id) async {
    try {
      final error = await _jobService.deleteJob(id);
      if (error != null) {
        return ApiResponse.error(error).toJson();
      }
      return ApiResponse.success({'message': 'تم حذف المنشور بنجاح'}).toJson();
    } catch (e) {
      return ApiResponse.error(e.toString()).toJson();
    }
  }

  // POST /posts/:id/save - حفظ منشور
  Future<Map<String, dynamic>> saveJob(String jobId) async {
    try {
      final error = await _jobService.saveJob(jobId);
      if (error != null) {
        return ApiResponse.error(error).toJson();
      }
      return ApiResponse.success({'message': 'تم حفظ المنشور بنجاح'}).toJson();
    } catch (e) {
      return ApiResponse.error(e.toString()).toJson();
    }
  }

  // DELETE /posts/:id/save - إلغاء حفظ منشور
  Future<Map<String, dynamic>> unsaveJob(String jobId) async {
    try {
      final error = await _jobService.unsaveJob(jobId);
      if (error != null) {
        return ApiResponse.error(error).toJson();
      }
      return ApiResponse.success({'message': 'تم إلغاء حفظ المنشور بنجاح'})
          .toJson();
    } catch (e) {
      return ApiResponse.error(e.toString()).toJson();
    }
  }

  // GET /posts/saved - جلب المنشورات المحفوظة
  Future<Map<String, dynamic>> getSavedJobs() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return ApiResponse.error('لا يوجد مستخدم مسجل').toJson();
      }
      final jobs = await _jobService.getSavedJobs(user.uid);
      return ApiResponse.success(jobs).toJson();
    } catch (e) {
      return ApiResponse.error(e.toString()).toJson();
    }
  }

  // POST /posts/:id/comment - إضافة تعليق وتقييم
  Future<Map<String, dynamic>> addCommentAndRating(
      String jobId, Map<String, dynamic> commentData) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return ApiResponse.error('لا يوجد مستخدم مسجل').toJson();
      }
      final userData = await _authService.getUserData();
      if (userData == null) {
        return ApiResponse.error('فشل في جلب بيانات المستخدم').toJson();
      }
      final comment = Comment(
        userId: user.uid,
        username: '${userData['firstName']} ${userData['lastName']}',
        rating: Rating.fromJson(commentData['rating']),
        comment: commentData['comment'],
        userImage: userData['profileImageUrl'] ?? '',
      );
      final error = await _jobService.addCommentAndRating(jobId, comment);
      if (error != null) {
        return ApiResponse.error(error).toJson();
      }
      return ApiResponse.success({'message': 'تم إضافة التعليق بنجاح'})
          .toJson();
    } catch (e) {
      return ApiResponse.error(e.toString()).toJson();
    }
  }

  // DELETE /posts/:id/comments/:commentId - حذف تعليق
  Future<Map<String, dynamic>> deleteComment(
      String jobId, String commentId) async {
    try {
      final error = await _jobService.deleteComment(jobId, commentId);
      if (error != null) {
        return ApiResponse.error(error).toJson();
      }
      return ApiResponse.success({'message': 'تم حذف التعليق بنجاح'}).toJson();
    } catch (e) {
      return ApiResponse.error(e.toString()).toJson();
    }
  }
}
