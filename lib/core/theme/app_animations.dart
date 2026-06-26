import 'package:flutter/material.dart';

/// Shared animation durations and curves for consistent motion.
abstract final class AppAnimations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);
  static const Duration entrance = Duration(milliseconds: 350);

  static const Curve standard = Curves.easeOutCubic;
  static const Curve emphasized = Curves.easeOutBack;
  static const Curve decelerate = Curves.decelerate;

  static Animation<double> fadeIn(Animation<double> parent) {
    return CurvedAnimation(parent: parent, curve: standard);
  }

  static Animation<Offset> slideUp(Animation<double> parent) {
    return Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: parent, curve: standard));
  }
}
