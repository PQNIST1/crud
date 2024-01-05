import 'package:flutter/material.dart';
import 'package:qlsv/QLSV/addList.dart';
import 'package:qlsv/appBar/tabBar.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Function(String) onSearch;

  CustomAppBar({required this.onSearch});
  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(500);
}

class _CustomAppBarState extends State<CustomAppBar> {
  TextEditingController searchController = TextEditingController();
  void performSearch() {
    if (searchController.text.isNotEmpty) {
      // Gọi hàm tìm kiếm và truyền nội dung tìm kiếm
      widget.onSearch(searchController.text);
    } else {
      // Nếu ô tìm kiếm rỗng, hiển thị toàn bộ danh sách
      widget.onSearch('');
    }
  }
  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: widget.preferredSize,
      child: Stack(
        children: [
          const Positioned(
            top: 30,
            left: 75,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Student',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: Color(0xFFEDAC02),
                  ),
                ),
                Text(
                  'Management',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: Color(0xFF002184),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            child: Container(
              margin: EdgeInsets.only(top: 80, left: 25),
              child: Row(
                children: [
                  Container(
                    height: 35,
                    width: 285,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Color(0xFFF3F4F6),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(),
                            child: TextFormField(
                              controller: searchController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color(0xFFF3F4F6),
                                hintText: 'Enter keyword to find out...',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(left: 50,top: 5,bottom: 15),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            performSearch();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Icon(Icons.search, color: Color(0xFFEDAC02)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: const Color(0xFFF3F4F6),
                    ),
                    child: Image.network('https://i.imgur.com/DDrOiZt.png'),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            child: Image.network(
              'https://i.imgur.com/nuAppwk.png',
              width: 76,
              height: 121,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 120),
            child: TabBarCustom()
            ),
        ],
      ),
    );
  }
}
