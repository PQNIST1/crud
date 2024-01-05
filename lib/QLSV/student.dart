import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qlsv/QLSV/screen.dart';
import 'dart:convert';
class StudentInfo extends StatefulWidget {
  final String id;
  final String address;
  final String email;
  final String phoneNumber;
  final double averageScore;
  final int dateOfBirth;
  final String classes;
  final String fullName;
  final  List<dynamic> categoriess;
  StudentInfo({
    Key? key,
    required this.id,
    required this.address,
    required this.email,
    required this.phoneNumber,
    required this.averageScore,
    required this.dateOfBirth,
    required this.classes,
    required this.fullName,
    required this.categoriess,
  }) : super(key: key);

  @override
  _StudentInfoWidgetState createState() => _StudentInfoWidgetState();
}
class _StudentInfoWidgetState extends State<StudentInfo> {
  late ListStudentScreen listStudentScreen;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController classNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController avgController = TextEditingController();
  late List<Map<String, dynamic>> subjectsWithCheck;
  @override
  void initState() {
    super.initState();
    fullNameController.text = widget.fullName;
    emailController.text = widget.email;
    classNameController.text = widget.classes;
    addressController.text = widget.address;
    phoneController.text = widget.phoneNumber;
    idController.text = widget.id;
    dobController.text = widget.dateOfBirth.toString();
    avgController.text = widget.averageScore.toString();
    listStudentScreen = ListStudentScreen();
    subjectsWithCheck = widget.categoriess.map((subject) {
      return {'name': subject, 'isChecked': true};
    }).toList();
    synchronizeCategories(categories, subjectsWithCheck);
  }
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
  Future<void> updateStudent(String email, String id, String fullName, String address, String classes, String phoneNumber, double avg, int dob) async {
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
  Future<void> removeStudent(String id) async {
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
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ListStudentScreen()),
        );
      } else if (response.statusCode == 404) {
        print('Student not found');
      } else {
        print('Failed to remove student. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error removing student: $error');
    }
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 348,
      child: Stack(
        children: [
          Positioned(
            child: Container(
              height: 60,
              width: 348,
              margin: EdgeInsets.only(left: 20, right: 20,bottom: 17),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Color(0xFFF3F4F6),
              ),
              child: Row(
                children: [
                  Container(
                    height: 60,
                    width: 270,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 1,top: 5,left: 35),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  widget.fullName,
                                  style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black)
                              ),
                              SizedBox(height: 5),
                              Text(
                                widget.email,
                                style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400,color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
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
                            child: Image.network('https://i.imgur.com/BpMXphq.png')),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: GestureDetector(
                            onTap: () {
                              showDeleteConfirmationDialog(context);
                            },
                            child: Image.network('https://i.imgur.com/676ZIhK.png')),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            child: Container(
              alignment: Alignment.center,
              width: 26,
              height: 20,
              margin: const EdgeInsets.only(left: 10,top: 15),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Color(0xFF002184),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5), // Màu của độ bóng
                    spreadRadius: 2, // Bán kính của độ bóng
                    blurRadius: 4, // Độ mờ của độ bóng
                    offset: Offset(0, 1), // Độ dịch chuyển của độ bóng (theo chiều ngang, chiều dọc)
                  ),
                ],
              ),
              child:  Text(
                "${widget.averageScore}",
                style: TextStyle(fontSize: 8,fontWeight: FontWeight.w700,color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Future<void> showDeleteConfirmationDialog(BuildContext context) async {
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
                  performDeleteAction();
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
  void performDeleteAction() {
    removeStudent(widget.id);
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
              child: Text('Edit Student Information',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Color(0xFF96C0FF)),),
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
                        hintText: widget.fullName,
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
                              hintText: widget.classes,
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
                            hintText: widget.id,
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
                              hintText: widget.email,
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
                            hintText: '${widget.dateOfBirth}',
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
                              hintText:widget.address,
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
                            hintText:widget.phoneNumber,
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
                        hintText: '${widget.averageScore}',
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
                      ...subjectsWithCheck.map((subject) {
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
                              subjectsWithCheck = List.from(updatedCategories.map((item) => Map<String, dynamic>.from(item)));
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
                        updateStudent(emailController.text,widget.id,fullNameController.text,addressController.text, classNameController.text, phoneController.text, double.parse(avgController.text), int.parse(dobController.text));
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