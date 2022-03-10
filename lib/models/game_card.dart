import 'package:json_annotation/json_annotation.dart';

part 'game_card.g.dart';

@JsonSerializable()
class GameCardModel {
  GameCardModel({
    required this.isEmpty,
    required this.position,
    required this.id,
  });

  final bool isEmpty;

  int position;
  final int id;

  factory GameCardModel.fromJson(Map<String, dynamic> json) =>
      _$GameCardModelFromJson(json);

  Map<String, dynamic> toJson() => _$GameCardModelToJson(this);
}
