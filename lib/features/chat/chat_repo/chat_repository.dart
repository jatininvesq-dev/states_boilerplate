import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ChatMessage {
  final String id;
  final String fromUserId;
  final String? toUserId;
  final String content;
  final DateTime createdAt;

  ChatMessage({
    required this.id,
    required this.fromUserId,
    this.toUserId,
    required this.content,
    required this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['_id'] ?? json['id'] ?? '',
      fromUserId: json['fromUserId'] ?? '',
      toUserId: json['toUserId'],
      content: json['content'] ?? '',
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ).toLocal(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class Conversation {
  final String userId;
  final String userName;
  final String lastMessage;
  final DateTime lastMessageTime;

  Conversation({
    required this.userId,
    required this.userName,
    required this.lastMessage,
    required this.lastMessageTime,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? 'Unknown',
      lastMessage: json['lastMessage'] ?? '',
      lastMessageTime: DateTime.parse(
        json['lastMessageTime'] ?? DateTime.now().toIso8601String(),
      ).toLocal(),
    );
  }
}

class ChatRepository {
  static const String baseUrl = 'http://192.168.1.14:8080';
  static const String wsUrl = 'ws://192.168.1.14:8080';

  WebSocketChannel? _channel;
  String? _currentUserId;
  String? _authToken;
  final ValueNotifier<ChatMessage?> messageReceived = ValueNotifier(null);
  final ValueNotifier<bool> isConnected = ValueNotifier(false);

  /// Initialize WebSocket connection and authenticate
  Future<void> initializeSocket({
    required String userId,
    required String authToken,
  }) async {
    try {
      _currentUserId = userId;
      _authToken = authToken;

      // Connect to WebSocket
      _channel = WebSocketChannel.connect(
        Uri.parse(wsUrl),
      );

      // Send init message with userId
      final initMessage = {
        'type': 'init',
        'userId': userId,
      };
      _channel?.sink.add(jsonEncode(initMessage));

      isConnected.value = true;

      // Listen for messages
      _channel?.stream.listen(
        (message) {
          _handleMessage(message);
        },
        onError: (error) {
          if (kDebugMode) {
            print('WebSocket Error: $error');
          }
          isConnected.value = false;
        },
        onDone: () {
          isConnected.value = false;
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print('WebSocket Connection Error: $e');
      }
      isConnected.value = false;
    }
  }

  /// Handle incoming WebSocket messages
  void _handleMessage(dynamic message) {
    try {
      final decoded = jsonDecode(message);

      if (decoded['type'] == 'message' && decoded['message'] != null) {
        final chatMessage = ChatMessage.fromJson(decoded['message']);
        messageReceived.value = chatMessage;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error handling message: $e');
      }
    }
  }

  /// Send a one-to-one message
  void sendMessage({
    required String toUserId,
    required String content,
  }) {
    if (_channel == null || _currentUserId == null) {
      throw Exception('WebSocket not initialized');
    }

    final message = {
      'type': 'message',
      'fromUserId': _currentUserId,
      'toUserId': toUserId,
      'content': content,
    };

    _channel?.sink.add(jsonEncode(message));
  }

  /// Fetch message history with a specific user
  Future<List<ChatMessage>> fetchMessageHistory(String otherUserId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/messages/with/$otherUserId'),
        headers: {
          'Authorization': 'Bearer $_authToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List<dynamic> data = [];
        if (decoded is List) {
          data = decoded;
        } else if (decoded is Map) {
          data = decoded['messages'] ?? decoded['data'] ?? [];
        }
        return data.map((msg) => ChatMessage.fromJson(msg)).toList();
      } else {
        throw Exception('Failed to fetch message history');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching message history: $e');
      }
      return [];
    }
  }

  /// Fetch conversation list for current user
  Future<List<Conversation>> fetchConversations() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/messages/conversations'),
        headers: {
          'Authorization': 'Bearer $_authToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List<dynamic> data = [];
        if (decoded is List) {
          data = decoded;
        } else if (decoded is Map) {
          data = decoded['conversations'] ?? decoded['data'] ?? [];
        }
        return data.map((conv) => Conversation.fromJson(conv)).toList();
      } else {
        throw Exception('Failed to fetch conversations');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching conversations: $e');
      }
      return [];
    }
  }

  /// Disconnect WebSocket
  void disconnect() {
    _channel?.sink.close();
    isConnected.value = false;
  }

  /// Check if connected
  bool get connected => isConnected.value;

  /// Get current user ID
  String? get currentUserId => _currentUserId;
}
