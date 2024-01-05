import 'package:flutter/material.dart';
class CustomTab extends StatelessWidget {
  final String text;
  final int index;
  final int currentIndex;

  const CustomTab({
    required this.text,
    required this.index,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Container(
        alignment: Alignment.center,
        width: 75,
        height: 25,
        padding: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: index == currentIndex ? Color(0xFF002184) : Colors.transparent,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: _getTabTextColor(),
            fontWeight: FontWeight.bold,
            fontSize: 13
          ),
        ),
      ),
    );
  }

  Color _getTabTextColor() {
    return index == currentIndex ? Colors.white : Colors.black;
  }
}