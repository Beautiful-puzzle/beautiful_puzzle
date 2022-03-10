import 'dart:convert';

import 'package:beautiful_puzzle/models/player.dart';
import 'package:json_annotation/json_annotation.dart';

part 'room_item.g.dart';

@JsonSerializable()
class RoomModel {
  RoomModel({
    required this.name,
    required this.password,
    this.players = const [],
  });

  final String name;
  final String password;

  final List<Player> players;

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return _$RoomModelFromJson(json);
  }

  Map<String, dynamic> toJson() => {
        name.toString(): _$RoomModelToJson(this),
      };
}
