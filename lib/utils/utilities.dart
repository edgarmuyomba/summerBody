import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Utilities {
  static Map<String, String> parseDate(String dateString) {
    DateTime date = DateTime.parse(dateString);
    String day = date.day.toString();
    String month = date.month.toString().padLeft(2, '0');
    String shortMonth = {
      '01': 'Jan',
      '02': 'Feb',
      '03': 'Mar',
      '04': 'Apr',
      '05': 'May',
      '06': 'Jun',
      '07': 'Jul',
      '08': 'Aug',
      '09': 'Sep',
      '10': 'Oct',
      '11': 'Nov',
      '12': 'Dec',
    }[month]!;
    return {'date': day, 'month': shortMonth};
  }

  static void showSnackBar(String message, BuildContext context, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }
}
