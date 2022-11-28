import 'package:rsvp/models/user.dart';

class ReportModel {
  final String? id;
  final UserModel user;
  final String description;
  final DateTime createdAt;

  ReportModel({
    this.id,
    required this.user,
    required this.description,
    required this.createdAt,
  });
  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'],
      user: UserModel.fromJson(json['user']),
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  ReportModel.copyWith({
    required this.id,
    required this.user,
    required this.description,
    required this.createdAt,
  });

  Map<String, dynamic> toJsonSchema() {
    return {
      'id': id,
      'user_id': user.id,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
