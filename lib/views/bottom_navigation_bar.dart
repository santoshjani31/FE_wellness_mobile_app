import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.blueAccent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              },
            ),
            IconButton(
              icon: const Icon(Icons.list, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, '/browse');
              },
            ),
            IconButton(
              icon: const Icon(Icons.book, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, '/journal');
              },
            ),
          ],
        ),
      ),
    );
  }
}