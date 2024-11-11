import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;

import '../../../data_classes/subordinate_classes/item_class.dart';
import '../../../global/api_caller.dart';
import '../../../global/global_settings.dart';
import '../../../global/responsiveness.dart';
import '../../../utils/constants.dart';
import '../../../widgets/common/elevated_button.dart';
import '../../../widgets/common/loading_screen.dart';
import '../../../widgets/homepage/item_card.dart';
import '../../../widgets/homepage/profile_widget.dart';

class HistoryPage extends StatefulWidget {
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late List<ItemData> itemData;
  late List<ItemData> filteredItemData;
  late int borrowedCount;
  late Future<void> _fetchDataFuture;
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  FocusScopeNode focusScopeNode = FocusScopeNode();

  @override
  void initState() {
    super.initState();
    _fetchDataFuture = _fetchData();
    searchController.addListener(_filterData);
  }

  @override
  void dispose() {
    searchController.removeListener(_filterData);
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    setState(() {
      itemData = []; // Clear the existing data while fetching new data
      filteredItemData = [];
    });

    final url = '${globalData.baseUrl}/consumer/get_history';

    Map<String, dynamic>? response = await apiCaller.callApi(
      sessionToken: globalData.sessionToken,
      route: '/consumer/get_history',
      body: {},
    );

    print("response is : ${response}");
    if (response?["is_success"] == true) {
      setState(() {
        itemData = (response?['message'] as List).map((item) {
          return ItemData(
            id: item['transaction_id'].toString(),
            type: 'borrowed',
            backgroundColor: Color(0xFFA6F2D2),
            itemName: item['package_name'],
            completeDate: DateTime.parse(item['created_at']),
            returnDate: item['returned_at'] != null ? DateTime.parse(item['returned_at']) : DateTime.now(),
            status: item['status'] == 1,
            borrowedBy: "",
          );
        }).toList();
        filteredItemData = itemData;
      });
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  void _filterData() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredItemData = itemData.where((item) {
        return item.itemName.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _cancelTransaction(ItemData item) async {
    String index = item.id;

    final url = '${globalData.baseUrl}/consumer/cancel_transaction';

    Map<String, dynamic> body = {
      'transaction_id': index
    };

    Map<String, dynamic>? response = await apiCaller.callApi(
      sessionToken: globalData.sessionToken,
      route: '/consumer/cancel_transaction',
      body: body,
    );

    print("response is : ${response}");
    if (response?["is_success"] == true) {
      String message = response?['message'];

      setState(() {
        itemData.removeWhere((element) => element.id == index); // Remove item from the list
        _filterData(); // Update the filtered list
      });
      // Show snackbar based on response
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: Duration(seconds: 4),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      String message = response?['message'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: Duration(seconds: 4),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Unfocus all text fields when tapping outside
        },
        child: FutureBuilder<void>(
          future: _fetchDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingScreen(); // Display the loading screen
            } else if (snapshot.hasError) {
              print(snapshot.error); // Print the error to debug
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              return WillowPadding(
                padding: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Borrowing History',
                          style: TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      height: 58,
                      padding: EdgeInsets.only(left: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Color(0xFF79747E), width: 1),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: searchController,
                              focusNode: searchFocusNode,
                              decoration: InputDecoration(
                                hintText: 'Search History',
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                  color: Color(0xFF79747E),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.search, size: 24, color: Colors.black),
                            onPressed: () {
                              // Manually focus the search field
                              FocusScope.of(context).requestFocus(searchFocusNode);
                            },
                          ),
                        ],
                      ),
                    ),
                    WillowVerticalGap(height: 8),
                    Expanded(
                      child: Container(
                        height: 500,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListView.builder(
                          key: UniqueKey(),
                          itemCount: filteredItemData.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 4),
                              child: ItemCard(
                                itemData: filteredItemData[index],
                                onCancelPressed: (ItemData item) {
                                  setState(() {
                                    _cancelTransaction(item);
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
