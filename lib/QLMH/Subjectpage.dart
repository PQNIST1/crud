import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qlsv/QLMH/studentSubject.dart';
import 'package:qlsv/QLSV/addList.dart';
import 'package:qlsv/QLSV/student.dart';


import '../search/search.dart';
import 'addSubList.dart';
class StudentSubPage extends StatefulWidget{
  @override
  _SubPageWidget createState() => _SubPageWidget();
}

class _SubPageWidget extends State<StudentSubPage> {
  @override
  void initState() {
    final load = Provider.of<SearchStudent>(context,listen: false);
    load.fetchStudentsSub();
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
            child: AddSubListStudent(),
          ),
          Expanded(child:
              ListView(
                children: [
                  for (final student in load.studentsSub.isNotEmpty ? load.studentsSub: load.studentsSub)
                    StudentSubInfo(
                      id: student['_id'],
                      fullName: student['fullName'] ?? '', // provide a default value if 'fullName' is null
                      classes: student['class'] ?? '', // provide a default value if 'class' is null
                      credits: student['creditHours'] ?? 0, // provide a default value if 'averageScore' is null
                      studentId: student['studentId'] ?? '', // provide a default value if 'dateOfBirth' is null
                      status: student['registrationStatus'] ?? '', // provide a default value if 'address' is null
                      term: student['semester'] ?? '', // provide a default value if 'email' is null
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