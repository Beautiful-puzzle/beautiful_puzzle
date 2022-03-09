class RoomModel {
  RoomModel({
    required this.name,
    required this.password,
  });

  final String name;
  final String password;

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      name: json['name'] as String,
      password: json['password'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      name.toString(): {
        'name': name.toString(),
        'password': password.toString(),
      },
    };
  }
}
