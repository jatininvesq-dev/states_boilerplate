import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:states_app/core/routes/app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: LoginRoute.page, initial: true),
  ];
}