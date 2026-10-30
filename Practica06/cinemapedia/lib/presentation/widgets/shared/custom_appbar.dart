import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.deepPurple,
      elevation: 4,
      leading: const Padding(
        padding: EdgeInsets.only(left: 8),
        child: Icon(Icons.movie, color: Colors.white, size: 28),
      ),
      title: const Text(
        '230314 cinemapedia',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 8),
          child: Icon(Icons.search, color: Colors.white, size: 28),
        ),
      ],
    );
  }
}