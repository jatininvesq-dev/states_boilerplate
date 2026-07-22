import 'dart:convert';
import 'package:http/http.dart' as http;

class DeepSeekService {
  static const String apiKey = "YOUR_DEEPSEEK_API_KEY";

  Future<String> sendMessage(String message) async {
    final response = await http.post(
      Uri.parse('https://api.deepseek.com/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        "model": "deepseek-chat",
        "messages": [
          {
            "role": "user",
            "content": message,
          }
        ],
        "temperature": 0.7,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return data["choices"][0]["message"]["content"];
    }

    throw Exception(response.body);
  }
}