import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchStudent with ChangeNotifier {
   TextEditingController subcontroller = TextEditingController();
  List<Map<String, dynamic>> students = [];
   List<Map<String, dynamic>> studentsSub = [];
   List<Map<String, dynamic>> studentsMark = [];


   Future<void> fetchStudents() async {
    final response = await http.get(Uri.parse('https://traning.izisoft.io/v1/students'));

    if (response.statusCode == 200) {
      // Nếu máy chủ trả về phản hồi OK, phân tích cú pháp JSON
      final List<dynamic> studentList = json.decode(response.body);
      // Cập nhật trạng thái với dữ liệu được lấy
      students = List<Map<String, dynamic>>.from(studentList);
      notifyListeners(); // Thông báo sự thay đổi đến các người nghe (listeners)
    } else {
      // Nếu máy chủ không trả về phản hồi 200 OK,
      // ném một ngoại lệ.
      throw Exception('Failed to load students');
    }
  }
  Future<void> fetchStudentsSub() async {
    final response = await http.get(Uri.parse('https://traning.izisoft.io/v1/course-registrations'));
    if (response.statusCode == 200) {
      // Nếu máy chủ trả về phản hồi OK, phân tích cú pháp JSON
      final List<dynamic> studentList = json.decode(response.body);
      // Cập nhật trạng thái với dữ liệu được lấy
      studentsSub = List<Map<String, dynamic>>.from(studentList);
      notifyListeners(); // Thông báo sự thay đổi đến các người nghe (listeners)
    } else {
      // Nếu máy chủ không trả về phản hồi 200 OK,
      // ném một ngoại lệ.
      throw Exception('Failed to load students');
    }
  }
   Future<void> fetchStudentsMark() async {
     final response = await http.get(Uri.parse('https://traning.izisoft.io/v1/student-evaluations'));

     if (response.statusCode == 200) {
       // Nếu máy chủ trả về phản hồi OK, phân tích cú pháp JSON
       final List<dynamic> studentList = json.decode(response.body);
       // Cập nhật trạng thái với dữ liệu được lấy
       studentsMark = List<Map<String, dynamic>>.from(studentList);
       notifyListeners(); // Thông báo sự thay đổi đến các người nghe (listeners)
     } else {
       // Nếu máy chủ không trả về phản hồi 200 OK,
       // ném một ngoại lệ.
       throw Exception('Failed to load students');
     }
   }
  void searchStudents(String query) async {
    await fetchStudents(); // Sử dụng await để đảm bảo dữ liệu đã được tải xong
    await fetchStudentsSub();
    await fetchStudentsMark();
    // Sử dụng phương thức where để lọc danh sách sinh viên theo fullName
    students = students.where((student) {
      return student['fullName'].toLowerCase().contains(query.toLowerCase());
    }).toList();
    studentsSub = studentsSub.where((student) {
      return student['fullName'].toLowerCase().contains(query.toLowerCase());
    }).toList();
    studentsMark = studentsMark.where((student) {
      return student['fullName'].toLowerCase().contains(query.toLowerCase());
    }).toList();
    notifyListeners(); // Thông báo sự thay đổi đến các người nghe (listeners)
  }
  Future<void> showDeleteConfirmationDialog(BuildContext context, String id) async{
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
                  performDeleteAction(id);
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
  Future<void> removeStudent(String id) async {
    final url = Uri.parse('https://traning.izisoft.io/v1/course-registrations/$id');
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
        await fetchStudentsSub();
        notifyListeners();
      } else if (response.statusCode == 404) {
        print('Student not found');
      } else {
        print('Failed to remove student. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error removing student: $error');
    }
  }
  Future<void> removeMarkStudent(String id) async {
     final url = Uri.parse('https://traning.izisoft.io/v1/student-evaluations/$id');
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
         await fetchStudentsMark();
         notifyListeners();
       } else if (response.statusCode == 404) {
         print('Student not found');
       } else {
         print('Failed to remove student. Status code: ${response.statusCode}');
       }
     } catch (error) {
       print('Error removing student: $error');
     }
   }

  void performDeleteAction(String id) {
    removeStudent(id);
    removeMarkStudent(id);
  }

}
