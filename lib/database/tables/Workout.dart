// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:SummerBody/database/tables/Group.dart';
import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';

class Workout extends Equatable {
  final int id;
  final String name;
  final int group;
  const Workout({
    required this.id,
    required this.name,
    required this.group,
  });

  Workout copyWith({
    int? id,
    String? name,
    int? group,
  }) {
    return Workout(
      id: id ?? this.id,
      name: name ?? this.name,
      group: group ?? this.group,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'group': group,
    };
  }

  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      id: map['id'] as int,
      name: map['name'] as String,
      group: map['group'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Workout.fromJson(String source) => Workout.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, name, group];
}

class WorkoutTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 6, max: 32)();
  IntColumn get group => integer().references(GroupTable, #id)();
}