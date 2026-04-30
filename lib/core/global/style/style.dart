import 'package:flutter/material.dart';

class Styles {
  Styles._();

  /// Default font family for the app (must match pubspec.yaml fonts).
  static const String fontFamily = 'Inter';

  static const TextStyle txt24W600 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static const TextStyle txt16W400 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.45,
  );

  static const TextStyle txt12W400 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle txt12W600 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle txt14W600 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle txt16W600 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
}

const TextStyle txt16W600 = TextStyle(
  fontFamily: Styles.fontFamily,
  fontSize: 16,
  fontWeight: FontWeight.w600,
);

const TextStyle txt18W600 = TextStyle(
  fontFamily: Styles.fontFamily,
  fontSize: 18,
  fontWeight: FontWeight.w600,
);

const TextStyle txt20W700 = TextStyle(
  fontFamily: Styles.fontFamily,
  fontSize: 20,
  fontWeight: FontWeight.w700,
  height: 1.1,
);

const TextStyle txt14W400 = TextStyle(
  fontFamily: Styles.fontFamily,
  fontSize: 14,
  fontWeight: FontWeight.w400,
  height: 1.3,
);

const TextStyle txt14W600 = TextStyle(
  fontFamily: Styles.fontFamily,
  fontSize: 14,
  fontWeight: FontWeight.w600,
);

const TextStyle txt13W400 = TextStyle(
  fontFamily: Styles.fontFamily,
  fontSize: 13,
  letterSpacing: 2,
  fontWeight: FontWeight.w600,
  height: 1.3,
);

const TextStyle appBarTextStyle = TextStyle(
  fontFamily: Styles.fontFamily,
  fontSize: 18,
  height: 1.3,
  fontWeight: FontWeight.w600,
  letterSpacing: 2,
);
