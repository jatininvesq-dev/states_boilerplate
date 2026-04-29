
import 'package:states_app/feature/splash/view/splash_view.dart';

import 'package:get/get.dart';
part 'app_routes.dart';
class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      
    ),
    
  ];
}
