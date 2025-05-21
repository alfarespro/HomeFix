// Core Flutter and Dart imports
import 'package:aabu_project/screens/posts/Browse.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // لإعداد التوجيه العمودي

// Third-party packages
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// Firebase configuration
import 'firebase_options.dart';

// Project-specific screens and widgets
import 'package:aabu_project/screens/auth/login_page.dart';
import 'package:aabu_project/screens/auth/signup_page.dart';
import 'package:aabu_project/screens/auth/otp_page.dart';
import 'package:aabu_project/screens/auth/create_account.dart';
import 'package:aabu_project/screens/reset_pass/forgot_password_phone.dart';
import 'package:aabu_project/screens/reset_pass/reset_pass_after_otp.dart';
import 'package:aabu_project/screens/reset_pass/reset_pass_with_old_pass.dart';
import 'package:aabu_project/screens/navbar/home_page.dart';
import 'package:aabu_project/screens/navigation_test.dart';
import 'package:aabu_project/screens/posts/MyPost.dart';
import 'package:aabu_project/screens/posts/MyPosts.dart';
import 'package:aabu_project/screens/posts/NotMyPost.dart';
import 'package:aabu_project/screens/posts/SavedPosts.dart';
import 'package:aabu_project/screens/create_post/create_post_step2.dart';
import 'package:aabu_project/screens/edit_account.dart';
import 'package:aabu_project/screens/Reporting.dart';
import 'package:aabu_project/library/media_viewer.dart';
import 'package:aabu_project/services/wrappers/auth_wrapper.dart';

// Project-specific providers and themes
import 'package:aabu_project/library/data_provider.dart';
import 'package:aabu_project/library/themes/app_bar_theme.dart';
import 'package:aabu_project/library/themes/button_theme.dart';
import 'package:aabu_project/library/themes/text_field_theme.dart';
import 'package:aabu_project/library/themes/text_theme.dart'; // Note: Appears unused, verify if needed

void main() async {
  // Ensure Flutter bindings are initialized before Firebase
  WidgetsFlutterBinding.ensureInitialized();

  //  منع التطبيق من التدوير – السماح فقط بالوضع الطولي
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Firebase with platform-specific options
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Start the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Rubik',
          appBarTheme: getAppBarTheme(),
          elevatedButtonTheme: getElevatedButtonTheme(),
          inputDecorationTheme: getTextFieldTheme(),
        ),
        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          );
        },
        routes: {
          '/LoginPage': (context) => const LoginPage(),
          '/SignupPage': (context) => const SignupPage(),
          '/OTPScreen': (context) {
            final arguments = ModalRoute.of(context)!.settings.arguments
                as Map<String, dynamic>?;
            return OTPScreen(
              isSignUp: arguments?['isSignUp'] ?? true,
              isResetPassword: arguments?['isResetPassword'] ?? false,
            );
          },
          '/create_account': (context) => const CreateAccount(),
          '/verify_code_page': (context) => const VerifyCodePage(),
          '/reset_pass_after_otp': (context) => const ResetPasswordPage(),
          '/reset_pass_with_old_pass': (context) =>
              const ResetPassWithOldPass(),
          '/home_page': (context) => const Homepage(),
          '/navigation_test': (context) => NavigationTest(),
          '/SavedPosts': (context) => SavedPosts(),
          '/MyPosts': (context) => MyPosts(),
          '/MyPost': (context) => MyPost(),
          '/NotMyPost': (context) => NotMyPost(),
          '/Browse': (context) => BrowseJobs(),
          '/EditAccount': (context) => const EditAccount(),
          '/Reporting': (context) => ImagePickerExample(),
          '/media_viewer': (context) {
            final args = ModalRoute.of(context)!.settings.arguments
                as Map<String, dynamic>?;
            return MediaViewer(images: args?['images'] ?? []);
          },
          // '/create_post_step2': (context) => const CreatePostStep2(),
        },
        home: const AuthWrapper(),
      ),
    );
  }
}
