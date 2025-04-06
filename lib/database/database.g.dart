// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $GroupTableTable extends GroupTable
    with TableInfo<$GroupTableTable, GroupTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 6, maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<String> day = GeneratedColumn<String>(
      'day', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, day];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'group_table';
  @override
  VerificationContext validateIntegrity(Insertable<GroupTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('day')) {
      context.handle(
          _dayMeta, day.isAcceptableOrUnknown(data['day']!, _dayMeta));
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GroupTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GroupTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      day: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}day'])!,
    );
  }

  @override
  $GroupTableTable createAlias(String alias) {
    return $GroupTableTable(attachedDatabase, alias);
  }
}

class GroupTableData extends DataClass implements Insertable<GroupTableData> {
  final int id;
  final String name;
  final String day;
  const GroupTableData(
      {required this.id, required this.name, required this.day});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['day'] = Variable<String>(day);
    return map;
  }

  GroupTableCompanion toCompanion(bool nullToAbsent) {
    return GroupTableCompanion(
      id: Value(id),
      name: Value(name),
      day: Value(day),
    );
  }

  factory GroupTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GroupTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      day: serializer.fromJson<String>(json['day']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'day': serializer.toJson<String>(day),
    };
  }

  GroupTableData copyWith({int? id, String? name, String? day}) =>
      GroupTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        day: day ?? this.day,
      );
  GroupTableData copyWithCompanion(GroupTableCompanion data) {
    return GroupTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      day: data.day.present ? data.day.value : this.day,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GroupTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('day: $day')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, day);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroupTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.day == this.day);
}

class GroupTableCompanion extends UpdateCompanion<GroupTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> day;
  const GroupTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.day = const Value.absent(),
  });
  GroupTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String day,
  })  : name = Value(name),
        day = Value(day);
  static Insertable<GroupTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? day,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (day != null) 'day': day,
    });
  }

  GroupTableCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<String>? day}) {
    return GroupTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      day: day ?? this.day,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (day.present) {
      map['day'] = Variable<String>(day.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('day: $day')
          ..write(')'))
        .toString();
  }
}

class $WorkoutTableTable extends WorkoutTable
    with TableInfo<$WorkoutTableTable, WorkoutTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 6, maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _groupMeta = const VerificationMeta('group');
  @override
  late final GeneratedColumn<int> group = GeneratedColumn<int>(
      'group', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES group_table (id)'));
  @override
  List<GeneratedColumn> get $columns => [id, name, group];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_table';
  @override
  VerificationContext validateIntegrity(Insertable<WorkoutTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('group')) {
      context.handle(
          _groupMeta, group.isAcceptableOrUnknown(data['group']!, _groupMeta));
    } else if (isInserting) {
      context.missing(_groupMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      group: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}group'])!,
    );
  }

  @override
  $WorkoutTableTable createAlias(String alias) {
    return $WorkoutTableTable(attachedDatabase, alias);
  }
}

class WorkoutTableData extends DataClass
    implements Insertable<WorkoutTableData> {
  final int id;
  final String name;
  final int group;
  const WorkoutTableData(
      {required this.id, required this.name, required this.group});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['group'] = Variable<int>(group);
    return map;
  }

  WorkoutTableCompanion toCompanion(bool nullToAbsent) {
    return WorkoutTableCompanion(
      id: Value(id),
      name: Value(name),
      group: Value(group),
    );
  }

  factory WorkoutTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      group: serializer.fromJson<int>(json['group']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'group': serializer.toJson<int>(group),
    };
  }

  WorkoutTableData copyWith({int? id, String? name, int? group}) =>
      WorkoutTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        group: group ?? this.group,
      );
  WorkoutTableData copyWithCompanion(WorkoutTableCompanion data) {
    return WorkoutTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      group: data.group.present ? data.group.value : this.group,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('group: $group')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, group);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.group == this.group);
}

class WorkoutTableCompanion extends UpdateCompanion<WorkoutTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> group;
  const WorkoutTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.group = const Value.absent(),
  });
  WorkoutTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int group,
  })  : name = Value(name),
        group = Value(group);
  static Insertable<WorkoutTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? group,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (group != null) 'group': group,
    });
  }

  WorkoutTableCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<int>? group}) {
    return WorkoutTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      group: group ?? this.group,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (group.present) {
      map['group'] = Variable<int>(group.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('group: $group')
          ..write(')'))
        .toString();
  }
}

class $EntryTableTable extends EntryTable
    with TableInfo<$EntryTableTable, EntryTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EntryTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _workoutMeta =
      const VerificationMeta('workout');
  @override
  late final GeneratedColumn<int> workout = GeneratedColumn<int>(
      'workout', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES workout_table (id)'));
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<int> weight = GeneratedColumn<int>(
      'weight', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _setsMeta = const VerificationMeta('sets');
  @override
  late final GeneratedColumn<int> sets = GeneratedColumn<int>(
      'sets', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
      'reps', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, workout, weight, sets, reps, date];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'entry_table';
  @override
  VerificationContext validateIntegrity(Insertable<EntryTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('workout')) {
      context.handle(_workoutMeta,
          workout.isAcceptableOrUnknown(data['workout']!, _workoutMeta));
    } else if (isInserting) {
      context.missing(_workoutMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(_weightMeta,
          weight.isAcceptableOrUnknown(data['weight']!, _weightMeta));
    } else if (isInserting) {
      context.missing(_weightMeta);
    }
    if (data.containsKey('sets')) {
      context.handle(
          _setsMeta, sets.isAcceptableOrUnknown(data['sets']!, _setsMeta));
    } else if (isInserting) {
      context.missing(_setsMeta);
    }
    if (data.containsKey('reps')) {
      context.handle(
          _repsMeta, reps.isAcceptableOrUnknown(data['reps']!, _repsMeta));
    } else if (isInserting) {
      context.missing(_repsMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EntryTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EntryTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      workout: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}workout'])!,
      weight: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}weight'])!,
      sets: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sets'])!,
      reps: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reps'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
    );
  }

  @override
  $EntryTableTable createAlias(String alias) {
    return $EntryTableTable(attachedDatabase, alias);
  }
}

class EntryTableData extends DataClass implements Insertable<EntryTableData> {
  final int id;
  final int workout;
  final int weight;
  final int sets;
  final int reps;
  final DateTime date;
  const EntryTableData(
      {required this.id,
      required this.workout,
      required this.weight,
      required this.sets,
      required this.reps,
      required this.date});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['workout'] = Variable<int>(workout);
    map['weight'] = Variable<int>(weight);
    map['sets'] = Variable<int>(sets);
    map['reps'] = Variable<int>(reps);
    map['date'] = Variable<DateTime>(date);
    return map;
  }

  EntryTableCompanion toCompanion(bool nullToAbsent) {
    return EntryTableCompanion(
      id: Value(id),
      workout: Value(workout),
      weight: Value(weight),
      sets: Value(sets),
      reps: Value(reps),
      date: Value(date),
    );
  }

  factory EntryTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EntryTableData(
      id: serializer.fromJson<int>(json['id']),
      workout: serializer.fromJson<int>(json['workout']),
      weight: serializer.fromJson<int>(json['weight']),
      sets: serializer.fromJson<int>(json['sets']),
      reps: serializer.fromJson<int>(json['reps']),
      date: serializer.fromJson<DateTime>(json['date']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'workout': serializer.toJson<int>(workout),
      'weight': serializer.toJson<int>(weight),
      'sets': serializer.toJson<int>(sets),
      'reps': serializer.toJson<int>(reps),
      'date': serializer.toJson<DateTime>(date),
    };
  }

  EntryTableData copyWith(
          {int? id,
          int? workout,
          int? weight,
          int? sets,
          int? reps,
          DateTime? date}) =>
      EntryTableData(
        id: id ?? this.id,
        workout: workout ?? this.workout,
        weight: weight ?? this.weight,
        sets: sets ?? this.sets,
        reps: reps ?? this.reps,
        date: date ?? this.date,
      );
  EntryTableData copyWithCompanion(EntryTableCompanion data) {
    return EntryTableData(
      id: data.id.present ? data.id.value : this.id,
      workout: data.workout.present ? data.workout.value : this.workout,
      weight: data.weight.present ? data.weight.value : this.weight,
      sets: data.sets.present ? data.sets.value : this.sets,
      reps: data.reps.present ? data.reps.value : this.reps,
      date: data.date.present ? data.date.value : this.date,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EntryTableData(')
          ..write('id: $id, ')
          ..write('workout: $workout, ')
          ..write('weight: $weight, ')
          ..write('sets: $sets, ')
          ..write('reps: $reps, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, workout, weight, sets, reps, date);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EntryTableData &&
          other.id == this.id &&
          other.workout == this.workout &&
          other.weight == this.weight &&
          other.sets == this.sets &&
          other.reps == this.reps &&
          other.date == this.date);
}

class EntryTableCompanion extends UpdateCompanion<EntryTableData> {
  final Value<int> id;
  final Value<int> workout;
  final Value<int> weight;
  final Value<int> sets;
  final Value<int> reps;
  final Value<DateTime> date;
  const EntryTableCompanion({
    this.id = const Value.absent(),
    this.workout = const Value.absent(),
    this.weight = const Value.absent(),
    this.sets = const Value.absent(),
    this.reps = const Value.absent(),
    this.date = const Value.absent(),
  });
  EntryTableCompanion.insert({
    this.id = const Value.absent(),
    required int workout,
    required int weight,
    required int sets,
    required int reps,
    this.date = const Value.absent(),
  })  : workout = Value(workout),
        weight = Value(weight),
        sets = Value(sets),
        reps = Value(reps);
  static Insertable<EntryTableData> custom({
    Expression<int>? id,
    Expression<int>? workout,
    Expression<int>? weight,
    Expression<int>? sets,
    Expression<int>? reps,
    Expression<DateTime>? date,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workout != null) 'workout': workout,
      if (weight != null) 'weight': weight,
      if (sets != null) 'sets': sets,
      if (reps != null) 'reps': reps,
      if (date != null) 'date': date,
    });
  }

  EntryTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? workout,
      Value<int>? weight,
      Value<int>? sets,
      Value<int>? reps,
      Value<DateTime>? date}) {
    return EntryTableCompanion(
      id: id ?? this.id,
      workout: workout ?? this.workout,
      weight: weight ?? this.weight,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      date: date ?? this.date,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (workout.present) {
      map['workout'] = Variable<int>(workout.value);
    }
    if (weight.present) {
      map['weight'] = Variable<int>(weight.value);
    }
    if (sets.present) {
      map['sets'] = Variable<int>(sets.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EntryTableCompanion(')
          ..write('id: $id, ')
          ..write('workout: $workout, ')
          ..write('weight: $weight, ')
          ..write('sets: $sets, ')
          ..write('reps: $reps, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $GroupTableTable groupTable = $GroupTableTable(this);
  late final $WorkoutTableTable workoutTable = $WorkoutTableTable(this);
  late final $EntryTableTable entryTable = $EntryTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [groupTable, workoutTable, entryTable];
}

typedef $$GroupTableTableCreateCompanionBuilder = GroupTableCompanion Function({
  Value<int> id,
  required String name,
  required String day,
});
typedef $$GroupTableTableUpdateCompanionBuilder = GroupTableCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> day,
});

class $$GroupTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GroupTableTable,
    GroupTableData,
    $$GroupTableTableFilterComposer,
    $$GroupTableTableOrderingComposer,
    $$GroupTableTableCreateCompanionBuilder,
    $$GroupTableTableUpdateCompanionBuilder> {
  $$GroupTableTableTableManager(_$AppDatabase db, $GroupTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$GroupTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$GroupTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> day = const Value.absent(),
          }) =>
              GroupTableCompanion(
            id: id,
            name: name,
            day: day,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String day,
          }) =>
              GroupTableCompanion.insert(
            id: id,
            name: name,
            day: day,
          ),
        ));
}

class $$GroupTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $GroupTableTable> {
  $$GroupTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get day => $state.composableBuilder(
      column: $state.table.day,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter workoutTableRefs(
      ComposableFilter Function($$WorkoutTableTableFilterComposer f) f) {
    final $$WorkoutTableTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.workoutTable,
        getReferencedColumn: (t) => t.group,
        builder: (joinBuilder, parentComposers) =>
            $$WorkoutTableTableFilterComposer(ComposerState($state.db,
                $state.db.workoutTable, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$GroupTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $GroupTableTable> {
  $$GroupTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get day => $state.composableBuilder(
      column: $state.table.day,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$WorkoutTableTableCreateCompanionBuilder = WorkoutTableCompanion
    Function({
  Value<int> id,
  required String name,
  required int group,
});
typedef $$WorkoutTableTableUpdateCompanionBuilder = WorkoutTableCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<int> group,
});

class $$WorkoutTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WorkoutTableTable,
    WorkoutTableData,
    $$WorkoutTableTableFilterComposer,
    $$WorkoutTableTableOrderingComposer,
    $$WorkoutTableTableCreateCompanionBuilder,
    $$WorkoutTableTableUpdateCompanionBuilder> {
  $$WorkoutTableTableTableManager(_$AppDatabase db, $WorkoutTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$WorkoutTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$WorkoutTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> group = const Value.absent(),
          }) =>
              WorkoutTableCompanion(
            id: id,
            name: name,
            group: group,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required int group,
          }) =>
              WorkoutTableCompanion.insert(
            id: id,
            name: name,
            group: group,
          ),
        ));
}

class $$WorkoutTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $WorkoutTableTable> {
  $$WorkoutTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$GroupTableTableFilterComposer get group {
    final $$GroupTableTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.group,
        referencedTable: $state.db.groupTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$GroupTableTableFilterComposer(ComposerState($state.db,
                $state.db.groupTable, joinBuilder, parentComposers)));
    return composer;
  }

  ComposableFilter entryTableRefs(
      ComposableFilter Function($$EntryTableTableFilterComposer f) f) {
    final $$EntryTableTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.entryTable,
        getReferencedColumn: (t) => t.workout,
        builder: (joinBuilder, parentComposers) =>
            $$EntryTableTableFilterComposer(ComposerState($state.db,
                $state.db.entryTable, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$WorkoutTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $WorkoutTableTable> {
  $$WorkoutTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$GroupTableTableOrderingComposer get group {
    final $$GroupTableTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.group,
        referencedTable: $state.db.groupTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$GroupTableTableOrderingComposer(ComposerState($state.db,
                $state.db.groupTable, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$EntryTableTableCreateCompanionBuilder = EntryTableCompanion Function({
  Value<int> id,
  required int workout,
  required int weight,
  required int sets,
  required int reps,
  Value<DateTime> date,
});
typedef $$EntryTableTableUpdateCompanionBuilder = EntryTableCompanion Function({
  Value<int> id,
  Value<int> workout,
  Value<int> weight,
  Value<int> sets,
  Value<int> reps,
  Value<DateTime> date,
});

class $$EntryTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EntryTableTable,
    EntryTableData,
    $$EntryTableTableFilterComposer,
    $$EntryTableTableOrderingComposer,
    $$EntryTableTableCreateCompanionBuilder,
    $$EntryTableTableUpdateCompanionBuilder> {
  $$EntryTableTableTableManager(_$AppDatabase db, $EntryTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$EntryTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$EntryTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> workout = const Value.absent(),
            Value<int> weight = const Value.absent(),
            Value<int> sets = const Value.absent(),
            Value<int> reps = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
          }) =>
              EntryTableCompanion(
            id: id,
            workout: workout,
            weight: weight,
            sets: sets,
            reps: reps,
            date: date,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int workout,
            required int weight,
            required int sets,
            required int reps,
            Value<DateTime> date = const Value.absent(),
          }) =>
              EntryTableCompanion.insert(
            id: id,
            workout: workout,
            weight: weight,
            sets: sets,
            reps: reps,
            date: date,
          ),
        ));
}

class $$EntryTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $EntryTableTable> {
  $$EntryTableTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get weight => $state.composableBuilder(
      column: $state.table.weight,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get sets => $state.composableBuilder(
      column: $state.table.sets,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get reps => $state.composableBuilder(
      column: $state.table.reps,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get date => $state.composableBuilder(
      column: $state.table.date,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$WorkoutTableTableFilterComposer get workout {
    final $$WorkoutTableTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.workout,
        referencedTable: $state.db.workoutTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$WorkoutTableTableFilterComposer(ComposerState($state.db,
                $state.db.workoutTable, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$EntryTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $EntryTableTable> {
  $$EntryTableTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get weight => $state.composableBuilder(
      column: $state.table.weight,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get sets => $state.composableBuilder(
      column: $state.table.sets,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get reps => $state.composableBuilder(
      column: $state.table.reps,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get date => $state.composableBuilder(
      column: $state.table.date,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$WorkoutTableTableOrderingComposer get workout {
    final $$WorkoutTableTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.workout,
        referencedTable: $state.db.workoutTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$WorkoutTableTableOrderingComposer(ComposerState($state.db,
                $state.db.workoutTable, joinBuilder, parentComposers)));
    return composer;
  }
}

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$GroupTableTableTableManager get groupTable =>
      $$GroupTableTableTableManager(_db, _db.groupTable);
  $$WorkoutTableTableTableManager get workoutTable =>
      $$WorkoutTableTableTableManager(_db, _db.workoutTable);
  $$EntryTableTableTableManager get entryTable =>
      $$EntryTableTableTableManager(_db, _db.entryTable);
}
