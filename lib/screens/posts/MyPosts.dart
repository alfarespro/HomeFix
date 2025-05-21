// lib/MyPosts.dart
import 'package:flutter/material.dart';
import 'package:aabu_project/library/custom/CustomWidgets.dart';
import 'package:aabu_project/services/api/job_api.dart';
import 'package:aabu_project/library/classes/Classes.dart';

class MyPosts extends StatelessWidget {
  MyPosts({super.key});
  final JobApi _jobApi = JobApi();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Note: Removed FloatingActionButton that navigated to '/CreateJob'
      body: FutureBuilder<Map<String, dynamic>>(
        future: _jobApi.getUserJobs(),
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
                child: Text('لا توجد منشورات بعد',
                    style: TextStyle(fontSize: 18)));
          }
          return ListView.builder(
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              return JopCard(J: jobs[index], MyPost: true);
            },
          );
        },
      ),
    );
  }
}
