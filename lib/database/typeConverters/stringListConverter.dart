import 'dart:convert';

import 'package:floor/floor.dart';

class StringListConverter extends TypeConverter<List<String>?, String?> {
  @override
  List<String>? decode(String? databaseValue) {
    if (databaseValue == null) return null;
    return List<String>.from(json.decode(databaseValue));
  }

  @override
  String? encode(List<String>? value) {
    if (value == null) return null;
    return json.encode(value);
  }
}

