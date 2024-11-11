import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data_classes/subordinate_classes/item_class.dart';
import '../../pages/homepage/pages/subordinate_pages/item_model.dart';

class ItemCard extends StatefulWidget {
  final ItemData itemData;
  final Function(ItemData) onCancelPressed;

  const ItemCard({
    Key? key,
    required this.itemData,
    required this.onCancelPressed,
  }) : super(key: key);

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  @override
  Widget build(BuildContext context) {
    String firstLetter = widget.itemData.itemName.substring(0, 1).toUpperCase();

    // Format the date
    String formattedDate = DateFormat('dd MMMM yyyy').format(widget.itemData.completeDate);

    // Determine the status text
    String statusText = widget.itemData.status ? 'Returned on $formattedDate' : 'Due on $formattedDate';

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return ItemDetailsModal(
              itemData: widget.itemData,
              onCancelPressed: () {
                print("removed"); // TODO: remove the item corresponding to this
                widget.onCancelPressed(widget.itemData);
              },
            );
          },
        );
      },
      child: Container(
        // margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: widget.itemData.status? Color(0xFFADF2C6): Color(0xFFFFDAD6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                _buildCircularContainer(firstLetter),
                Text(
                  widget.itemData.itemName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF1D1B20),
                  ),
                ),
              ],
            ),
            SizedBox(width:10),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF49454F),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularContainer(String firstLetter) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.5),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.27),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            firstLetter,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF21005D),
            ),
          ),
        ),
      ),
    );
  }
}
