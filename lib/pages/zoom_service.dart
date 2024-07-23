import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';

class ZoomService {
  final String _baseUrl = 'https://api.zoom.us/v2';
  final String _tokenUrl = 'https://zoom.us/oauth/token';

  Future<String> _getOAuthToken() async {
    final credentials = base64Encode(utf8.encode('$clientId:$clientSecret'));
    final headers = {
      'Authorization': 'Basic $credentials',
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    final body = 'grant_type=client_credentials';

    final response = await http.post(
      Uri.parse(_tokenUrl),
      headers: headers,
      body: body,
    );

    print('Token Response: ${response.statusCode} ${response.body}');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['access_token'];
    } else {
      throw Exception(
          'Failed to obtain access token: ${response.statusCode} ${response.body}');
    }
  }

  Future<void> createMeeting(
      {required String topic, required String startTime}) async {
    final token = await _getOAuthToken();
    final url = Uri.parse('$_baseUrl/users/me/meetings');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final body = json.encode({
      'topic': topic,
      'type': 2,
      'start_time': startTime,
      'duration': 30,
      'timezone': 'UTC',
    });

    print('Request URL: $url');
    print('Request Headers: $headers');
    print('Request Body: $body');

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 201) {
      print('Meeting created successfully: ${response.body}');
    } else {
      print(
          'Failed to create meeting: ${response.statusCode} ${response.body}');
    }
  }
}
