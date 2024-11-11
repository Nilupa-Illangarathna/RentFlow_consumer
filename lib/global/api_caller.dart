import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import './global_settings.dart';

class ApiCaller {
  final String baseUrl;

  ApiCaller({required this.baseUrl});

  Future<Map<String, dynamic>?> callApi({required String route,required String sessionToken,required Map<String, dynamic> body, }) async {
    try {
      final response = await http.post(
        Uri.parse('${globalData.baseUrl}$route'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          if(sessionToken != "")'authorization': sessionToken,
        },
        body: body=={}? {} : jsonEncode(body),
      );

      return jsonDecode(response.body);

    } catch (e) {
      print('Exception while calling API: $e');
      return null;
    }
  }
}

// Instantiate a global object
ApiCaller apiCaller = ApiCaller(baseUrl: globalData.baseUrl);
