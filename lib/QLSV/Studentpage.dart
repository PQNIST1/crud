import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qlsv/QLSV/addList.dart';
import 'package:qlsv/QLSV/search/search.dart';
import 'package:qlsv/QLSV/student.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class StudentPage extends StatefulWidget{
  @override
  _PageWidget createState() => _PageWidget();
}

class _PageWidget extends State<StudentPage> {
  @override
  void initState() {
    final load = Provider.of<SearchStudent>(context,listen: false);
    load.fetchStudents();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final load = Provider.of<SearchStudent>(context);
    return Material(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 25,bottom: 10),
            child: AddListStudent(),
          ),
          Expanded(child:
              ListView(
                children: [
                  for (final student in load.students.isNotEmpty ? load.students: load.students)
                    StudentInfo(
                      id: student['_id'],
                      fullName: student['fullName'] ?? '', // provide a default value if 'fullName' is null
                      classes: student['class'] ?? '', // provide a default value if 'class' is null
                      averageScore: (student['averageScore'] ?? 0.0).toDouble(), // provide a default value if 'averageScore' is null
                      dateOfBirth: student['dateOfBirth'] ?? '', // provide a default value if 'dateOfBirth' is null
                      address: student['contactInfo']['address'] ?? '', // provide a default value if 'address' is null
                      email: student['contactInfo']['email'] ?? '', // provide a default value if 'email' is null
                      phoneNumber: student['contactInfo']['phoneNumber'] ?? '', // provide a default value if 'phoneNumber' is null
                      categoriess: student['registeredCourses'],
                    ),
                ],
              ),
          ),
        ],
      ),
    );
  }
}