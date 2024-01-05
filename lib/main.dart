import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qlsv/QLSV/screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'QLSV/search/search.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 1;

  // Các trang bạn muốn hiển thị ở mỗi tab
  final List<Widget> _pages = [
    HomePage(),
    ListStudentScreen(),
    SettingsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => SearchStudent(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: _pages[_currentIndex], // Hiển thị trang hiện tại
            bottomNavigationBar: CustomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (int index) {
                // Gọi khi một tab được chọn
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        )
    );
  }
}

class CustomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  CustomNavigationBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      color: Color(0xFF002184), // Màu nền của Navigation Bar
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CustomNavItem(
            icon: Icons.home_filled,
            label: 'Home',
            isSelected: currentIndex == 0,
            onTap: () => onTap(0),
          ),
          CustomNavItem(
            icon: Icons.archive,
            label: 'Settings',
            isSelected: currentIndex == 1,
            onTap: () => onTap(1),
          ),
          CustomNavItem(
            icon: Icons.settings,
            label: 'Settings',
            isSelected: currentIndex == 2,
            onTap: () => onTap(2),
          ),
          CustomNavItem(
            icon: Icons.person,
            label: 'Profile',
            isSelected: currentIndex == 3,
            onTap: () => onTap(3),
          ),
        ],
      ),
    );
  }
}

class CustomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  CustomNavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? Color(0xFFEDAC02) : Colors.grey,
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child:  Text('Home Page')
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Profile Page'),
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Settings Page'),
    );
  }
}
