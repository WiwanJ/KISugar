import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserApiMedel {
  final String name;
  final String email;
  final String password;
  final String fuidstr;
  final String bod;
  final String picurl; 
  UserApiMedel({
    required this.name,
    required this.email,
    required this.password,
    required this.fuidstr,
    required this.bod,
    required this.picurl,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'password': password,
      'fuidstr': fuidstr,
      'bod': bod,
      'picurl': picurl,
    };
  }

  factory UserApiMedel.fromMap(Map<String, dynamic> map) {
    return UserApiMedel(
      name: map['name'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      fuidstr: map['fuidstr'] as String,
      bod: map['bod'] as String,
      picurl: map['picurl'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserApiMedel.fromJson(String source) => UserApiMedel.fromMap(json.decode(source) as Map<String, dynamic>);
}
