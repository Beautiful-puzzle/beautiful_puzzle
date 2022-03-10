// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomModel _$RoomModelFromJson(Map<String, dynamic> json) {
  return RoomModel(
    name: json['name'] as String,
    password: json['password'] as String,
    players: ((json['players'] as Map<String, dynamic>?)?.values.toList() as List<dynamic>?)
            ?.map((e) => Player.fromJson(e as Map<String, dynamic>))
            .toList() ??
        const [],
  );
}

Map<String, dynamic> _$RoomModelToJson(RoomModel instance) => <String, dynamic>{
      'name': instance.name,
      'password': instance.password,
      'players': instance.players,
    };
