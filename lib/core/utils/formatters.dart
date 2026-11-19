import 'package:intl/intl.dart';

class Formatters {
  static final DateFormat _timeFormat = DateFormat('HH:mm:ss');
  static final DateFormat _dateTimeFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

  static String formatTime(DateTime dt) => _timeFormat.format(dt);
  static String formatDateTime(DateTime dt) => _dateTimeFormat.format(dt);

  static String formatKbpsToMbps(double kbps) {
    if (kbps >= 1000) {
      return '${(kbps / 1000.0).toStringAsFixed(2)} Mbps';
    }
    return '${kbps.toStringAsFixed(0)} kbps';
  }
}
