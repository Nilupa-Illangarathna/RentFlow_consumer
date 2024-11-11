import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;

import '../../../data_classes/subordinate_classes/item_class.dart';
import '../../../data_classes/user_item_class.dart';
import '../../../global/api_caller.dart';
import '../../../global/global_settings.dart';
import '../../../global/responsiveness.dart';
import '../../../utils/constants.dart';
import '../../../widgets/common/elevated_button.dart';
import '../../../widgets/common/loading_screen.dart';
import '../../../widgets/homepage/item_card.dart';
import '../../../widgets/homepage/profile_widget.dart';
import 'customer_service/customer_service_page.dart';
import 'subordinate_pages/item_model.dart';
import '../../../widgets/homepage/item_status.dart'; // Import BorrowedDueRow widget

class DashBoard extends StatefulWidget {
  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  late List<ItemData> itemData;
  late List<ItemData> filteredItemData;
  late Map<String, int> borrowedDueData;
  late Future<void> _fetchDataFuture;
  late Map<String, dynamic> get_status;
  bool currentState=true;

  @override
  void initState() {
    super.initState();
    _fetchDataFuture = _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      itemData = [];
      filteredItemData = [];
      borrowedDueData = {'borrowed': 0, 'due': 0};
      get_status = {'name': "", 'active': false};
    });

    final urlStatus = '${globalData.baseUrl}/consumer/get_status';

    Map<String, dynamic>? responseStatus = await apiCaller.callApi(
      sessionToken: globalData.sessionToken,
      route: '/consumer/get_status',
      body: {},
    );

    print("response is : ${responseStatus}");
    if (responseStatus?["is_success"] == true) {
      setState(() {
        get_status = {'name': responseStatus?["name"], 'active': responseStatus?["status"]==1};
      });
    } else {
      throw Exception('Failed to fetch data');
    }

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
            type: item['status'] == 1 ? 'borrowed' : 'due',
            backgroundColor: Color(0xFFA6F2D2),
            itemName: item['package_name'],
            completeDate: DateTime.parse(item['created_at']),
            returnDate: item['returned_at'] != null ? DateTime.parse(item['returned_at']) : DateTime.now(),
            status: item['status'] == 1,
            borrowedBy: "",
          );
        }).toList();
        currentState=true;
        filteredItemData = itemData.where((item) => item.status).toList();
        borrowedDueData = {
          'borrowed': itemData.where((item) => item.status).length,
          'due': itemData.where((item) => !item.status).length,
        };
      });
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  void handleButtonPressed(String buttonLabel) {
    setState(() {
      // Filter itemData based on button pressed
      if (buttonLabel == 'borrowed') {
        currentState=true;
        filteredItemData = itemData.where((item) => item.status).toList();
      } else if (buttonLabel == 'due') {
        currentState=false;
        filteredItemData = itemData.where((item) => !item.status).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
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
                  SizedBox(height: 28),
                  ProfileWidget(
                    name: get_status["name"], // Replace with actual user data
                    isActive: get_status["active"], // Replace with actual user data
                    profileImageUrl: null,
                  ), // Display the ProfileWidget at the top
                  WillowVerticalGap(height: 8,),
                  Row(
                    children: [
                      Text(
                        'Item Status',
                        style: TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  WillowVerticalGap(height: 8,),
                  BorrowedDueRow(
                    data: borrowedDueData,
                    onButtonPressed: handleButtonPressed,
                  ),
                  WillowVerticalGap(height: 8,),
                  WillowElevatedButton(
                    onPressed: () async {
                      await onCustomerService();
                    },
                    buttonText: 'Customer Service',
                    icon: Icons.phone_outlined, // Optional icon
                  ),
                  WillowVerticalGap(height: 8,),
                  Row(
                    children: [
                      Text(
                        '${currentState? "Borrowed": "Due"} Items',
                        style: TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  WillowVerticalGap(height: 8,),
                  Expanded(
                    child: Container(
                      height: 500,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListView.builder(
                        itemCount: filteredItemData.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            child: ItemCard(
                              itemData: filteredItemData[index],
                              onCancelPressed: (ItemData item) {
                                // Implement cancel action here
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
    );
  }

  Future<void> onCustomerService() async {
    // Implement customer service logic
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CustomerServicePage()),
    );
  }
}
