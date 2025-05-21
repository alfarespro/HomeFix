import 'package:aabu_project/screens/navbar/home_page.dart';
import 'package:aabu_project/screens/navbar/create_post_page.dart';
import 'package:aabu_project/library/const_var.dart';
import 'package:aabu_project/screens/navbar/menu_page.dart';
import 'package:aabu_project/screens/navbar/profile_page.dart';
import 'package:aabu_project/screens/navigation_test.dart';
import 'package:aabu_project/screens/posts/SavedPosts.dart';
import 'package:aabu_project/library/custom/CustomPostsPage.dart';
import 'package:flutter/material.dart';
//this is the custom -bottom- navigation bar to navigate between the pages

class Custom_Bottomnavigationbar extends StatefulWidget {
  const Custom_Bottomnavigationbar({super.key});

  @override
  _CustomBottomnavigationbarState createState() =>
      _CustomBottomnavigationbarState();
}

class _CustomBottomnavigationbarState
    extends State<Custom_Bottomnavigationbar> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomepageContent(),
    AddPostPage(),
    CustomPostsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 82,
        child: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          currentIndex: _currentIndex,
          backgroundColor: Colors.white,
          selectedItemColor: my_Color,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                shadows: [Shadow(color: Colors.grey, blurRadius: 2.0)],
              ),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box),
              label: 'إضافة منشور',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.format_list_bulleted), label: 'المنشورات'),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'حسابي',
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
      body: _pages[_currentIndex],
    );
  }
}
