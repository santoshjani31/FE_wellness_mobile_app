import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'browse_page.dart';
import 'home_page.dart';
import 'journal_page.dart';
import 'user_provider.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    String? userId = Provider.of<UserProvider>(context).userId; // Change to String?

    if (userId == null) {
      // Handle the case where userId is null
      return Scaffold(
        body: Center(
          child: Text('User not logged in.'),
        ),
      );
    }

    final List<Widget> _pages = [
      MyHomePage(userId: userId), // Pass userId directly
      ExploreScreen(),
      JournalScreen(),
    ];

    void _onItemTapped(int index) {
      if (_selectedIndex != index) {
        setState(() {
          _selectedIndex = index;
        });
      }
    }

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Browse'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Journal'),
        ],
      ),
    );
  }
}
