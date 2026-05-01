import 'dart:io';

import 'package:flutter/services.dart';
import 'package:states_app/core/preferences/local_storage_service.dart';

import 'package:path_provider/path_provider.dart';

class EnvService {
  static const String _storageKey = 'selected_env';
  static const String assetDefault = 'environments/.env';
  static const String assetDebug = 'environments/debug.env';

  static const String optionDefault = 'default';
  static const String optionDebug = 'debug';

  static Future<Directory> _envDir() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory('${docs.path}${Platform.pathSeparator}environments');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  static Future<File> defaultFile() async {
    final dir = await _envDir();
    return File('${dir.path}${Platform.pathSeparator}.env');
  }

  static Future<File> debugFile() async {
    final dir = await _envDir();
    return File('${dir.path}${Platform.pathSeparator}debug.env');
  }

  static String getSelectedOption() {
    final box = LocalStorageService();
    final value = box.get(_storageKey);
    if (value == optionDebug) return optionDebug;
    return optionDefault;
  }

  static Future<void> setSelectedOption(String option) async {
    final box = LocalStorageService();
    await box.set(_storageKey, option == optionDebug ? optionDebug : optionDefault);
  }

  static Future<void> ensureEnvFilesExist() async {
    final def = await defaultFile();
    final dbg = await debugFile();

    if (!await def.exists()) {
      final contents = await rootBundle.loadString(assetDefault);
      await def.writeAsString(_normalize(contents));
    }
    if (!await dbg.exists()) {
      final contents = await rootBundle.loadString(assetDebug);
      await dbg.writeAsString(_normalize(contents));
    }
  }

  static Future<String> activeEnvPath() async {
    final selected = getSelectedOption();
    if (selected == optionDebug) {
      return (await debugFile()).path;
    }
    return (await defaultFile()).path;
  }

  static String _normalize(String input) {
    final trimmedRight = input.replaceAll(RegExp(r'[ \t]+\n'), '\n').trimRight();
    return trimmedRight.isEmpty ? '' : '$trimmedRight\n';
  }
}