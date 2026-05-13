import 'package:states_app/features/authentication/login/login_view.dart';
import 'package:states_app/features/authentication/register/register_view.dart';
import 'package:states_app/features/splash/view/splash_view.dart';
import 'package:states_app/features/home/view/home_view.dart';

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
  ];
}
