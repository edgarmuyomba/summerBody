// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';

class Group extends Equatable {
  final int id;
  final String name;
  final String day;

  const Group({
    required this.id,
    required this.name,
    required this.day,
  });

  Group copyWith({
    int? id,
    String? name,
    String? day,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      day: day ?? this.day,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'day': day,
    };
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      id: map['id'] as int,
      name: map['name'] as String,
      day: map['day'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Group.fromJson(String source) => Group.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, name, day];
}

class GroupTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 6, max: 32)();
  TextColumn get day => text()();
}