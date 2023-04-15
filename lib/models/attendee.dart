import 'package:rsvp/constants/const.dart';
import 'package:rsvp/models/event_schema.dart';
import 'package:rsvp/models/user.dart';

class Attendee {
  final String? id;
  final String event_id;
  final String user_id;
  final String? createdAt;
  final AttendeeStatus status;
  final UserModel user;
  final EventModel event;

  Attendee({
    this.id,
    this.status = AttendeeStatus.not_responded,
    required this.event_id,
    required this.user_id,
    this.createdAt,
    required this.user,
    required this.event,
  });

  factory Attendee.fromJson(Map<String, dynamic> json) => Attendee(
        id: json[Constants.ID_COLUMN],
        status: AttendeeStatus.fromInt(json[Constants.ATTENDEE_STATUS_COLUMN]),
        event_id: json[Constants.EVENT_ID_COLUMN],
        user_id: json[Constants.USER_ID_COLUMN],
        createdAt: json[Constants.USER_CREATED_AT_COLUMN],
        user: json.containsKey(Constants.USER_TABLE_NAME)
            ? UserModel.fromJson(json[Constants.USER_TABLE_NAME])
            : UserModel.init(),
        event: json.containsKey(Constants.EVENTS_TABLE_NAME)
            ? EventModel.basicJson(json[Constants.EVENTS_TABLE_NAME])
            : EventModel.init(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'status': status.toInt(),
        'event_id': event_id,
        'user_id': user_id,
        'created_at': createdAt,
        'user': user.toJson(),
        'event': event.toJson(),
      };
}
