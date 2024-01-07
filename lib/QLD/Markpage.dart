import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qlsv/QLMH/studentSubject.dart';



import '../search/search.dart';
import 'addMarkList.dart';
import 'studentMark.dart';
class StudentMarkPage extends StatefulWidget{
  @override
  _MarkPageWidget createState() => _MarkPageWidget();
}

class _MarkPageWidget extends State<StudentMarkPage> {
  @override
  void initState() {
    final load = Provider.of<SearchStudent>(context,listen: false);
    load.fetchStudentsMark();
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
            child: AddMarkListStudent(),
          ),
          Expanded(child:
              ListView(
                children: [
                  for (final student in load.studentsMark.isNotEmpty ? load.studentsMark: load.studentsMark)
                    StudentMarkInfo(
                      id: student['_id'],
                      fullName: student['fullName'] ?? '', // provide a default value if 'fullName' is null
                      classes: student['class'] ?? '', // provide a default value if 'class' is null
                      rank: student['academicRank'] ?? '', // provide a default value if 'averageScore' is null
                      note: student['studyBehaviorNote'] ?? '', // provide a default value if 'dateOfBirth' is null
                      categoriess: student['examScores'] ?? [],
                    ),
                ],
              ),
          ),
        ],
      ),
    );
  }
}