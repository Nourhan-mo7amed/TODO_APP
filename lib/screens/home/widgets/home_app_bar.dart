import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../welcome.dart';

PreferredSizeWidget buildAppBar({
  required bool isSearching,
  required TextEditingController searchController,
  required void Function(String) onSearchChanged,
  required VoidCallback onToggleSearch,
}) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(kToolbarHeight),
    child: FutureBuilder<String>(
      future: _getUsername(),
      builder: (context, snapshot) {
        final username = snapshot.data ?? '';

        return AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: false,
          title: isSearching
              ? TextField(
                  controller: searchController,
                  onChanged: onSearchChanged,
                  autofocus: true,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  decoration: const InputDecoration(
                    hintText: 'Search tasks...',
                    hintStyle: TextStyle(color: Colors.black26),
                    border: InputBorder.none,
                  ),
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('👋', style: TextStyle(fontSize: 28)),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Welcome',
                          style: TextStyle(
                            fontSize: 25,
                            color: Color(0xFF5A189A),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          username,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
          actions: [
            IconButton(
              icon: Icon(
                isSearching ? Icons.close : Icons.search,
                color: Colors.black,
              ),
              onPressed: onToggleSearch,
            ),
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.black),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove('username');

                // إعادة التوجيه لشاشة Welcome
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        );
      },
    ),
  );
}

Future<String> _getUsername() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('username') ?? '';
}
