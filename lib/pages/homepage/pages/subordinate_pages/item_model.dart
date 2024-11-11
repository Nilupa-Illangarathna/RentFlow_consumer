import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../data_classes/subordinate_classes/item_class.dart';
import '../../../../global/responsiveness.dart';
import '../../../../widgets/common/elevated_button.dart';

class ItemDetailsModal extends StatefulWidget {
  final ItemData itemData;
  final Function onCancelPressed;

  const ItemDetailsModal({
    Key? key,
    required this.itemData,
    required this.onCancelPressed,
  }) : super(key: key);

  @override
  State<ItemDetailsModal> createState() => _ItemDetailsModalState();
}

class _ItemDetailsModalState extends State<ItemDetailsModal> {
  bool isPop = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 430,
      width: MediaQuery.of(context).size.width,
      // padding: EdgeInsets.only(bottom: 444),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        color: Colors.white,
      ),
      child: WillowPadding(
        padding: 32,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 8.0, vertical: 16,),
              child: Container(
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.only(
                  //   // topLeft: Radius.circular(100),
                  // ),
                  color: Color(0xFF717972),
                ),
              ),
            ),

            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width - (32 * 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.itemData.itemName} - Details',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w400,
                          // color: Colors.indigo,
                        ),
                      ),

                      WillowVerticalGap(height: 8,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Borrowed on',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0,),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xFF79747E),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.transparent,
                            ),
                            child: Text(
                              '${DateFormat('yyyy-MM-dd').format(widget.itemData.completeDate)}',
                              style: TextStyle(
                                color: Color(0xFF49454F),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        ],
                      ),

                      if(widget.itemData.status) WillowVerticalGap(height: 8,),

                      if(widget.itemData.status) Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Returned on',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0,),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xFF79747E),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.transparent,
                            ),
                            child: Text(
                              '${DateFormat('yyyy-MM-dd').format(widget.itemData.returnDate)}',
                              style: TextStyle(
                                color: Color(0xFF49454F),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        ],
                      ),

                      WillowVerticalGap(height: 8,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Status',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0,),
                            decoration: BoxDecoration(
                              color: widget.itemData.status? Color(0xFFADF2C6) : Colors.transparent,
                              border: Border.all(
                                color: widget.itemData.status? Color(0xFF286A48) : Color(0xFFFF6961),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Row(
                              children: [
                                if(widget.itemData.status) Icon(
                                  FontAwesomeIcons.check, // Change to your desired icon
                                  color: Color(0xFF1D1B20), // Customize icon color
                                ),
                                if(widget.itemData.status) SizedBox(width: 8,), // Add 8px gap
                                Text(
                                  widget.itemData.status? 'Returned':"Due",
                                  style: TextStyle(
                                    color: widget.itemData.status? Color(0xFF286A48) : Color(0xFFFF6961),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          )

                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
