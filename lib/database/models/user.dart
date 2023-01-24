import 'dart:convert';

class User {
  int? id;
  String? name;
  String? email;
  String? fname;
  String? path;
  String? role;
  String? schoolname;
  String? status;

  User(
      {this.id,
      this.name,
      this.email,
      this.fname,
      this.path,
      this.role,
      this.schoolname,
      this.status});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      fname: json['fname'],
      path: json['path'],
      role: json['role'],
      schoolname: json['school_name'],
      status: json['status'],
    );
  }

  static Map<String, dynamic> toMap(User model) => <String, dynamic>{
        'id': model.id,
        'name': model.name,
        'email': model.email,
        'fname': model.fname,
        'path': model.path,
        'role': model.role,
        'school_name': model.schoolname,
        'status': model.status,
      };

  static String serialize(User model) => json.encode(User.toMap(model));

  static User deserialize(String json) => User.fromJson(jsonDecode(json));
}
