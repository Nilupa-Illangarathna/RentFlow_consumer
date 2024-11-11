import 'package:flutter/material.dart';

import '../../global/responsiveness.dart';

class BorrowedDueRow extends StatefulWidget {
  final Map<String, int> data;
  final void Function(String) onButtonPressed;

  BorrowedDueRow({required this.data, required this.onButtonPressed});

  @override
  _BorrowedDueRowState createState() => _BorrowedDueRowState();
}

class _BorrowedDueRowState extends State<BorrowedDueRow> {
  String _selectedButton = ''; // Keep track of the selected button

  @override
  Widget build(BuildContext context) {
    double containerWidth = ((MediaQuery.of(context).size.width - 10 - 2 * 28) / 2);
    double containerHeight = containerWidth;

    return Container(
      height: (containerHeight + 12), // Considering padding
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              _handleButtonTap('borrowed');
            },
            child: _buildContainer(
              color: Color(0xFFADF2C6),
              label: 'Borrowed',
              count: widget.data['borrowed'] ?? 0,
              width: containerWidth,
              height: containerHeight,
              isSelected: _selectedButton == 'borrowed',
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              _handleButtonTap('due');
            },
            child: _buildContainer(
              color: Color(0xFFFFDAD6),
              label: 'Due',
              count: widget.data['due'] ?? 0,
              width: containerWidth,
              height: containerHeight,
              isSelected: _selectedButton == 'due',
            ),
          ),
        ],
      ),
    );
  }

  void _handleButtonTap(String buttonLabel) {
    setState(() {
      _selectedButton = buttonLabel; // Update selected button
    });
    widget.onButtonPressed(buttonLabel); // Call the callback function
  }

  Widget _buildContainer({
    required Color color,
    required String label,
    required int count,
    required double width,
    required double height,
    required bool isSelected, // New parameter to indicate selection state
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: isSelected // Apply elevation based on selection state
            ? []
            : [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            spreadRadius: 0,
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: label == 'Borrowed'? Color(0xFF322F35): Color(0xFFBA1A1A),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4),
                bottomLeft: Radius.circular(4),
                topRight: Radius.circular(4),
                bottomRight: Radius.circular(4),
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xFFF5EFF7),
              ),
            ),
          ),
          Text(
            count.toString(),
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 57,
              fontWeight: FontWeight.w400,
              color: label == 'Borrowed' ? Colors.black : Color(0xFFBA1A1A),
            ),
          ),
        ],
      ),
    );
  }
}
