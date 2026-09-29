import 'package:easy_localization/easy_localization.dart';

extension DateTimeExtension on DateTime {
  String get weekdayName {
    final name = DateFormat('EEEE').format(this);
    return "${name[0].toUpperCase()}${name.substring(1)}";
  }

  String get weekdayShortName {
    final short = DateFormat('EEE').format(this);
    return "${short[0].toUpperCase()}${short.substring(1)}";
  }

  String get monthName => DateFormat('MMMM').format(this);

  String get monthShortName => DateFormat('MMM').format(this);
}
