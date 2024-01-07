import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qlsv/QLD/Markpage.dart';
import 'package:qlsv/QLMH/Subjectpage.dart';
import 'package:qlsv/QLSV/Studentpage.dart';
import 'package:qlsv/appBar/appBar.dart';
import 'package:provider/provider.dart';

import 'search/search.dart';

class ListStudentScreen extends StatefulWidget {
  @override
  _ListStudentWidgetState createState() => _ListStudentWidgetState();
}

class _ListStudentWidgetState extends State<ListStudentScreen> {
  void searchStudents(String searchKeyword) {
    final load = Provider.of<SearchStudent>(context,listen: false);
    load.searchStudents(searchKeyword);
  }
  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Material(
        child: Scaffold(
          appBar: CustomAppBar(onSearch: searchStudents,),
          body: TabBarView(
            children: [
             StudentPage(),
             StudentSubPage(),
              StudentMarkPage(),
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
