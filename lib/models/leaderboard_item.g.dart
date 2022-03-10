// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeaderboardModel _$LeaderboardModelFromJson(Map<String, dynamic> json) =>
    LeaderboardModel(
      username: json['username'] as String,
      time: json['time'] as int,
      slides: json['slides'] as int,
    );

Map<String, dynamic> _$LeaderboardModelToJson(LeaderboardModel instance) =>
    <String, dynamic>{
      'username': instance.username,
      'time': instance.time,
      'slides': instance.slides,
    };
