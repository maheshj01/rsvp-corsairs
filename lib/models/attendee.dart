import 'package:rsvp/constants/const.dart';
import 'package:rsvp/models/event_schema.dart';
import 'package:rsvp/models/user.dart';

class Attendee {
  final String? id;
  final String event_id;
  final String user_id;
  final String? createdAt;
  final UserModel user;
  final EventModel event;

  Attendee({
    this.id,
    required this.event_id,
    required this.user_id,
    this.createdAt,
    required this.user,
    required this.event,
  });

  factory Attendee.fromJson(Map<String, dynamic> json) => Attendee(
        id: json['id'],
        event_id: json['event_id'],
        user_id: json['user_id'],
        createdAt: json['created_at'],
        user: UserModel.fromJson(json[Constants.USER_TABLE_NAME]),
        event: EventModel.basicJson(json[Constants.EVENTS_TABLE_NAME]),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'event_id': event_id,
        'user_id': user_id,
        'created_at': createdAt,
        'user': user.toJson(),
        'event': event.toJson(),
      };
}
