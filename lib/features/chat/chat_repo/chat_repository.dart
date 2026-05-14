import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../services/api_services.dart';

class ChatMessage {
  final String id;
  final String fromUserId;
  final String? toUserId;
  final String content;
  final String type; // 'text', 'image', 'document'
  final String? fileUrl;
  final String? fileType;
  final String? fileName;
  final DateTime createdAt;

  ChatMessage({
    required this.id,
    required this.fromUserId,
    this.toUserId,
    required this.content,
    this.type = 'text',
    this.fileUrl,
    this.fileType,
    this.fileName,
    required this.createdAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['_id'] ?? json['id'] ?? '',
      fromUserId: json['fromUserId'] ?? '',
      toUserId: json['toUserId'],
      content: json['content'] ?? '',
      type: json['type'] ?? json['messageType'] ?? 'text',
      fileUrl: json['fileUrl'] ?? json['attachmentUrl'],
      fileType: json['fileType'],
      fileName: json['fileName'],
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
      'type': type,
      'fileUrl': fileUrl,
      'fileType': fileType,
      'fileName': fileName,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class Conversation {
  String? sId;
  String? lastMessage;
  String? lastMessageAt;
  String? lastFromUserId;
  User? user;
  String? otherUserId;

  Conversation({
    this.sId,
    this.lastMessage,
    this.lastMessageAt,
    this.lastFromUserId,
    this.user,
    this.otherUserId,
  });

  Conversation.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    lastMessage = json['lastMessage'];
    lastMessageAt = json['lastMessageAt'];
    lastFromUserId = json['lastFromUserId'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    otherUserId = json['otherUserId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['lastMessage'] = this.lastMessage;
    data['lastMessageAt'] = this.lastMessageAt;
    data['lastFromUserId'] = this.lastFromUserId;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['otherUserId'] = this.otherUserId;
    return data;
  }
}

class User {
  String? userId;
  String? name;
  String? email;
  bool? isOnline;
  String? lastSeen;

  User({this.userId, this.name, this.email, this.isOnline, this.lastSeen});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    name = json['name'];
    email = json['email'];
    isOnline = json['isOnline'];
    lastSeen = json['lastSeen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['isOnline'] = this.isOnline;
    data['lastSeen'] = this.lastSeen;
    return data;
  }
}

/*class Conversation {
  final String userId;
  final String userName;
  final String lastMessage;
  final String lastMessageType;
  final String? lastMessageFileUrl;
  final DateTime lastMessageTime;

  Conversation({
    required this.userId,
    required this.userName,
    required this.lastMessage,
    this.lastMessageType = 'text',
    this.lastMessageFileUrl,
    required this.lastMessageTime,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      userId: json['userId'] ?? json['id'] ?? json['_id'] ?? '',
      userName:
          json['userName'] ??
          json['name'] ??
          json['fullName'] ??
          json['otherUserName'] ??
          json['otherUser']?['name'] ??
          'Unknown',
      lastMessage: json['lastMessage'] ?? '',
      lastMessageType: json['lastMessageType'] ?? json['type'] ?? 'text',
      lastMessageFileUrl: json['lastMessageFileUrl'] ?? json['fileUrl'],
      lastMessageTime: DateTime.parse(
        json['lastMessageTime'] ?? DateTime.now().toIso8601String(),
      ).toLocal(),
    );
  }
}
*/
class ChatRepository {
  static const String baseUrl = 'http://192.168.1.14:8080';
  static const String wsUrl = 'ws://192.168.1.14:8080';

  final ApiService _apiService = ApiService();
  WebSocketChannel? _channel;
  String? _currentUserId;
  String? _authToken;
  final ValueNotifier<ChatMessage?> messageReceived = ValueNotifier(null);
  final ValueNotifier<Map<String, dynamic>?> userStatusReceived = ValueNotifier(
    null,
  );
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
      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

      // Send init message with userId
      final initMessage = {'type': 'init', 'userId': userId};
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
      } else if (decoded['type'] == 'user_status') {
        userStatusReceived.value = decoded;
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
    String type = 'text',
    String? fileUrl,
    String? fileType,
    String? fileName,
  }) {
    if (_channel == null || _currentUserId == null) {
      throw Exception('WebSocket not initialized');
    }

    final message = {
      'type': 'message',
      'fromUserId': _currentUserId,
      'toUserId': toUserId,
      'content': content,
      'messageType': type,
      'fileUrl': fileUrl,
      'fileType': fileType,
      'fileName': fileName,
    };

    _channel?.sink.add(jsonEncode(message));
  }

  /// Upload a file to the server
  Future<Map<String, dynamic>> uploadFile(String filePath) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
      });

      final result = await _apiService.post('/messages/upload', formData);

      return result.fold(
        (error) => throw Exception('Failed to upload file: $error'),
        (response) => response.data as Map<String, dynamic>,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading file: $e');
      }
      rethrow;
    }
  }

  /// Fetch message history with a specific user
  Future<List<ChatMessage>> fetchMessageHistory(String otherUserId) async {
    try {
      final result = await _apiService.get('/messages/with/$otherUserId');

      return result.fold(
        (error) {
          if (kDebugMode) {
            print('Error fetching message history: $error');
          }
          return [];
        },
        (response) {
          final decoded = response.data;
          List<dynamic> data = [];
          if (decoded is List) {
            data = decoded;
          } else if (decoded is Map) {
            data = decoded['messages'] ?? decoded['data'] ?? [];
          }
          return data.map((msg) => ChatMessage.fromJson(msg)).toList();
        },
      );
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
      final result = await _apiService.get('/messages/conversations');

      return result.fold(
        (error) {
          if (kDebugMode) {
            print('Error fetching conversations: $error');
          }
          return [];
        },
        (response) {
          final decoded = response.data;
          List<dynamic> data = [];
          if (decoded is List) {
            data = decoded;
          } else if (decoded is Map) {
            data = decoded['conversations'] ?? decoded['data'] ?? [];
          }
          return data.map((conv) => Conversation.fromJson(conv)).toList();
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching conversations: $e');
      }
      return [];
    }
  }

  /// Delete a single message
  Future<bool> deleteMessage(String messageId) async {
    try {
      final result = await _apiService.delete('/messages/$messageId');
      return result.fold((error) {
        if (kDebugMode) {
          print('Error deleting message: $error');
        }
        return false;
      }, (response) => response.statusCode == 200);
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting message: $e');
      }
      return false;
    }
  }

  /// Clear all conversation messages
  Future<bool> clearConversation(String otherUserId) async {
    try {
      final result = await _apiService.delete(
        '/messages/conversation/$otherUserId',
      );
      return result.fold((error) {
        if (kDebugMode) {
          print('Error clearing conversation: $error');
        }
        return false;
      }, (response) => response.statusCode == 200);
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing conversation: $e');
      }
      return false;
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
