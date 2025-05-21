import 'package:aabu_project/screens/auth/login_page.dart';
import 'package:aabu_project/screens/auth/otp_page.dart';
import 'package:aabu_project/screens/auth/create_account.dart';
import 'package:aabu_project/screens/navbar/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          final user = snapshot.data!;
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (userSnapshot.hasError) {
                return const LoginPage();
              }

              if (userSnapshot.hasData && userSnapshot.data!.exists) {
                final userData =
                    userSnapshot.data!.data() as Map<String, dynamic>;
                final isPhoneVerified = userData['isPhoneVerified'] ?? false;
                final isProfileComplete =
                    userData['isProfileComplete'] ?? false;

                if (isPhoneVerified && isProfileComplete) {
                  return Homepage();
                } else if (!isPhoneVerified) {
                  return OTPScreen(isSignUp: false, isResetPassword: false);
                } else {
                  return CreateAccount();
                }
              }

              return LoginPage();
            },
          );
        }

        return LoginPage();
      },
    );
  }
}
