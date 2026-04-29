import 'package:get_storage/get_storage.dart';
import 'package:states_app/core/preferences/session_keys.dart';

class AppSession {
  static GetStorage? sessionData;
  static GetStorage? notificationSession;
  static GetStorage? introScreenData;

  static void init() {
    introScreenData = GetStorage();
    notificationSession = GetStorage();
    sessionData = GetStorage();
  }

  static void setAccessToken(String? value) {
    sessionData?.write(UserSessionDetail.kAccessToken, value);
  }

  static String getAccessToken() {
    return sessionData?.read(UserSessionDetail.kAccessToken) ?? "";
  }

  static void setFcmToken(String? value) {
    notificationSession?.write(UserSessionDetail.fcmToken, value);
  }

  static String getFcmToken() {
    return notificationSession?.read(UserSessionDetail.fcmToken) ?? "";
  }

  static Future<void> clearStorage() async {
    final savedFcmToken = getFcmToken();
    await sessionData?.erase();
    init();
    if (savedFcmToken.isNotEmpty) {
      setFcmToken(savedFcmToken);
    }
  }
}
