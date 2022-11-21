import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:rsvp/models/user.dart';

part 'event.g.dart';

@JsonSerializable()
class Event extends ChangeNotifier {
  String? id;
  String? name;
  String? description;
  List<UserModel> attendees;
  DateTime? createdAt;
  DateTime? startsAt;
  DateTime? endsAt;
  String coverImage;
  String host;

  Event(
      {this.name = '',
      this.description = '',
      this.attendees = const [],
      this.createdAt,
      this.startsAt,
      this.endsAt,
      this.coverImage = '',
      this.host = ''});
  // : assert(name != null),
  //   assert(startAt = NulstartsAt!.isAfter(endsAt!) != true),
  //   assert(createdAt!.isAfter(startsAt!) != true);

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  /// todo: add created at parameter
  factory Event.copyWith(Event w) {
    return Event(
        name: w.name,
        description: w.description,
        attendees: w.attendees,
        createdAt: w.createdAt,
        startsAt: w.startsAt,
        endsAt: w.endsAt,
        coverImage: w.coverImage,
        host: w.host);
  }

  // copy with constructor
  Event copyWith({
    String? name,
    String? description,
    List<UserModel>? attendees,
    DateTime? createdAt,
    DateTime? startsAt,
    DateTime? endsAt,
    String? coverImage,
    String? host,
  }) {
    return Event(
        name: name ?? this.name,
        description: description ?? this.description,
        attendees: attendees ?? this.attendees,
        createdAt: createdAt ?? this.createdAt,
        startsAt: startsAt ?? this.startsAt,
        endsAt: endsAt ?? this.endsAt,
        coverImage: coverImage ?? this.coverImage,
        host: host ?? this.host);
  }

  factory Event.init() {
    final now = DateTime.now();
    return Event(
        name: '',
        description: '',
        attendees: [],
        createdAt: now.subtract(const Duration(days: 1)),
        startsAt: now,
        endsAt: now.add(const Duration(days: 1)),
        coverImage: '',
        host: '');
  }

  //  TODO: add a method to convert a User to JSON object
//  Map<String, dynamic> toJson() => {
//         'id': id,
//         'email': email,
//         'created_at': createdAt,
//         'last_sign_in_at': lastSignInAt,
//         'updated_at': updatedAt,
//       };

  Map<String, dynamic> toJson() => _$EventToJson(this);
}
