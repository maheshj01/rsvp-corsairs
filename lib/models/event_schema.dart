import 'package:json_annotation/json_annotation.dart';
import 'package:rsvp/models/event.dart';
import 'package:rsvp/models/user.dart';
import 'package:uuid/uuid.dart';

part 'event_schema.g.dart';

// Class for the event table in the database
// with two additional fields: attendees and host
@JsonSerializable()
class EventModel extends Event {
  List<UserModel>? attendees;
  UserModel? host;

  EventModel({
    super.id,
    super.name,
    super.description,
    super.createdAt,
    super.startsAt,
    super.endsAt,
    super.address,
    super.coverImage,
    super.private,
    super.deleted,
    this.attendees,
    this.host,
  });

  EventModel.init() {
    super.id = const Uuid().v4();
    super.name = '';
    super.description = '';
    super.createdAt = DateTime.now();
    super.startsAt = DateTime.now();
    super.endsAt = DateTime.now();
    super.address = '';
    super.coverImage = '';
    super.private = false;
    super.deleted = false;
    attendees = [];
    host = UserModel.init();
  }

  EventModel.fromEvent(Event event) {
    super.id = event.id;
    super.name = event.name;
    super.description = event.description;
    super.createdAt = event.createdAt;
    super.startsAt = event.startsAt;
    super.endsAt = event.endsAt;
    super.address = event.address;
    super.coverImage = event.coverImage;
    super.private = event.private;
    super.deleted = event.deleted;
    attendees = [];
    host = UserModel.init();
  }

  // copy with constructor
  EventModel copy(
      {String? id,
      String? name,
      String? description,
      List<UserModel>? attendees,
      DateTime? createdAt,
      DateTime? startsAt,
      DateTime? endsAt,
      String? address,
      String? coverImage,
      bool? private,
      bool? deleted,
      UserModel? host}) {
    return EventModel(
      id: id ?? id,
      name: name ?? name,
      description: description ?? description,
      createdAt: createdAt ?? createdAt,
      startsAt: startsAt ?? startsAt,
      endsAt: endsAt ?? endsAt,
      address: address ?? address!,
      coverImage: coverImage ?? coverImage!,
      private: private ?? private!,
      deleted: deleted ?? deleted!,
      attendees: attendees ?? attendees,
      host: host ?? host,
    );
  }

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$EventModelToJson(this);
}
