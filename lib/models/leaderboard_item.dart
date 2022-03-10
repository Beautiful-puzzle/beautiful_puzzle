import 'package:json_annotation/json_annotation.dart';

part 'leaderboard_item.g.dart';

@JsonSerializable()
class LeaderboardModel {
  LeaderboardModel({
    required this.username,
    required this.time,
    required this.slides,
  });

  final String username;
  final int time;
  final int slides;

  factory LeaderboardModel.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardModelFromJson(json);

  Map<String, dynamic> toJson() => _$LeaderboardModelToJson(this);
}
