import 'package:flutter/material.dart';
import 'package:aabu_project/library/custom/CustomWidgets.dart';
import 'package:aabu_project/library/GV.dart';
import 'package:aabu_project/screens/posts/MyPosts.dart';
import 'package:aabu_project/screens/posts/SavedPosts.dart';

class CustomPostsPage extends StatefulWidget {
  const CustomPostsPage({super.key});

  @override
  State<CustomPostsPage> createState() => _CustomPostsPageState();
}

class _CustomPostsPageState extends State<CustomPostsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 2, vsync: this, initialIndex: 0); // Start with SavedPosts
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightgray,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header
          Column(
            children: [
              Container(
                color: black,
                height: 90,
                width: double.infinity,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text('المنشورات', style: BWL),
                ),
              ),
              Container(
                color: black,
                height: 60,
                width: double.infinity,
                child: TabBar(
                  controller: _tabController,
                  labelStyle: CS,
                  unselectedLabelStyle: GM,
                  indicatorColor: Colors.transparent,
                  tabs: [
                    SizedBox(
                      width: 180,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text('المنشورات المحفوظة'),
                      ),
                    ),
                    SizedBox(
                      width: 180,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text('منشوراتي'),
                      ),
                    ),
                  ],
                ),
              ),
              Container(color: cyan, height: 6, width: double.infinity),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                SavedPosts(),
                MyPosts(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
