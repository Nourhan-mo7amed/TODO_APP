import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubits/auth/auth_cubit.dart';

class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool isSearching;
  final TextEditingController searchController;
  final void Function(String) onSearchChanged;
  final VoidCallback onToggleSearch;
  final String username;

  const HomeAppBar({
    required this.isSearching,
    required this.searchController,
    required this.onSearchChanged,
    required this.onToggleSearch,
    required this.username,
  });

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _HomeAppBarState extends State<HomeAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      centerTitle: false,
      title: widget.isSearching
          ? TextField(
              controller: widget.searchController,
              onChanged: widget.onSearchChanged,
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
                      widget.username.isEmpty ? 'User' : widget.username,
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
            widget.isSearching ? Icons.close : Icons.search,
            color: Colors.black,
          ),
          onPressed: widget.onToggleSearch,
        ),
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.black),
          onPressed: () {
            context.read<AuthCubit>().logout();
          },
        ),
      ],
    );
  }
}
