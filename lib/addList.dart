import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:qlsv/screen.dart';
class AddListStudent extends StatefulWidget{
  @override
  _AddListWidget createState() => _AddListWidget();
}

class _AddListWidget extends State<AddListStudent> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController classNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController avgController = TextEditingController();
  List<Map<String, dynamic>> categories = [
    {"name": "Lịch sử Đảng", "isChecked": false},
    {"name": "Kỹ thuật lập trình", "isChecked": false},
    {"name": "Giải tích 2", "isChecked": false},
    {"name": "Vật lý dại cương", "isChecked": false},
    {"name": "Lịch sử Đảng", "isChecked": false},
  ];
  List<Map<String, dynamic>> copycategories = [];
  String _selectedValue = 'View all';
  Future<void> addStudent(String email,String fullName, String address, String classes, String phoneNumber, double avg, int dob) async {
    List<String> selectedCourses = categories
        .where((category) => category["isChecked"] == true)
        .map((category) => category["name"].toString())
        .toList();
    final response = await http.post(
      Uri.parse("https://traning.izisoft.io/v1/students"),
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
    if (response.statusCode == 201) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ListStudentScreen()),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      child:Row(
        children: [
            Text('List students',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
          Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 5),
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(50)
                        )
                    ),
                    context: context,
                    builder: (BuildContext context) {
                      return SizedBox(
                        child: info(),
                      );
                    }
                );
              },
              child: Icon(
                Icons.add_circle_outline,
                color: Color(0xFFEDAC02),
                size: 18,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 175),
            child: DropdownButton<String>(
              value: _selectedValue, // Set the initial value
              icon: Icon(Icons.keyboard_arrow_down, color: Color(0xFFEDAC02), size: 13),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Color(0xFFEDAC02), fontSize: 8),
              onChanged: (String? newValue) {
                // Handle when a new value is selected
                setState(() {
                  _selectedValue = newValue!;
                  print('View all selected: $_selectedValue');
                });
              },
              items: <String>['View all', 'Option 1', 'Option 2', 'Option 3']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              underline: Container(
                height: 0, // Set the height to 0 to remove the underline
              ),
            ),

          )
        ],
      )
    );

  }
  Widget info() => DraggableScrollableSheet(
    initialChildSize: 0.81,
    builder: (_,controller) => Container(
        decoration:const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(46),
            topRight: Radius.circular(46),
          ),
          color: Color(0xFF002184),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10,bottom: 10),
              child: Text('Add Student Information',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Color(0xFF96C0FF)),),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text('Full name',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: Colors.white),),
                  ),
                  Container(
                    width: 323,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),

                    child: TextField(
                      controller: fullNameController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 15,left: 10),
                        hintText: 'Nguyễn Thị Mai Thi',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 25,top: 10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text('Class',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: Colors.white),),
                        ),
                        Container(
                          width: 170,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),

                          child: TextField(
                            controller: classNameController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(bottom: 15,left: 10),
                              hintText: 'ST21A2A',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text('Student Id',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: Colors.white),),
                      ),
                      Container(
                        width: 130,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),

                        child: TextField(
                          controller: idController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(bottom: 15,left: 10),
                            hintText: '',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 25,top: 10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text('Email',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: Colors.white),),
                        ),
                        Container(
                          width: 170,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),

                          child: TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(bottom: 15,left: 10),
                              hintText: 'nguyenthi@gmail.com',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text('Date of Birth',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: Colors.white),),
                      ),
                      Container(
                        width: 130,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),

                        child: TextField(
                          controller: dobController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(bottom: 15,left: 10),
                            hintText: '21032003',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 25,top: 10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text('Address',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: Colors.white),),
                        ),
                        Container(
                          width: 170,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),

                          child: TextField(
                            controller: addressController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(bottom: 15,left: 10),
                              hintText:'Đà Nẵng',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text('Phone number',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: Colors.white),),
                      ),
                      Container(
                        width: 130,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),

                        child: TextField(
                          controller: phoneController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(bottom: 15,left: 10),
                            hintText:'012343243',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 10),
                    child: Text('Average mark',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: Colors.white),),
                  ),
                  Container(
                    width: 323,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),

                    child: TextField(
                      controller: avgController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 15,left: 10),
                        hintText: '3.0',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 323  ,
              margin: EdgeInsets.only(top:10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text('List subjects',style:  TextStyle(fontSize: 12,fontWeight: FontWeight.w700,color: Colors.white),),
                  ),
                  Wrap(
                    runSpacing: 8,
                    spacing: 8,
                    direction: Axis.horizontal,
                    children: [
                      ...copycategories.map((subject) {
                        if (subject["isChecked"] == true) {
                          return Container(
                            alignment: Alignment.center,
                            width: 88,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white,
                            ),
                            child: Text(
                              subject["name"],
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF002184)),
                            ),
                          );
                        } else {
                          return SizedBox.shrink();  // Widget trống cho các mục không được chọn
                        }
                      }).toList(),
                      GestureDetector(
                        onTap: () async{
                          List<Map<String, dynamic>>? updatedCategories = await show(context);
                          if (updatedCategories != null && areListsEqual(categories, updatedCategories)) {
                            print(areListsEqual(categories,updatedCategories));
                            print("Conditions met, updating state");
                            setState(() {
                              copycategories = List.from(updatedCategories.map((item) => Map<String, dynamic>.from(item)));
                            });
                          } else if (updatedCategories == null) {
                            print("Updated Categories is null, not updating state");
                          } else {
                            print("Conditions not met, not updating state");
                          }


                        },
                        child: Icon(
                          Icons.add_circle,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ],
                  )


                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10,left: 200),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color:  Color(0xFFEDAC02)
                    ),
                    child: TextButton(
                      child: Text('Save',style: TextStyle(color:Color(0xFF1F3F9F),fontWeight: FontWeight.bold),),
                      onPressed: () {
                        addStudent(emailController.text,fullNameController.text,addressController.text, classNameController.text, phoneController.text, double.parse(avgController.text), int.parse(dobController.text));
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.white,
                            width: 1
                        ),
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: TextButton(
                      child: Text('Cancel',style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold),),
                      onPressed: () {
                        Navigator.of(context).pop(null);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
    ),
  );
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
                                width: 110,
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