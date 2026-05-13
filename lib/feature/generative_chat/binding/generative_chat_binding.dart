import 'package:get/get.dart';
import 'package:states_app/feature/generative_chat/controller/generative_chat_controller.dart';
import 'package:states_app/feature/generative_chat/service/gpt_api_service.dart';

class GenerativeChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GptApiService>(() => GptApiService());
    Get.lazyPut<GenerativeChatController>(
      () => GenerativeChatController(Get.find<GptApiService>()),
    );
  }
}