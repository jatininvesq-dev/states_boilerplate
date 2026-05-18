import 'dart:io';

import 'package:flutter/foundation.dart';

class CameraPermissionUtils {
  static bool get isSupportedPlatform {
    if (kIsWeb) return false;
    return Platform.isAndroid || Platform.isIOS;
  }
}
