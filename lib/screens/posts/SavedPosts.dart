// lib/SavedPosts.dart
import 'package:flutter/material.dart';
import 'package:aabu_project/library/custom/CustomWidgets.dart';
import 'package:aabu_project/services/api/job_api.dart';
import 'package:aabu_project/library/classes/Classes.dart';

class SavedPosts extends StatelessWidget {
  SavedPosts({super.key});
  final JobApi _jobApi = JobApi();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _jobApi.getSavedJobs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError ||
            !snapshot.hasData ||
            !snapshot.data!['success']) {
          return Center(
              child:
                  Text('خطأ: ${snapshot.data?['error'] ?? 'خطأ غير معروف'}'));
        }
        final jobs = (snapshot.data!['data'] as List<dynamic>)
            .map((e) => Jop.fromJson(e as Map<String, dynamic>))
            .toList();
        if (jobs.isEmpty) {
          return Center(
              child: Text('لا توجد منشورات محفوظة',
                  style: TextStyle(fontSize: 18)));
        }
        return ListView.builder(
          itemCount: jobs.length,
          itemBuilder: (context, index) {
            return JopCard(J: jobs[index], saved: true);
          },
        );
      },
    );
  }
}
