import 'package:flutter/material.dart';

class Logger {
  static const minLevel = 5;
  final String namespace;
  const Logger(this.namespace);

  void e(String message) => _log('ERROR', 1, message);
  void w(String message) => _log('WARNING', 2, message);
  void i(String message) => _log('INFO', 3, message);
  void d(String message) => _log('DEBUG', 4, message);
  void v(String message) => _log('VERBOSE', 5, message);

  void _log(String prefix, int level, String message) {
    if (level <= minLevel) {
      debugPrint('$prefix [$namespace]: $message');
    }
  }
}
