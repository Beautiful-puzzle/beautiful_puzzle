import 'dart:convert';

import 'package:beautiful_puzzle/models/game_card.dart';
import 'package:json_annotation/json_annotation.dart';

part 'player.g.dart';

@JsonSerializable()
class Player {
  Player({
    required this.name,
    this.movesLogs = const [],
    this.isReady = false,
  });

  final String name;

  @JsonKey(fromJson: _logsFromJson, toJson: _logsToJson)
  List<GameCardModel> movesLogs;

  //final List<Map<GameCardModel, GameCardModel>> movesLogs;

  //final List<Map<int, int>> movesLogs;

  bool isReady;

  factory Player.fromJson(Map<String, dynamic> json) {
    return _$PlayerFromJson(json);
  }

  Map<String, dynamic> toJson() => {
        name.toString(): _$PlayerToJson(this),
      };
}

String _logsToJson(List<GameCardModel> logs) =>
    jsonEncode(logs.map((e) => e.toJson()).toList());
/*String _logsToJson(List<Map<GameCardModel, GameCardModel>> logs) => logs
    .map((e) => e.map(
          (k, e) => MapEntry(jsonEncode(k.toJson()), jsonEncode(e.toJson())),
        ))
    .toList()
    .toString();*/

List<GameCardModel> _logsFromJson(String json) {
  //print(jsonDecode(json) as List<dynamic>?);
 /* (json['movesLogs'] as List<dynamic>?)
      ?.map((e) => GameCardModel.fromJson(e as Map<String, dynamic>))
      .toList()*/
  return (jsonDecode(json) as List<dynamic>?)
      ?.map((e) =>
      GameCardModel.fromJson(jsonDecode(jsonEncode(e)) as Map<String, dynamic>))
      .toList() ??
      const [];
}
