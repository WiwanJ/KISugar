// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ResponModel {
  final bool success;
  final String message;
  final int total;
  ResponModel({
    required this.success,
    required this.message,
    required this.total,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'success': success,
      'message': message,
      'total': total,
    };
  }

  factory ResponModel.fromMap(Map<String, dynamic> map) {
    return ResponModel(
      success: map['success'] as bool,
      message: map['message'] as String,
      total: map['total'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ResponModel.fromJson(String source) => ResponModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
