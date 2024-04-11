import '../Services/BaseService.dart';

class UserLoginResponse implements JsonDeserializable<UserLoginResponse> {
  final bool success;
  final String token;
  final User user;
  final String message;

  UserLoginResponse({
    required this.success,
    required this.token,
    required this.user,
    required this.message,
  });

  factory UserLoginResponse.fromJson(Map<String, dynamic> json) {
    return UserLoginResponse(
      success: json['success'] ?? false,
      token: json['token'] ?? '',
      user: User.fromJson(json['user'] ?? {}),
      message: json['message'] ?? '',
    );
  }

  @override
  UserLoginResponse fromJson(Map<String, dynamic> json) {
    return UserLoginResponse.fromJson(json);
  }
}

class User implements JsonDeserializable<User> {
  final String id;
  final String name;
  final String imageName;
  final String phone;
  final String role;
  final String timestamp;
  final int v;
  final String userId;

  User({
    required this.id,
    required this.name,
    required this.imageName,
    required this.phone,
    required this.role,
    required this.timestamp,
    required this.v,
    required this.userId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'].toString() ?? '',
      name: json['name'] ?? '',
      imageName: json['imageName'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? '',
      timestamp: json['timestamp'].toString() ?? '',
      v: json['__v'] ?? 0,
      userId: json['id'] ?? '',
    );
  }

  @override
  User fromJson(Map<String, dynamic> json) {
    return User.fromJson(json);
  }
}
