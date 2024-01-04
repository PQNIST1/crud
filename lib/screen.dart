import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qlsv/Studentpage.dart';
import 'package:qlsv/appBar.dart';


class ListStudentScreen extends StatefulWidget {
  @override
  _ListStudentWidgetState createState() => _ListStudentWidgetState();
}

class _ListStudentWidgetState extends State<ListStudentScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Material(
        child: Scaffold(
          appBar: CustomAppBar(),
          body: TabBarView(
            children: [
             StudentPage(),
              Container(
                color: Colors.blue,
              ),
              Container(
                color: Colors.yellow,
              ),
              Container(
                color: Colors.greenAccent,
              ),
            ],
          )
        ),
      ),
    );
  }

}
