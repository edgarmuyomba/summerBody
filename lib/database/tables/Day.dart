// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';

@Entity(tableName: 'Days')
class Day extends Equatable {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String? name;
  const Day({
    this.id,
    this.name,
  });

  Day copyWith({
    int? id,
    String? name,
  }) {
    return Day(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  List<Object?> get props => [id, name];

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Day && other.id == id && other.name == name;
  }

  @override
  int get hashCode => Object.hash(id, name);
}
