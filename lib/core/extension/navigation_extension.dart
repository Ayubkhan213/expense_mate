import 'package:flutter/material.dart';

extension NavRoute on String {
  Future<T?> go<T>(BuildContext context) {
    return Navigator.pushNamed(context, this);
  }

  Future<T?> replace<T>(BuildContext context) {
    return Navigator.pushReplacementNamed(context, this);
  }

  Future<T?> clearAll<T>(BuildContext context) {
    return Navigator.pushNamedAndRemoveUntil(context, this, (route) => false);
  }
}
