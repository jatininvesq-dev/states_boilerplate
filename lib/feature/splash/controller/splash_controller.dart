import 'package:get/get.dart';
import 'package:states_app/core/routes/app_page.dart';

class SplashController extends GetxController with GetTickerProviderStateMixin {
  final RxDouble opacity = 0.0.obs;
  final RxDouble scale = 0.5.obs;

  @override
  void onInit() {
    super.onInit();
    _startAnimation();
  }

  void _startAnimation() {
    Future.delayed(const Duration(milliseconds: 300), () {
      opacity.value = 1.0;
      scale.value = 1.0;
    });

    Future.delayed(const Duration(seconds: 3), () {
      _navigateToChat();
    });
  }

  void _navigateToChat() {
    Get.offAllNamed(Routes.CHAT);
  }
}