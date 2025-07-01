// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class SyncState extends Equatable {
  final bool isSyncing;
  final double syncProgress;
  final bool active;
  const SyncState({
    required this.isSyncing,
    required this.syncProgress,
    required this.active,
  });

  SyncState copyWith({
    bool? isSyncing,
    double? syncProgress,
    bool? active,
  }) {
    return SyncState(
      isSyncing: isSyncing ?? this.isSyncing,
      syncProgress: syncProgress ?? this.syncProgress,
      active: active ?? this.active,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isSyncing': isSyncing,
      'syncProgress': syncProgress,
      'active': active,
    };
  }

  factory SyncState.fromMap(Map<String, dynamic> map) {
    return SyncState(
      isSyncing: map['isSyncing'] as bool,
      syncProgress: map['syncProgress'] as double,
      active: map['active'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory SyncState.fromJson(String source) =>
      SyncState.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [isSyncing, syncProgress, active];
}
