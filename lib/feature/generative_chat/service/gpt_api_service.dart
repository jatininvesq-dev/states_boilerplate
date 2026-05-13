import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GptApiService {
  late final String _apiKey;
  final String _apiUrl = 'https://api.openai.com/v1/chat/completions';
  late final Dio _dio;

  GptApiService() {
    _apiKey = dotenv.env['GPT_API'] ?? '';
    _initializeDio();
    _validateApiKey();
  }

  void _initializeDio() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        contentType: Headers.jsonContentType,
        headers: {
          'User-Agent': 'Flutter-ChatApp/1.0',
          'Accept-Encoding': 'gzip, deflate',
        },
      ),
    );
  }

  void _validateApiKey() {
    if (_apiKey.isEmpty) {
      debugPrint('⚠️ WARNING: GPT_API key not found in environment variables!');
      debugPrint('Make sure gpt.env file contains: GPT_API=<your-api-key>');
    } else {
      debugPrint('✅ GPT_API key loaded successfully');
      debugPrint('🔑 API Key starts with: ${_apiKey.substring(0, 10)}...');
    }
  }

  Future<String> sendMessage(String message) async {
    try {
      if (_apiKey.isEmpty) {
        throw Exception(
          'API Key not found. Please set GPT_API in gpt.env file. '
          'The file should contain: GPT_API=sk-...',
        );
      }

      final modelName = dotenv.env['GPT_MODEL']?.trim().isNotEmpty == true
          ? dotenv.env['GPT_MODEL']!.trim()
          : 'gpt-3.5-turbo';

      final requestData = {
        'model': modelName,
        'messages': [
          {
            'role': 'user',
            'content': message,
          }
        ],
        'max_tokens': 500,
        'temperature': 0.7,
      };

      debugPrint('🧠 Using model: $modelName');
      debugPrint('📤 Sending request to OpenAI API...');

      final response = await _dio.post(
        _apiUrl,
        data: requestData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $_apiKey',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      debugPrint('📥 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final choices = response.data['choices'] as List;
        if (choices.isNotEmpty) {
          final responseMessage = choices[0]['message']['content'] as String;
          debugPrint('✅ Got response from API');
          return responseMessage.trim();
        }
        throw Exception('No response from API');
      } else if (response.statusCode == 401) {
        throw Exception(
          '❌ Unauthorized: Invalid or expired API key. '
          'Please verify your API key in gpt.env file.',
        );
      } else if (response.statusCode == 429) {
        throw Exception(
          '⏱️ Rate limit exceeded: OpenAI API is rate limiting requests. '
          'Please wait a moment and try again.',
        );
      } else if (response.statusCode == 400) {
        final error = response.data['error'] as Map?;
        final errorMessage = error?['message'] ?? 'Bad request';
        throw Exception(
          '❌ Bad Request: $errorMessage\n\n'
          'Make sure your API key is valid and has the required permissions.',
        );
      } else {
        throw Exception(
          'Failed to get response: ${response.statusCode}\n'
          '${response.data}',
        );
      }
    } on DioException catch (e) {
      debugPrint('🔴 Dio Error: ${e.message}');
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception(
          '⏱️ Connection timeout. Check your internet connection.',
        );
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception(
          '⏱️ Request timeout. OpenAI server is slow. Try again.',
        );
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception(
          '📡 Network error. Check your internet connection.',
        );
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      debugPrint('❌ Error: $e');
      throw Exception('Error: $e');
    }
  }
}
