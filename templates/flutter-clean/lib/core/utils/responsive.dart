import 'package:flutter/widgets.dart';

/// Small responsive helper that avoids sprinkling magic breakpoints everywhere.
class Responsive {
  Responsive._();

  static const double tabletBreakpoint = 720;
  static const double desktopBreakpoint = 1024;

  static bool isTablet(BuildContext context) => MediaQuery.sizeOf(context).width >= tabletBreakpoint;
  static bool isDesktop(BuildContext context) => MediaQuery.sizeOf(context).width >= desktopBreakpoint;

  /// Useful for adaptive padding/grids.
  static int columns(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w >= desktopBreakpoint) return 4;
    if (w >= tabletBreakpoint) return 2;
    return 1;
  }
}

