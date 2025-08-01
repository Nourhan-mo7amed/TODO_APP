import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home/HomeScreen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final TextEditingController _controller = TextEditingController();

  void _saveNameAndContinue() async {
    final name = _controller.text.trim();
    if (name.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', name);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E8FF),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/todo3.png',
                  width: 140,
                  height: 140,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 16),
                const Text(
                  "Welcome to Your ToDo App!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5A189A),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Let’s get to know you 👇",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: "Enter your name",
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _saveNameAndContinue,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text("Continue"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5A189A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
