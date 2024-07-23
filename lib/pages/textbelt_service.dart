import 'dart:convert';
import 'package:http/http.dart' as http;

class TextbeltService {
  final String apiUrl = 'https://textbelt.com/text';

  Future<void> sendSms(String to, String message) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'phone': to,
        'message': message,
        'key':
            'textbelt', // Use the free key 'textbelt' for the limited free tier
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['success']) {
        print('Message sent: ${response.body}');
      } else {
        print('Failed to send message: ${response.body}');
      }
    } else {
      print('Error: ${response.body}');
    }
  }
}
