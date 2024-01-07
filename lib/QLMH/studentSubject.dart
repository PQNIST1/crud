import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:qlsv/screen.dart';
import 'dart:convert';

import '../search/search.dart';
enum RegistrationStatus {
  CONFIRMED, AWAITING , DECLINED
}
class StudentSubInfo extends StatefulWidget {

  final String id;
  final String studentId;
  final String status;
  final int credits;
  final String classes;
  final String fullName;
  final String term;
  final  List<dynamic> categoriess;
  StudentSubInfo({
    Key? key,
    required this.id,
    required this.status,
    required this.credits,
    required this.classes,
    required this.fullName,
    required this.categoriess,
    required this.studentId,
    required this.term,
  }) : super(key: key);

  @override
  _StudentSubInfoWidgetState createState() => _StudentSubInfoWidgetState();
}
class _StudentSubInfoWidgetState extends State<StudentSubInfo> {

  late ListStudentScreen listStudentScreen;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController classNameController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController studentIdController = TextEditingController();
  TextEditingController creditController = TextEditingController();
  TextEditingController termController = TextEditingController();
  List<dynamic> Subcategoriess = [];
  late TextEditingController subcontroller;
  String _selectedValue = '';
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
// or any default value
  RegistrationStatus _selectedStatusValue = RegistrationStatus.CONFIRMED;
  

  @override
  void initState() {
    super.initState();
    fullNameController.text = widget.fullName;
    classNameController.text = widget.classes;
    idController.text = widget.id;
    studentIdController.text = widget.studentId;
    creditController.text = widget.credits.toString();
    listStudentScreen = ListStudentScreen();
    subcontroller = TextEditingController();
    final load = Provider.of<SearchStudent>(context,listen: false);
    load.fetchStudentsSub();
    _selectedStatusValue = convertDynamicToEnum(widget.status);
    Subcategoriess = widget.categoriess;
    _selectedValue = widget.term;
    print(Subcategoriess);
    print(_selectedStatusValue);
  }
  Future<void> updateStudent(String term, String id, String fullName, RegistrationStatus status, String classes, String studentId, int credit) async {
    final response = await http.put(
      Uri.parse("https://traning.izisoft.io/v1/course-registrations/$id"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'registeredCourses': Subcategoriess,
        'creditHours': credit,
        'studentId': id,
        'class': classes,
        'fullName': fullName,
        'registrationStatus': status.toString().split('.').last,
        'semester':term,
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
    bool isExist = widget.categoriess.any((element) =>
    element.toString().toLowerCase() == newItem.toString().toLowerCase());

    // Nếu không tồn tại, thêm vào danh sách
    if (!isExist) {
      widget.categoriess.add(newItem);
      setState(() {
        Subcategoriess = widget.categoriess;
        print(Subcategoriess);
      });
    }
  }
  @override
  void dispose(){
    subcontroller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final load = Provider.of<SearchStudent>(context);
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
                                widget.classes,
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
                                    return StatefulBuilder(
                                      builder: (BuildContext context, StateSetter setState) {
                                        return SizedBox(
                                          child: info(),
                                        );
                                      }
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
                              load.showDeleteConfirmationDialog(context,widget.id);
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
                "${widget.credits}",
                style: TextStyle(fontSize: 8,fontWeight: FontWeight.w700,color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget info() {
    final load = Provider.of<SearchStudent>(context);
    List<RegistrationStatus> uniqueStatusValues = RegistrationStatus.values.toSet().toList();
    List<String> uniqueTerms = [
      'Term 3/2023',
      'Term 1/2024',
      'Term 2/2024',
      widget.term
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
                                  controller: studentIdController,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(bottom: 15,left: 10),
                                    hintText: widget.studentId,
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
                                    hintText: '${widget.credits}',
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
                                updateStudent(_selectedValue,widget.id,fullNameController.text,_selectedStatusValue,classNameController.text,studentIdController.text,int.parse(creditController.text));
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