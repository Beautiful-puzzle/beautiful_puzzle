// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameCardModel _$GameCardModelFromJson(Map<String, dynamic> json) =>
    GameCardModel(
      isEmpty: json['isEmpty'] as bool,
      position: json['position'] as int,
      id: json['id'] as int,
    );

Map<String, dynamic> _$GameCardModelToJson(GameCardModel instance) =>
    <String, dynamic>{
      'isEmpty': instance.isEmpty,
      'position': instance.position,
      'id': instance.id,
    };
