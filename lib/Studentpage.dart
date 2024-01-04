import 'package:flutter/material.dart';
import 'package:qlsv/addList.dart';
import 'package:qlsv/student.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class StudentPage extends StatefulWidget{
  @override
  _PageWidget createState() => _PageWidget();
}

class _PageWidget extends State<StudentPage> {
  void initState() {
    super.initState();
    fetchStudents();
  }
  List<Map<String, dynamic>> students = [];
  Future<void> fetchStudents() async {
    final response = await http.get(Uri.parse('https://traning.izisoft.io/v1/students'));

    if (response.statusCode == 200) {
      // If the server returns an OK response, parse the JSON
      final List<dynamic> studentList = json.decode(response.body);
      // Update the state with the fetched data
      setState(() {
        students = List<Map<String, dynamic>>.from(studentList);
      });
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      throw Exception('Failed to load products');
    }
  }
  @override
  Widget build(BuildContext context) {
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
            for (final student in students)
                  StudentInfo(
                        id: student['_id'],
                        fullName: student['fullName'] ?? '', // provide a default value if 'fullName' is null
                        classes: student['class'] ?? '', // provide a default value if 'class' is null
                        averageScore: student['averageScore'] ?? 0, // provide a default value if 'averageScore' is null
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