import 'package:material_ui/material_ui.dart';

class AppColors {
  static const Color primaryTeal = Color(0xFF00897B);
  static const Color primaryLight = Color(0xFF4EBaaa);
  static const Color primaryDark = Color(0xFF005B4F);

  static const Color darkBackground = Color(0xFF0E1218);
  static const Color darkSurface = Color(0xFF141922);
  static const Color darkCard = Color(0xFF1A212D);
  static const Color darkTerminal = Color(0xFF0C1017);

  static const Color lightBackground = Color(0xFFF7F9FC);
  static const Color lightSurface = Colors.white;
  static const Color lightCard = Colors.white;

  static const Color statusGreen = Color(0xFF2E7D32);
  static const Color statusGreenLight = Color(0xFFE8F5E9);
  static const Color statusAmber = Color(0xFFEF6C00);
  static const Color statusAmberLight = Color(0xFFFFF3E0);
  static const Color statusRed = Color(0xFFC62828);
  static const Color statusRedLight = Color(0xFFFFEBEE);

  static Color getRscpColor(double rscp) {
    if (rscp >= -70) return statusGreen;
    if (rscp >= -85) return const Color(0xFF00897B);
    if (rscp >= -100) return statusAmber;
    return statusRed;
  }
}
