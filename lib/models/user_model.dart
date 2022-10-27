import 'dart:convert';

class UserModel {
  final String profilePic;
  final String email;
  final String name;
  final String token;
  final String uid;

  UserModel({
    required this.profilePic,
    required this.email,
    required this.name,
    required this.token,
    required this.uid,
  });

  UserModel copyWith({
    String? profilePic,
    String? email,
    String? name,
    String? token,
    String? uid,
  }) =>
      UserModel(
        profilePic: profilePic ?? this.profilePic,
        email: email ?? this.email,
        token: token ?? this.token,
        uid: uid ?? this.email,
        name: name ?? this.name,
      );

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'profilePic': profilePic,
      'uid': uid,
      'token': token,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      profilePic: map['profilePic'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      token: map['token'] ?? '',
      uid: map['_id'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(jsonDecode(source));
}
