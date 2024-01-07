import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import 'package:qlsv/screen.dart';

import '../search/search.dart';
enum RegistrationStatus {
  CONFIRMED, AWAITING , DECLINED
}
class AddSubListStudent extends StatefulWidget{
  @override
  _AddSubListWidget createState() => _AddSubListWidget();
}

class _AddSubListWidget extends State<AddSubListStudent> {
  late ListStudentScreen listStudentScreen;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController classNameController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController studentIdController = TextEditingController();
  TextEditingController creditController = TextEditingController();
  TextEditingController termController = TextEditingController();
  TextEditingController subcontroller = TextEditingController();
  List<dynamic> Subcategoriess = [];
  List<dynamic> categories = [];
  String _selectedValue = 'Term 2/2024';
  String _selectedStringValue = 'View all';
  RegistrationStatus convertDynamicToEnum(dynamic value) {
    switch (value) {
      case 'CONFIRMED':
        return RegistrationStatus.CONFIRMED;
      case 'AWAITING':
        return RegistrationStatus.AWAITING;
      case 'DECLINED':
        return RegistrationStatus.DECLINED;
      default:
        throw ArgumentError('Invalid value: $value');
    }
  }
  RegistrationStatus _selectedStatusValue = RegistrationStatus.CONFIRMED;
  Future<void> addStudent(String term, String fullName, RegistrationStatus status, String classes, int credit) async {
    final response = await http.post(
      Uri.parse("https://traning.izisoft.io/v1/course-registrations"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'registeredCourses': Subcategoriess,
        'creditHours': credit,
        'class': classes,
        'fullName': fullName,
        'registrationStatus': status.toString().split('.').last,
        'semester':term,
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
  Future<List<Map<String, dynamic>>?> show(BuildContext context) async{
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
                              'Add more subjects',
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Color(0xFF002184)),
                            ),
                          ),
                          Container(
                            child: Column(
                              children: [
                                Text('Subject',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: Color(0xFFEDAC02)),),
                                TextField(
                                  controller: subcontroller,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(bottom: 15,left: 10),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ],
                            ),
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
                                      addToMyList(subcontroller.text);
                                      Navigator.of(context).pop();
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
                ),
              ],
            );
          },
        );
      },
    );
  }
  Future<void> addToMyList(dynamic newItem) async {
    // Kiểm tra xem newItem đã tồn tại trong categoriess chưa
    bool isExist = categories.any((element) =>
    element.toString().toLowerCase() == newItem.toString().toLowerCase());

    // Nếu không tồn tại, thêm vào danh sách
    if (!isExist) {
      categories.add(newItem);
      setState(() {
        Subcategoriess = categories;
        print(Subcategoriess);
      });
    }
  }
  Widget info() {
    List<RegistrationStatus> uniqueStatusValues = RegistrationStatus.values.toSet().toList();
    List<String> uniqueTerms = [
      'Term 3/2023',
      'Term 1/2024',
      'Term 2/2024',
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
                    child: Text('Add Subject Information',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Color(0xFF96C0FF)),),
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
                              hintText: '',
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
                                    hintText: '',
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
                                controller: studentIdController,
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
                                child: Text('School term',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: Colors.white),),
                              ),
                              Container(
                                width: 170,
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text('Quantity of credits',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: Colors.white),),
                            ),
                            Container(
                              width: 130,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),

                              child: TextField(
                                controller: creditController,
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

                          child: DropdownButton<RegistrationStatus>(
                            value: _selectedStatusValue, // Set the initial value
                            icon: Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 20),
                            iconSize: 24,
                            elevation: 20,
                            style: TextStyle(color: Colors.black, fontSize: 18),
                            padding: EdgeInsets.only(left: 10),
                            onChanged: (RegistrationStatus? newValue) {
                              // Handle when a new value is selected
                              setState(() {
                                _selectedStatusValue = newValue!;
                              });
                            },
                            items:  uniqueStatusValues.map((status) {
                              return DropdownMenuItem<RegistrationStatus>(
                                value: status,
                                child: Text(status.toString().split('.').last),
                              );
                            }).toList(),
                            underline: Container(
                              height: 0, // Set the height to 0 to remove the underline
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
                            ...Subcategoriess.map((item) {
                              bool isSelected = true; // You need to determine if the item is selected based on your criteria
                              if (isSelected) {
                                return Container(
                                  width: 88,
                                  height: 30,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.white,
                                    border: Border.all(color: Color(0xFF002184)),
                                  ),
                                  child: Text(
                                    item.toString(),
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF002184)),
                                  ),
                                );
                              } else {
                                return SizedBox.shrink(); // Widget trống cho các mục không được chọn
                              }
                            }).toList(),
                            GestureDetector(
                              onTap: () async{
                                await show(context);
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
                              addStudent(_selectedValue,fullNameController.text,_selectedStatusValue,classNameController.text,int.parse(creditController.text));
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