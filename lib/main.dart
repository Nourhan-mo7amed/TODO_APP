import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/firebase_options.dart';
import 'package:todo_app/screens/SplashScreen.dart';
import 'package:todo_app/screens/home/HomeScreen.dart';
import 'package:todo_app/screens/auth/LoginScreen.dart';
import 'package:todo_app/screens/auth/SignupScreen.dart';
import 'package:todo_app/cubits/tasks/task_cubit.dart';
import 'package:todo_app/repositories/task_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
    debugPrint("Please verify Firebase app config for the current platform.");
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskCubit(repository: TaskRepository()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ToDo App',
        locale: WidgetsBinding.instance.window.locale,
        builder: (context, child) {
          final isArabic = Localizations.localeOf(context).languageCode == 'ar';

          return Theme(
            data: ThemeData(
              fontFamily: isArabic ? 'Almarai' : 'WinkyRough',
            ),
            child: child!,
          );
        },
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          '/home': (context) => HomeScreen(),
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignupScreen(),
        },
      ),
    );
  }
}
