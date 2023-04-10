import 'package:intl/intl.dart';

class Utils {
  static final formatter = DateFormat('yyyy-MM-dd hh:mm:ss');
  static String get currentDateTime {
    final DateTime now = DateTime.now();
    return formatter.format(now);
  }
}
