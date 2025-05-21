// ignore: file_names
import 'package:aabu_project/library/custom/Custom_BottomNavigationBar.dart';
import 'package:aabu_project/library/custom/Custom_gridview.dart';
import 'package:aabu_project/library/const_var.dart' show my_Color;
import 'package:flutter/material.dart';
import 'package:aabu_project/library/classes/Classes.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Custom_Bottomnavigationbar(); // Custom bottom navigation bar to navigate between pages
  }
}

class HomepageContent extends StatelessWidget {
  const HomepageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.topRight,
          child: Image.asset(
            'assets/logo.png',
            width: 200,
            height: 200,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 40),
          child: Container(
            alignment: Alignment.topRight,
            child: const Text(
              "أهلاً وسهلاً!",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 40),
          child: Container(
            alignment: Alignment.topRight,
            child: const Text(
              "تفضل باختيار الخدمة التي تحتاجها",
              style: TextStyle(color: Colors.grey, fontSize: 20),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 1.0,
              physics:
                  const NeverScrollableScrollPhysics(), // Disable scrolling, to be adjusted
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/Browse',
                      // Pass the Filter object to Browse screen
                      arguments: Filter(
                        category: 'الصيانة والإصلاحات المنزلية',
                        SubCategory: 'كل المهن',
                        city: 'كل المحافظات',
                        town: 'كل المناطق',
                      ),
                    );
                  },
                  child: Custom_Gridview(
                      "assets/Images/House searching-bro (1).png",
                      "الصيانة والإصلاحات المنزلية",
                      60,
                      12),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/Browse',
                      // Pass the Filter object to Browse screen
                      arguments: Filter(
                        category: "البناء والتشطيبات (ديكور)",
                        SubCategory: 'كل المهن',
                        city: 'كل المحافظات',
                        town: 'كل المناطق',
                      ),
                    );
                  },
                  child: Custom_Gridview(
                      "assets/Images/men.png", "البناء والتشطيبات", 60, 12),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/Browse',
                      // Pass the Filter object to Browse screen
                      arguments: Filter(
                        category: "السيارات والمركبات",
                        SubCategory: 'كل المهن',
                        city: 'كل المحافظات',
                        town: 'كل المناطق',
                      ),
                    );
                  },
                  child: Custom_Gridview(
                      "assets/Images/Car.png", "السيارات والمركبات", 60, 12),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/Browse',
                      // Pass the Filter object to Browse screen
                      arguments: Filter(
                        category: "الإلكترونيات والتقنية",
                        SubCategory: 'كل المهن',
                        city: 'كل المحافظات',
                        town: 'كل المناطق',
                      ),
                    );
                  },
                  child: Custom_Gridview("assets/Images/Binary.png",
                      "الإلكترونيات والتقنية", 60, 12),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/Browse',
                      // Pass the Filter object to Browse screen
                      arguments: Filter(
                        category: "الأثاث والمفروشات",
                        SubCategory: 'كل المهن',
                        city: 'كل المحافظات',
                        town: 'كل المناطق',
                      ),
                    );
                  },
                  child: Custom_Gridview(
                      "assets/Images/sofie.png", "الأثاث والمفروشات", 60, 12),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/Browse',
                      // Pass the Filter object to Browse screen
                      arguments: Filter(
                        category: "الحرف اليدوية والفنية",
                        SubCategory: 'كل المهن',
                        city: 'كل المحافظات',
                        town: 'كل المناطق',
                      ),
                    );
                  },
                  child: Custom_Gridview("assets/Images/Hand sewing-bro.png",
                      "الحرف اليدوية والفنية", 60, 12),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/Browse',
                      // Pass the Filter object to Browse screen
                      arguments: Filter(
                        category: "التنظيف والخدمات المنزلية",
                        SubCategory: 'كل المهن',
                        city: 'كل المحافظات',
                        town: 'كل المناطق',
                      ),
                    );
                  },
                  child: Custom_Gridview("assets/Images/clean.png",
                      "التنظيف والخدمات المنزلية", 60, 12),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/Browse',
                      // Pass the Filter object to Browse screen
                      arguments: Filter(
                        category: "الزراعة والمساحات الخضراء",
                        SubCategory: 'كل المهن',
                        city: 'كل المحافظات',
                        town: 'كل المناطق',
                      ),
                    );
                  },
                  child: Custom_Gridview("assets/Images/tree.png",
                      "الزراعة والمساحات الخضراء", 60, 12),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/Browse',
                      // Pass the Filter object to Browse screen
                      arguments: Filter(
                        category: "أخرى",
                        SubCategory: 'كل المهن',
                        city: 'كل المحافظات',
                        town: 'كل المناطق',
                      ),
                    );
                  },
                  child: Custom_Gridview(
                      "assets/Images/Questions.png", "أخرى", 60, 12),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
