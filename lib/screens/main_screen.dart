import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../constants/app_constants.dart';
import '../screens/home_screen.dart';
import '../screens/tasks_screen.dart';
import '../screens/habits_screen.dart';
import '../screens/notes_screen.dart';
import '../screens/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const TasksScreen(),
    const HabitsScreen(),
    const NotesScreen(),
    const ProfileScreen(),
  ];

  final List<BottomNavigationBarItem> _navItems = [
    const BottomNavigationBarItem(
      icon: FaIcon(FontAwesomeIcons.house, size: 20),
      activeIcon: FaIcon(FontAwesomeIcons.house, size: 20),
      label: AppStrings.home,
    ),
    const BottomNavigationBarItem(
      icon: FaIcon(FontAwesomeIcons.listCheck, size: 20),
      activeIcon: FaIcon(FontAwesomeIcons.listCheck, size: 20),
      label: AppStrings.tasks,
    ),
    const BottomNavigationBarItem(
      icon: FaIcon(FontAwesomeIcons.bullseye, size: 20),
      activeIcon: FaIcon(FontAwesomeIcons.bullseye, size: 20),
      label: AppStrings.habits,
    ),
    const BottomNavigationBarItem(
      icon: FaIcon(FontAwesomeIcons.noteSticky, size: 20),
      activeIcon: FaIcon(FontAwesomeIcons.noteSticky, size: 20),
      label: AppStrings.notes,
    ),
    const BottomNavigationBarItem(
      icon: FaIcon(FontAwesomeIcons.user, size: 20),
      activeIcon: FaIcon(FontAwesomeIcons.user, size: 20),
      label: AppStrings.profile,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: _navItems,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          elevation: 0,
        ),
      ),
    );
  }
}
