import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:qlsv/screen.dart';
class AddMarkListStudent extends StatefulWidget{
  @override
  _AddMarkListWidget createState() => _AddMarkListWidget();
}

class _AddMarkListWidget extends State<AddMarkListStudent> {
  late ListStudentScreen listStudentScreen;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController classNameController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController scoreController = TextEditingController();
  List<Map<String, dynamic>> examScoresData = [];
  String _selectedValue = 'Good';
  String _selectedStringValue = 'View all';
  Future<void> addStudent(String note,String fullName, String classes, String rank) async {
    final response = await http.post(
      Uri.parse("https://traning.izisoft.io/v1/student-evaluations"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'examScores': examScoresData,
        'academicRank': rank,
        'class': classes,
        'fullName': fullName,
        'studyBehaviorNote': note,
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
  void addSubjectScore() {
    showDialog(
      context: context,
      builder: (context) {
        return Stack(
          children:[
            AlertDialog(
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(32),
                  bottomLeft: Radius.circular(32),
                ),
                borderSide: BorderSide.none,
              ),
              content: SingleChildScrollView(
                child: Container(
                  width: 250,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              'Add mark',
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Color(0xFF002184)),
                            ),
                          ),
                        ],
                      ),
                      Text('Subject',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: Color(0xFFEDAC02)),),
                      TextField(
                        controller: subjectController,
                        decoration: InputDecoration(
                          fillColor: Colors.grey,
                          border: InputBorder.none,
                        ),
                      ),
                      Text('Score',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: Color(0xFFEDAC02)),),
                      TextField(
                        controller: scoreController,
                        decoration: InputDecoration(
                          fillColor: Colors.grey,
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.number,
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
                                  if (subjectController.text.isNotEmpty && int.parse(scoreController.text) > 0) {
                                    Map<String, dynamic> newScore = {
                                      'subject': subjectController.text,
                                      'score': int.parse(scoreController.text),
                                    };
                                    setState(() {
                                      examScoresData.add(newScore);
                                      subjectController.clear();
                                      scoreController.clear();
                                      print(examScoresData);
                                    });
                                    Navigator.pop(context);
                                  }
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
            )
          ] ,
        );
      },
    );
  }
  void editSubjectScore(Map<String, dynamic>  index) {
    showDialog(
      context: context,
      builder: (context) {
        return  Stack(
          children:[
            AlertDialog(
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(32),
                  bottomLeft: Radius.circular(32),
                ),
                borderSide: BorderSide.none,
              ),
              content: SingleChildScrollView(
                child: Container(
                  width: 250,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              'Edit mark',
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Color(0xFF002184)),
                            ),
                          ),
                        ],
                      ),
                      Text('Subject',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: Color(0xFFEDAC02)),),
                      TextField(
                        controller: subjectController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: index['subject']
                        ),
                      ),
                      Text('Score',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: Color(0xFFEDAC02)),),
                      TextField(
                        controller: scoreController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: index['score'].toString()
                        ),
                        keyboardType: TextInputType.number,
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
                                  if (subjectController.text.isNotEmpty && int.parse(scoreController.text) > 0) {
                                    setState(() {
                                      index['score'] = subjectController.text ;
                                      index['subject']= int.parse(scoreController.text);
                                      subjectController.clear();
                                      scoreController.clear();
                                    });
                                    Navigator.pop(context);
                                  }
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
            )
          ] ,
        );
      },
    );
  }
  void deleteSubjectScore(Map<String, dynamic> subject) {
    setState(() {
      examScoresData.remove(subject);
    });
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
              value: _selectedStringValue, // Set the initial value
              icon: Icon(Icons.keyboard_arrow_down, color: Color(0xFFEDAC02), size: 13),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Color(0xFFEDAC02), fontSize: 8),
              onChanged: (String? newValue) {
                // Handle when a new value is selected
                setState(() {
                  _selectedStringValue = newValue!;
                  print('View all selected: $_selectedStringValue');
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
  Widget info() {
    List<String> uniqueTerms = [
      'Bad',
      'Excellent ',
      'Good',
    ].toSet().toList();

    // Tạo danh sách DropdownMenuItem từ danh sách không có mục trùng lặp
    List<DropdownMenuItem<String>> dropdownItems = uniqueTerms
        .map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.81,
      builder: (_,controller) => Container(
          padding: EdgeInsets.only(top: 5),
          decoration:const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(46),
              topRight: Radius.circular(46),
            ),
            color: Color(0xFF002184),
          ),
          child: ListView(
            children:[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10,bottom: 10),
                    child: Text('Edit Subject Information',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Color(0xFF96C0FF)),),
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
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(bottom: 15,left: 10),
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
                    margin: EdgeInsets.only(left: 25,top: 10,bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10,bottom: 10,right: 10),
                              child: Text('Mark',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: Colors.white),),
                            ),
                            GestureDetector(
                              onTap: () async{
                                addSubjectScore();
                              },
                              child: Icon(
                                Icons.add_circle,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        for (var score in examScoresData)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10,left: 20),
                            child: Row(
                              children: [
                                Container(
                                  width: 200,
                                  child: Row(
                                    children: [
                                      Text('${score['subject']}: ',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: Color(0xFFEDAC02)),),
                                      Text('${score['score']}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: Colors.white),),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10,right: 15),
                                  child: GestureDetector(
                                    onTap: (){
                                      editSubjectScore(score);
                                    },
                                    child: Image.network('https://i.imgur.com/bEHCNKz.png'),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    deleteSubjectScore(score);
                                  },
                                  child: Image.network('https://i.imgur.com/lvemcLB.png'),
                                )
                              ],
                            ),
                          )
                      ],
                    ) ,
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10, top: 10),
                          child: Text('Registering status',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: Colors.white),),
                        ),
                        Container(
                          width: 323,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),

                          child: DropdownButton<String>(
                            value: _selectedValue, // Set the initial value
                            icon: Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 20),
                            iconSize: 24,
                            elevation: 20,
                            style: TextStyle(color: Colors.black, fontSize: 18),
                            padding: EdgeInsets.only(left: 10),
                            onChanged: (String? newValue) {
                              // Handle when a new value is selected
                              setState(() {
                                _selectedValue = newValue!;
                                print('View all selected: $_selectedValue');
                              });
                            },
                            items: dropdownItems,
                            underline: Container(
                              height: 0, // Set the height to 0 to remove the underline
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10,top: 10),
                          child: Text('Note',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: Colors.white),),
                        ),
                        Container(
                          width: 323,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),

                          child: TextField(
                            maxLines: 5,
                            controller: noteController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(bottom: 15,left: 10,top: 5),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
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
                              addStudent(noteController.text,fullNameController.text,classNameController.text,_selectedValue);
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
              ),
            ],
          )
      ),
    );

  }

}