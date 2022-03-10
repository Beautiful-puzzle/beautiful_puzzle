// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Player _$PlayerFromJson(Map<String, dynamic> json) => Player(
      name: json['name'] as String,
      movesLogs: json['movesLogs'] == null
          ? const []
          : _logsFromJson(json['movesLogs'] as String),
      isReady: json['isReady'] as bool? ?? false,
    );

Map<String, dynamic> _$PlayerToJson(Player instance) => <String, dynamic>{
      'name': instance.name,
      'movesLogs': _logsToJson(instance.movesLogs),
      'isReady': instance.isReady,
    };
