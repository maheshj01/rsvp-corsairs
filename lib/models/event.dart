import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:rsvp/models/event_schema.dart';
import 'package:uuid/uuid.dart';

part 'event.g.dart';

@JsonSerializable()
class Event extends ChangeNotifier {
  String? id;
  String? name;
  String? description;
  DateTime? createdAt;
  DateTime? startsAt;
  DateTime? endsAt;
  String coverImage;
  String address;
  bool private;
  bool deleted;

  Event({
    this.id = '',
    this.name = '',
    this.description = '',
    this.createdAt,
    this.startsAt,
    this.endsAt,
    this.address = '',
    this.coverImage = '',
    this.private = false,
    this.deleted = false,
  });
  // : assert(name != null),
  //   assert(startAt = NulstartsAt!.isAfter(endsAt!) != true),
  //   assert(createdAt!.isAfter(startsAt!) != true);

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  /// todo: add created at parameter
  factory Event.copyWith(Event w) {
    return Event(
      name: w.name,
      description: w.description,
      createdAt: w.createdAt,
      startsAt: w.startsAt,
      endsAt: w.endsAt,
      address: w.address,
      coverImage: w.coverImage,
      private: w.private,
      deleted: w.deleted,
    );
  }

  // copy with constructor
  Event copyWith(
      {String? name,
      String? description,
      DateTime? createdAt,
      DateTime? startsAt,
      DateTime? endsAt,
      String? coverImage,
      String? host,
      bool? private,
      bool? deleted,
      String? address}) {
    return Event(
        id: id ?? id,
        name: name ?? this.name,
        description: description ?? this.description,
        createdAt: createdAt ?? this.createdAt,
        startsAt: startsAt ?? this.startsAt,
        endsAt: endsAt ?? this.endsAt,
        coverImage: coverImage ?? this.coverImage,
        address: address ?? this.address,
        private: private ?? this.private,
        deleted: deleted ?? this.deleted);
  }

  factory Event.init() {
    final now = DateTime.now();
    return Event(
        id: const Uuid().v4(),
        name: '',
        description: '',
        createdAt: now.subtract(const Duration(days: 1)),
        startsAt: now,
        endsAt: now.add(const Duration(days: 1)),
        coverImage: '',
        address: '',
        private: false,
        deleted: false);
  }

  factory Event.fromEventModel(EventModel model) {
    return Event(
        id: model.id,
        name: model.name,
        description: model.description,
        createdAt: model.createdAt,
        startsAt: model.startsAt,
        endsAt: model.endsAt,
        coverImage: model.coverImage,
        address: model.address,
        private: model.private,
        deleted: model.deleted);
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
