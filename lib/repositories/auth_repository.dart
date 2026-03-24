import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  Future<UserCredential> signup({
    required String email,
    required String password,
    required String name,
  }) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // حفظ الاسم في SharedPreferences أولاً
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', name);

    // ثم حدّث displayName في Firebase (إذا أمكن)
    try {
      await userCredential.user?.updateDisplayName(name);
    } catch (e) {
      // ignore if update fails
    }

    return userCredential;
  }

  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = userCredential.user;
    if (user != null) {
      final prefs = await SharedPreferences.getInstance();

      // حاول قراءة اسم اليوزر من SharedPreferences أولاً
      String? storedUsername = prefs.getString('username');

      // إذا مش موجود، استخرده من displayName أو البريد
      if (storedUsername == null || storedUsername.isEmpty) {
        final rawName = (user.displayName ?? '').trim();
        final fallbackFromEmail = (user.email ?? '').split('@').first;
        storedUsername = rawName.isNotEmpty ? rawName : fallbackFromEmail;
      }

      // حفظ الاسم في SharedPreferences
      if (storedUsername.isNotEmpty) {
        await prefs.setString('username', storedUsername);
      }
    }

    return userCredential;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await _auth.signOut();
  }

  Future<String?> getStoredUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  Future<void> setUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
  }
}
