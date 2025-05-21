import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Helper method to standardize phone number format
  String _standardizePhoneNumber(String phoneNumber) {
    String cleanedNumber = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    if (cleanedNumber.startsWith('07') && cleanedNumber.length == 10) {
      return '+962${cleanedNumber.substring(1)}';
    } else if (cleanedNumber.startsWith('+9627') &&
        cleanedNumber.length == 12) {
      return cleanedNumber;
    }
    return cleanedNumber;
  }

  // Send OTP
  Future<void> sendOTP(
    String phoneNumber,
    Function(String, int?) onCodeSent,
    Function(String) onError,
    Function onVerificationCompleted,
  ) async {
    final standardizedPhoneNumber = _standardizePhoneNumber(phoneNumber);
    await _auth.verifyPhoneNumber(
      phoneNumber: standardizedPhoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        onVerificationCompleted();
      },
      verificationFailed: (FirebaseAuthException e) {
        onError(e.message ?? 'فشل في التحقق من رقم الهاتف');
      },
      codeSent: onCodeSent,
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  // Check if phone number is registered
  Future<bool> isPhoneNumberRegistered(String phoneNumber) async {
    final standardizedPhoneNumber = _standardizePhoneNumber(phoneNumber);
    final query = await _firestore
        .collection('users')
        .where('phoneNumber', isEqualTo: standardizedPhoneNumber)
        .get();
    return query.docs.isNotEmpty;
  }

  // Complete sign up
  Future<void> completeSignUp({
    required String phoneNumber,
    required String firstName,
    required String lastName,
    required String password,
    required String city,
    required String area,
    String? profileImageUrl,
    required Function onSuccess,
    required Function(String) onError,
  }) async {
    try {
      final standardizedPhoneNumber = _standardizePhoneNumber(phoneNumber);
      final email = '$standardizedPhoneNumber@example.com';
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user != null) {
        if (await isPhoneNumberRegistered(standardizedPhoneNumber)) {
          await user.delete();
          await _auth.signOut();
          onError('رقم الهاتف مسجل بالفعل');
          return;
        }
        await _firestore.collection('users').doc(user.uid).set({
          'firstName': firstName,
          'lastName': lastName,
          'phoneNumber': standardizedPhoneNumber,
          'email': email,
          'password': password,
          'isPhoneVerified': true,
          'isProfileComplete': true,
          'city': city,
          'area': area,
          'profileImageUrl': profileImageUrl,
          'createdAt': FieldValue.serverTimestamp(),
        });
        onSuccess();
      }
    } on FirebaseAuthException catch (e) {
      onError(e.message ?? 'فشل في إنشاء الحساب');
    } catch (e) {
      onError('حدث خطأ: $e');
    }
  }

  // Update user profile
  Future<void> updateUserProfile({
    required String firstName,
    required String lastName,
    required String city,
    required String area,
    String? profileImageUrl,
    required Function onSuccess,
    required Function(String) onError,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        onError('لا يوجد مستخدم مسجل الدخول');
        return;
      }

      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) {
        onError('بيانات المستخدم غير موجودة');
        return;
      }

      await _firestore.collection('users').doc(user.uid).update({
        'firstName': firstName,
        'lastName': lastName,
        'city': city,
        'area': area,
        if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      onSuccess();
    } catch (e) {
      onError('حدث خطأ أثناء تحديث الملف: $e');
    }
  }

  // Verify OTP
  Future<void> verifyOTP({
    required String verificationId,
    required String smsCode,
    required Function onSuccess,
    required Function(String) onError,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      await _auth.signInWithCredential(credential);
      onSuccess();
    } on FirebaseAuthException catch (e) {
      onError(e.message ?? 'فشل في التحقق من OTP');
    } catch (e) {
      onError('حدث خطأ غير متوقع: $e');
    }
  }

  // Sign in
  Future<void> signIn({
    required String phoneNumber,
    required String password,
    required Function onSuccess,
    required Function(String) onError,
  }) async {
    try {
      final standardizedPhoneNumber = _standardizePhoneNumber(phoneNumber);
      final email = '$standardizedPhoneNumber@example.com';
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      final user = _auth.currentUser;
      if (user != null) {
        final userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (!userDoc.exists) {
          onError('المستخدم غير موجود');
          return;
        }
        final isVerified = userDoc.data()?['isPhoneVerified'] ?? false;
        final isProfileComplete = userDoc.data()?['isProfileComplete'] ?? false;
        if (isVerified && isProfileComplete) {
          onSuccess();
        } else {
          onError('يرجى إكمال التحقق من رقم الهاتف أو الملف الشخصي');
        }
      } else {
        onError('فشل في تسجيل الدخول');
      }
    } on FirebaseAuthException catch (e) {
      onError(e.message ?? 'فشل في تسجيل الدخول');
    } catch (e) {
      onError('حدث خطأ: $e');
    }
  }

  // Reset password
  Future<void> resetPassword({
    required String? phoneNumber,
    required String newPassword,
    required Function onSuccess,
    required Function(String) onError,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);
        final standardizedPhoneNumber = phoneNumber != null
            ? _standardizePhoneNumber(phoneNumber)
            : user.email?.split('@')[0] ?? '';
        await _firestore
            .collection('users')
            .where('phoneNumber', isEqualTo: standardizedPhoneNumber)
            .get()
            .then((snapshot) {
          if (snapshot.docs.isNotEmpty) {
            snapshot.docs.first.reference.update({'password': newPassword});
          }
        });
        onSuccess();
      } else {
        onError('لا يوجد مستخدم مسجل الدخول');
      }
    } on FirebaseAuthException catch (e) {
      onError(e.message ?? 'فشل في تحديث كلمة المرور');
    } catch (e) {
      onError('حدث خطأ: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Fetch user data
  Future<Map<String, dynamic>?> getUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      return userDoc.data();
    }
    return null;
  }
}
