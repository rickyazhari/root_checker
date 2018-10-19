import 'dart:async';

import 'package:flutter/services.dart';

class RootChecker {
  static const MethodChannel _channel = const MethodChannel('root_checker');

  static Future<bool> get isDeviceRooted async{
    return await _channel.invokeMethod('isDeviceRooted');
  }
}
