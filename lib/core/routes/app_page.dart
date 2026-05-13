
import 'package:states_app/features/authentication/login/login_view.dart';
import 'package:states_app/features/authentication/register/register_view.dart';
import 'package:states_app/features/splash/view/splash_view.dart';
import 'package:states_app/features/home/view/home_view.dart';

import 'package:states_app/feature/splash/view/splash_view.dart' hide SplashView;
import 'package:states_app/feature/splash/binding/splash_binding.dart';
import 'package:states_app/feature/generative_chat/view/generative_chat_view.dart';
import 'package:states_app/feature/generative_chat/binding/generative_chat_binding.dart';


import 'package:get/get.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [

    GetPage(name: _Paths.SPLASH, page: () => const SplashView()),
    GetPage(name: _Paths.LOGIN, page: () => const LoginView()),
    GetPage(name: _Paths.REGISTER, page: () => const RegisterView()),
    GetPage(name: _Paths.HOME, page: () => const HomeView()),

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
