import 'dart:convert';

import 'package:floor/floor.dart';

class StringMapConverter extends TypeConverter<Map<String, String?>?, String?> {
  @override
  Map<String, String?>? decode(String? databaseValue) {
    if (databaseValue == null) return null;
    final decoded = json.decode(databaseValue) as Map<String, dynamic>;
    return decoded.map((key, value) => MapEntry(key, value as String?));
  }

  @override
  String? encode(Map<String, String?>? value) {
    if (value == null) return null;
    return json.encode(value);
  }
}
