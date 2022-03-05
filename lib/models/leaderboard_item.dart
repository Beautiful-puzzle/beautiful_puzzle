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
      LeaderboardModel(
        username: json['username'] as String,
        time: json['time'] as int,
        slides: json['slides'] as int,
      );

  Map<String, dynamic> toJson() {
    final val = <String, dynamic>{};

    val['username'] = username;
    val['time'] = time;
    val['slides'] = slides;

    return val;
  }
}
