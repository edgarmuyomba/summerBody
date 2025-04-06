// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:SummerBody/database/tables/Workout.dart';
import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';

class Entry extends Equatable {
  final int id;
  final int workout;
  final int weight;
  final int sets;
  final int reps;
  final DateTime date;
  const Entry({
    required this.id,
    required this.workout,
    required this.weight,
    required this.sets,
    required this.reps,
    required this.date,
  });

  Entry copyWith({
    int? id,
    int? workout,
    int? weight,
    int? sets,
    int? reps,
    DateTime? date,
  }) {
    return Entry(
      id: id ?? this.id,
      workout: workout ?? this.workout,
      weight: weight ?? this.weight,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'workout': workout,
      'weight': weight,
      'sets': sets,
      'reps': reps,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory Entry.fromMap(Map<String, dynamic> map) {
    return Entry(
      id: map['id'] as int,
      workout: map['workout'] as int,
      weight: map['weight'] as int,
      sets: map['sets'] as int,
      reps: map['reps'] as int,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Entry.fromJson(String source) => Entry.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      workout,
      weight,
      sets,
      reps,
      date,
    ];
  }
}

class EntryTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get workout => integer().references(WorkoutTable, #id)();
  IntColumn get weight => integer()();
  IntColumn get sets => integer()();
  IntColumn get reps => integer()();
  DateTimeColumn get date => dateTime().withDefault(currentDateAndTime)();
}