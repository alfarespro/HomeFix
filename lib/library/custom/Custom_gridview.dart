import 'package:aabu_project/library/const_var.dart';
import 'package:flutter/material.dart';

class Custom_Gridview extends StatelessWidget {
  const Custom_Gridview(this.photo, this.text, this.size_photo, this.size_text,
      {super.key});

  final String photo;
  final String text;
  final double size_photo;
  final double size_text;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: my_Color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: size_photo, // Fixed height for image
            width: double.infinity,
            child: Image.asset(
              photo,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.error,
                color: Colors.white,
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: size_text,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
