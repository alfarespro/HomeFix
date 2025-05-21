import 'package:aabu_project/library/custom/Custom_BlackContainer.dart';
import 'package:aabu_project/library/custom/Custom_gridview.dart';
import 'package:flutter/material.dart';
import 'package:aabu_project/screens/create_post/create_post_step1.dart';

class AddPostPage extends StatelessWidget {
  const AddPostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const BlackContainer(
            styleNumber: 1,
          ), // this is the black container with text
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 1.0,
                children: [
                  _buildGridItem(
                      context,
                      "assets/Images/House searching-bro (1).png",
                      "الصيانة والإصلاحات المنزلية",
                      100,
                      15),
                  _buildGridItem(context, "assets/Images/men.png",
                      "البناء والتشطيبات", 100, 15),
                  _buildGridItem(context, "assets/Images/Car.png",
                      "السيارات والمركبات", 100, 15),
                  _buildGridItem(context, "assets/Images/Binary.png",
                      "الإلكترونيات والتقنية", 100, 15),
                  _buildGridItem(context, "assets/Images/sofie.png",
                      "الأثاث والمفروشات", 100, 15),
                  _buildGridItem(context, "assets/Images/Hand sewing-bro.png",
                      "الحرف اليدوية والفنية", 100, 15),
                  _buildGridItem(context, "assets/Images/clean.png",
                      "التنظيف والخدمات المنزلية", 100, 15),
                  _buildGridItem(context, "assets/Images/tree.png",
                      "الزراعة والمساحات الخضراء", 100, 15),
                  _buildGridItem(
                      context, "assets/Images/Questions.png", "أخرى", 100, 15),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, String imagePath, String title,
      double imageSize, double fontSize) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CustomAssestImageAndVideo(category: title),
          ),
        );
      },
      child: Custom_Gridview(imagePath, title, imageSize, fontSize),
    );
  }
}
