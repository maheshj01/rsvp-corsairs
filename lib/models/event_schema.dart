import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:rsvp/models/event.dart';
import 'package:rsvp/models/user.dart';
import 'package:uuid/uuid.dart';

part 'event_schema.g.dart';

// Class for the event table in the database
// with two additional fields: attendees and host
@JsonSerializable()
class EventModel extends ChangeNotifier {
  List<UserModel>? attendees;
  UserModel? host;
  String? id;
  String? name;
  String? description;
  DateTime? createdAt;
  DateTime? startsAt;
  DateTime? endsAt;
  String? coverImage;
  String? address;
  bool? private;
  bool? deleted;

  EventModel({
    this.id,
    this.name,
    this.description,
    this.createdAt,
    this.startsAt,
    this.endsAt,
    this.address,
    this.coverImage,
    this.private,
    this.deleted,
    this.attendees,
    this.host,
  });

  EventModel.init() {
    id = const Uuid().v4();
    name = '';
    description = '';
    createdAt = DateTime.now();
    startsAt = DateTime.now();
    endsAt = DateTime.now();
    address = '';
    coverImage = '';
    private = false;
    deleted = false;
    attendees = [];
    host = UserModel.init();
  }

  EventModel.fromEvent(Event event) {
    id = event.id;
    name = event.name;
    description = event.description;
    createdAt = event.createdAt;
    startsAt = event.startsAt;
    endsAt = event.endsAt;
    address = event.address;
    coverImage = event.coverImage;
    private = event.private;
    deleted = event.deleted;
    attendees = [];
    host = UserModel.init();
  }

  // copy with constructor
  EventModel copyWith(
      {String? id,
      String? name,
      String? description,
      DateTime? createdAt,
      DateTime? startsAt,
      DateTime? endsAt,
      String? address,
      String? coverImage,
      bool? private,
      bool? deleted,
      List<UserModel>? attendees,
      UserModel? host}) {
    return EventModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      startsAt: startsAt ?? this.startsAt,
      endsAt: endsAt ?? this.endsAt,
      address: address ?? this.address,
      coverImage: coverImage ?? this.coverImage,
      private: private ?? this.private,
      deleted: deleted ?? this.deleted,
      attendees: attendees ?? this.attendees,
      host: host ?? this.host,
    );
  }

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$EventModelToJson(this);
}
