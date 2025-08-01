import 'package:flutter/material.dart';
import 'package:todo_app/data/Sqldb.dart';
import 'package:todo_app/screens/SplashScreen.dart';
import 'package:todo_app/screens/home/HomeScreen.dart';
import 'package:todo_app/screens/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = Sqldb();
  //await db.deleteDatabaseFile();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        '/welcome': (context) => WelcomeScreen(),
      },
    );
  }
}
