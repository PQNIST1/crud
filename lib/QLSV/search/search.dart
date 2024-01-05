import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../screen.dart';

class SearchStudent with ChangeNotifier {
  List<Map<String, dynamic>> students = [];


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
  void searchStudents(String query) async {
    await fetchStudents(); // Sử dụng await để đảm bảo dữ liệu đã được tải xong
    // Sử dụng phương thức where để lọc danh sách sinh viên theo fullName
    students = students.where((student) {
      return student['fullName'].toLowerCase().contains(query.toLowerCase());
    }).toList();
    notifyListeners(); // Thông báo sự thay đổi đến các người nghe (listeners)
  }
}
