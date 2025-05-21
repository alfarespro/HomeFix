//widget to show the black container with text

// ignore: camel_case_types
import 'package:aabu_project/library/const_var.dart';
import 'package:flutter/material.dart';

class BlackContainer extends StatelessWidget {
  final int styleNumber;

  const BlackContainer({super.key, required this.styleNumber});

  @override
  Widget build(BuildContext context) {
    switch (styleNumber) {
      case 2:
        return _buildStyle2();
      case 3:
        return _buildStyle3();
      case 1:
      default:
        return _buildStyle1();
    }
  }

  // الشكل 1: الشكل الأصلي (محاذاة يمين، خلفية سوداء)
  Widget _buildStyle1() {
    return Container(
      color: const Color(0xFF14181B),
      width: double.infinity,
      height: 200,
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.only(left: 18.0),
                child: Text(
                  "انشر مهنتك الان!            ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Text(
                "حتى تزيد فرصتك في العمل",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "اختر المجال الذي ترى مهنتك فيه",
                style: TextStyle(color: Colors.grey, fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // الشكل 2: محاذاة وسط، خلفية متدرجة
  Widget _buildStyle2() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF000000), my_Color.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(height: 20),
              const Text(
                "عزز حضورك المهني!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const Text(
                "شارك مهاراتك الآن",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                "اختر تخصصك لتبرز",
                style: TextStyle(color: Colors.grey[300], fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // الشكل 3: محاذاة يسار، حدود، نصوص مختلفة
  Widget _buildStyle3() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: my_Color, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                "ابدأ رحلتك المهنية!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "انضم إلى مجتمعنا",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "سجل مهنتك اليوم",
                style: TextStyle(color: Colors.grey[400], fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
