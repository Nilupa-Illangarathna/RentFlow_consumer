import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../global/api_caller.dart';
import '../../../global/global_settings.dart';
import '../../../global/responsiveness.dart';
import '../../../widgets/common/loading_screen.dart';
import '../../../widgets/homepage/profile_card.dart';

class QRCodePage extends StatefulWidget {
  @override
  _QRCodePageState createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  late Future<String> _futureQrString;
  late Map<String, dynamic> get_status;

  @override
  void initState() {
    super.initState();
    _futureQrString = _fetchConsumerId();
    get_status = {'name': "", 'active': false};

  }

  Future<String> _fetchConsumerId() async {


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


    // Make API call to fetch profile data
    final url = '${globalData.baseUrl}/consumer/get_id';

    // Construct request body
    Map<String, dynamic> requestBody = {};

    Map<String, dynamic>? response = await apiCaller.callApi(
      sessionToken: globalData.sessionToken,
      route: '/consumer/get_id',
      body: requestBody,
    );

    print("response is : ${response}");
    if (response?["is_success"] == true) {
      return "${response?['consumer_id']}";
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response?['message']),
          backgroundColor: Colors.red,
        ),
      );
      return "";
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 24.0),
        child: WillowPadding(
          padding: 24,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ProfileWidget(icon: Icons.person, name: get_status["name"], status: get_status["active"]),
              Expanded(
                child: FutureBuilder<String>(
                  future: _futureQrString,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: LoadingScreen());
                    } else if (snapshot.hasError) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(snapshot.error.toString()),
                            duration: Duration(seconds: 4),
                            backgroundColor: Colors.red,
                          ),
                        );
                      });
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      return Center(
                        child: Container(
                          width: 230,
                          height: 230,
                          child: BarcodeWidget(
                            barcode: Barcode.qrCode(),
                            data: snapshot.data!,
                            color: Colors.black,
                            backgroundColor: Colors.white,
                            width: 188,
                            height: 188,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
