import 'package:get/get.dart';
import 'package:states_app/feature/generative_chat/model/chat_message.dart';
import 'package:states_app/feature/generative_chat/service/gpt_api_service.dart';
import 'package:uuid/uuid.dart';

class GenerativeChatController extends GetxController {
  final GptApiService _gptApiService;
  
  GenerativeChatController(this._gptApiService);

  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _addInitialMessage();
  }

  void _addInitialMessage() {
    messages.add(
      ChatMessage(
        id: const Uuid().v4(),
        content: 'Hello! 👋 I\'m your AI assistant. How can I help you today?',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  Future<void> sendMessage(String messageText) async {
    if (messageText.trim().isEmpty) return;

    // Clear error message
    errorMessage.value = '';

    // Add user message
    final userMessage = ChatMessage(
      id: const Uuid().v4(),
      content: messageText.trim(),
      isUser: true,
      timestamp: DateTime.now(),
    );
    messages.add(userMessage);

    // Show loading state
    isLoading.value = true;

    try {
      // Get AI response
      final response = await _gptApiService.sendMessage(messageText);

      // Add AI message
      final aiMessage = ChatMessage(
        id: const Uuid().v4(),
        content: response,
        isUser: false,
        timestamp: DateTime.now(),
      );
      messages.add(aiMessage);
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');

      // Add error message to chat
      final errorChatMessage = ChatMessage(
        id: const Uuid().v4(),
        content: 'Sorry, I encountered an error: ${errorMessage.value}',
        isUser: false,
        timestamp: DateTime.now(),
      );
      messages.add(errorChatMessage);
    } finally {
      isLoading.value = false;
    }
  }

  void clearChat() {
    messages.clear();
    errorMessage.value = '';
    _addInitialMessage();
  }
}