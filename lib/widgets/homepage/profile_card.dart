import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  final IconData icon;
  final String name;
  final bool status;

  const ProfileWidget({
    Key? key,
    required this.icon,
    required this.name,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      child: Row(
        children: [
          Icon(
            icon,
            size: 24,
            color: Colors.black,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.5,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Status: ${status ? 'Active' : 'Offline'}",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.25,
                    color: Color(0xFF49454F),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: status ? Color(0xFF286A48) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

// void main() {
//   runApp(MaterialApp(
//     home: Scaffold(
//       appBar: AppBar(
//         title: Text('Custom Card Demo'),
//       ),
//       body: Center(
//         child: CustomCard(
//           icon: Icons.person,
//           name: 'John Doe',
//           status: true,
//           active: true,
//         ),
//       ),
//     ),
//   ));
// }
