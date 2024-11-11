// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../../data_classes/subordinate_classes/item_class.dart';
// import '../../pages/homepage/pages/subordinate_pages/item_model.dart';
//
// class HistoryItemCard extends StatefulWidget {
//   final ItemData historyItem;
//
//   const HistoryItemCard({
//     Key? key,
//     required this.historyItem,
//   }) : super(key: key);
//
//   @override
//   State<HistoryItemCard> createState() => _HistoryItemCardState();
// }
//
// class _HistoryItemCardState extends State<HistoryItemCard> {
//   @override
//   Widget build(BuildContext context) {
//     String firstLetter =
//     widget.historyItem.itemName.substring(0, 1).toUpperCase();
//
//     return Container(
//       decoration: BoxDecoration(
//         color: Color(0xFFADF2C6),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               _buildCircularContainer(firstLetter),
//               SizedBox(width: 8), // Add spacing between circular container and text
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     widget.historyItem.itemName,
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w400,
//                       color: Color(0xFF1D1B20),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           Expanded(child: Container()), // Occupies remaining space
//           Padding(
//             padding: const EdgeInsets.only(right: 24.0),
//             child: Text(
//               '${widget.historyItem.status ? "Returned" : "Due"} on ${DateFormat('dd MMMM yyyy').format(widget.historyItem.date)}',
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w500,
//                 color: Color(0xFF49454F),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCircularContainer(String firstLetter) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.5),
//       child: Container(
//         width: 40,
//         height: 40,
//         decoration: BoxDecoration(
//           color: Colors.grey.withOpacity(0.27),
//           shape: BoxShape.circle,
//         ),
//         child: Center(
//           child: Text(
//             firstLetter,
//             style: TextStyle(
//               fontFamily: 'Roboto',
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//               color: Color(0xFF21005D),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
