import 'package:states_app/feature/splash/view/splash_view.dart';
import 'package:states_app/feature/splash/binding/splash_binding.dart';
import 'package:states_app/feature/generative_chat/view/generative_chat_view.dart';
import 'package:states_app/feature/generative_chat/binding/generative_chat_binding.dart';

import 'package:get/get.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.CHAT,
      page: () => const GenerativeChatView(),
      binding: GenerativeChatBinding(),
    ),
  ];
}
