import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('menu Page'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'menu Page',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/Homepage");
              },
              child: const Text('Go to Homepage'),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}