import 'package:flutter/widgets.dart';

class Responsive {
  Responsive._();

  static const double tabletBreakpoint = 720;
  static const double desktopBreakpoint = 1024;

  static bool isTablet(BuildContext context) => MediaQuery.sizeOf(context).width >= tabletBreakpoint;
  static bool isDesktop(BuildContext context) => MediaQuery.sizeOf(context).width >= desktopBreakpoint;
}

