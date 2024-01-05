import 'package:flutter/material.dart';

import 'customtab.dart';

class TabBarCustom extends StatefulWidget {
  @override
  _TabBarWidgetState createState() => _TabBarWidgetState();
}

class _TabBarWidgetState extends State<TabBarCustom> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return  TabBar(
      tabs: [
        CustomTab(text: 'Students', index: 0, currentIndex: _currentIndex),
        CustomTab(text: 'Subject', index: 1, currentIndex: _currentIndex),
        CustomTab(text: 'Evaluation', index: 2, currentIndex: _currentIndex),
        CustomTab(text: 'Event', index: 3, currentIndex: _currentIndex),
      ],
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.transparent,
      ),
      onTap: (index) {
        DefaultTabController.of(context)!.animateTo(index);
        setState(() {
          _currentIndex = index;
        });
      },

    );
  }
}