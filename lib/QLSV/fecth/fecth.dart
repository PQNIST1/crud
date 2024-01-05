import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../screen.dart';

class FecthData {
  List<Map<String, dynamic>> categories = [
    {"name": "Lịch sử Đảng", "isChecked": false},
    {"name": "Kỹ thuật lập trình", "isChecked": false},
    {"name": "Giải tích 2", "isChecked": false},
    {"name": "Vật lý dại cương", "isChecked": false},
    {"name": "Lịch sử Đảng", "isChecked": false},
  ];
  void synchronizeCategories(List<Map<String, dynamic>> categories, List<Map<String, dynamic>> userSelectedSubjects) {
    for (var userSubject in userSelectedSubjects) {
      var categoryIndex = categories.indexWhere((category) => category["name"] == userSubject["name"]);

      if (categoryIndex == -1) {
        // Subject not found in categories, add it
        categories.add({"name": userSubject["name"], "isChecked": true});
      } else {
        // Subject found in categories, update isChecked
        categories[categoryIndex]["isChecked"] = true;
      }
    }
  }
  Future<void> updateStudent(BuildContext context, String email, String id, String fullName, String address, String classes, String phoneNumber, double avg, int dob) async {
    List<String> selectedCourses = categories
        .where((category) => category["isChecked"] == true)
        .map((category) => category["name"].toString())
        .toList();
    final response = await http.put(
      Uri.parse("https://traning.izisoft.io/v1/students/$id"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'contactInfo': {
          if (email.isNotEmpty) 'email': email,
          if (address.isNotEmpty) 'address': address,
          if (phoneNumber.isNotEmpty) 'phoneNumber': phoneNumber,
        },
        'registeredCourses': selectedCourses,
        'averageScore': avg,
        'dateOfBirth': dob,
        'class': classes,
        'fullName': fullName,
      }),
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    print(jsonDecode(response.body));
    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ListStudentScreen()),
      );
    }
  }
  Future<void> removeStudent(BuildContext context, String id) async {
    final url = Uri.parse('https://traning.izisoft.io/v1/students/$id');
    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          // Include any additional headers you may need for authentication or other purposes
        },
      );

      if (response.statusCode == 200) {
        print('Student removed successfully');
      } else if (response.statusCode == 404) {
        print('Student not found');
      } else {
        print('Failed to remove student. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error removing student: $error');
    }
  }
  Future<void> showDeleteConfirmationDialog(BuildContext context, String id) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Are you sure to delete this student?',style: TextStyle(
              color: Color(0xFF002184),fontSize: 15
          ),),
          actions: <Widget>[
            Container(
              width: 89,
              height: 27,
              margin: EdgeInsets.only(right: 20,bottom: 5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xFF002184),
              ),
              child: TextButton(
                child: Text('Delete',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                onPressed: () {
                  performDeleteAction(id, context);
                  Navigator.of(context).pop();
                },
              ),
            ),
            Container(
              width: 89,
              height: 27,
              margin: EdgeInsets.only(right: 20,bottom: 5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  border: Border.all(
                      color: Color(0xFF002184),
                      width: 2
                  )
              ),
              child: TextButton(
                child: Text('Cancel',style: TextStyle(color: Color(0xFF002184),fontWeight: FontWeight.bold),),
                onPressed: () {
                  Navigator.of(context).pop(); // Đóng Dialog khi nhấn Cancel
                },
              ),
            ),

          ],
        );
      },
    );
  }
  void performDeleteAction(String id, BuildContext context) async {
    await removeStudent(context, id);
  }
  Future<List<Map<String, dynamic>>?> show(BuildContext context) async{
    List<Map<String, dynamic>> originalCategories = List.from(categories.map((item) => Map<String, dynamic>.from(item)));;
    return await showDialog<List<Map<String, dynamic>>>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Stack(
              children: [
                Positioned(
                  top: 100.0,
                  child: AlertDialog(
                    shape: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(32),
                        bottomLeft: Radius.circular(32),
                      ),
                      borderSide: BorderSide.none,
                    ),
                    content: Container(
                      width: 250,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              'Choose subjects',
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Color(0xFF002184)),
                            ),
                          ),
                          Wrap(
                            runSpacing: 8,
                            spacing: 15,
                            direction: Axis.horizontal,
                            children: categories.map((subject) {
                              return Container(
                                width: 115,
                                height: 30,
                                child: Row(
                                  children: [
                                    Theme(
                                      data: ThemeData(
                                        unselectedWidgetColor: Colors.orangeAccent,
                                      ),
                                      child: Checkbox(
                                        checkColor: Colors.orangeAccent,
                                        value: subject["isChecked"],
                                        activeColor: Colors.orangeAccent,
                                        onChanged: (newBool) {
                                          setState(() {
                                            subject["isChecked"] = newBool;
                                          });
                                        },
                                      ),
                                    ),
                                    Text(
                                      subject["name"],
                                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.orangeAccent),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10, left: 80),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 18,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Color(0xFFEDAC02)),
                                  child: TextButton(
                                    child: Text(
                                      'Save',
                                      style: TextStyle(color: Color(0xFF002184), fontWeight: FontWeight.bold, fontSize: 6),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop(categories.toList());
                                    },
                                  ),
                                ),
                                Container(
                                  width: 48,
                                  height: 18,
                                  margin: EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey, width: 2),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: TextButton(
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(color: Color(0xFF002184), fontWeight: FontWeight.bold, fontSize: 6),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        categories = List.from(originalCategories);
                                        print(categories);
                                      });
                                      Navigator.of(context).pop(); // Đóng dialog và trả giá trị false
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
  bool areListsEqual(List a, List b) {
    if (a.length != b.length) {
      return false;
    }

    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) {
        return false;
      }
    }

    return true;
  }
}