import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:states_app/app.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    // await Firebase.initializeApp(
    //   options: DefaultFirebaseOptions.currentPlatform,
    // );
    // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    // await GetStorage.init();

    // AppSession.init();
    // await NotificationService.init();
    // await EnvService.ensureEnvFilesExist();
    // final activePath = await EnvService.activeEnvPath();
    // final envString = await File(activePath).readAsString();
    // dotenv.loadFromString(envString: envString, isOptional: true);
    
    
    // HttpOverrides.global = MyHttpOverrides();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // 1. Enable Edge-to-Edge mode
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    // 2. Set the navigation bar color to transparent
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        // systemNavigationBarColor: Colors.transparent, // Make it transparent
        systemNavigationBarColor: Colors.black, // Make it transparent
        systemNavigationBarContrastEnforced:
            true, // Remove the translucent "scrim" on Android 10+
        systemNavigationBarIconBrightness:
            Brightness.dark, // Adjust icon color (dark/light)
      ),
    );
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.dumpErrorToConsole(details);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      return true;
    };
    runApp(App());
  }, (Object error, StackTrace stack) {});
}


