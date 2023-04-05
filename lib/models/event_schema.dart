import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
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
  bool? bookmark;
  int? max_capacity;

  EventModel(
      {this.id,
      this.name,
      this.description,
      this.createdAt,
      this.startsAt,
      this.endsAt,
      this.address,
      this.max_capacity = 50,
      this.coverImage,
      this.private,
      this.deleted,
      this.attendees,
      this.host,
      this.bookmark = false});

  EventModel.init() {
    id = const Uuid().v4();
    name = '';
    description = '';
    createdAt = DateTime.now().toUtc();
    startsAt = DateTime.now().toUtc();
    endsAt = DateTime.now().toUtc();
    address = '';
    coverImage = '';
    private = false;
    deleted = false;
    attendees = [];
    max_capacity = 50;
    bookmark = false;
    host = UserModel.init();
  }

  EventModel.fromEvent(EventModel event) {
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
    max_capacity = event.max_capacity;
    bookmark = event.bookmark;
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
      bool? bookmark,
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
      bookmark: bookmark ?? this.bookmark,
      max_capacity: max_capacity ?? max_capacity,
      host: host ?? this.host,
    );
  }

  /// database schema for event table
  Map<String, dynamic> schematoJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'description': description,
        'createdAt': createdAt?.toIso8601String(),
        'startsAt': startsAt?.toIso8601String(),
        'endsAt': endsAt?.toIso8601String(),
        'coverImage': coverImage,
        'address': address,
        'private': private,
        'host': host!.id,
        'max_capacity': max_capacity,
        'deleted': deleted,
      };

  factory EventModel.fromAllSchema(Map<String, dynamic> json) => EventModel(
        id: json['id'] as String?,
        name: json['name'] as String?,
        description: json['description'] as String?,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        startsAt: json['startsAt'] == null
            ? null
            : DateTime.parse(json['startsAt'] as String),
        endsAt: json['endsAt'] == null
            ? null
            : DateTime.parse(json['endsAt'] as String),
        address: json['address'] as String?,
        coverImage: json['coverImage'] as String?,
        private: json['private'] as bool?,
        deleted: json['deleted'] as bool?,
        bookmark: json['bookmark'] ?? false,
        max_capacity: json['max_capacity'] as int?,
        attendees: (json['attendees'] as List<dynamic>?)
            ?.map((e) => UserModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        host: json['user'] == null
            ? null
            : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      );

  factory EventModel.fromBookmarks(Map<String, dynamic> json) => EventModel(
        id: json['events']['id'] as String?,
        name: json['events']['name'] as String?,
        description: json['events']['description'] as String?,
        createdAt: json['events']['createdAt'] == null
            ? null
            : DateTime.parse(json['events']['createdAt'] as String),
        startsAt: json['events']['startsAt'] == null
            ? null
            : DateTime.parse(json['events']['startsAt'] as String),
        endsAt: json['events']['endsAt'] == null
            ? null
            : DateTime.parse(json['events']['endsAt'] as String),
        address: json['events']['address'] as String?,
        coverImage: json['events']['coverImage'] as String?,
        private: json['events']['private'] as bool?,
        deleted: json['events']['deleted'] as bool?,
        bookmark: json['events']['bookmark'] ?? false,
        max_capacity: json['events']['max_capacity'] as int?,
        attendees: (json['events']['attendees'] as List<dynamic>?)
            ?.map((e) => UserModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        host: json['events']['user'] == null
            ? json['user'] == null
                ? null
                : UserModel.fromJson(json['user'] as Map<String, dynamic>)
            : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EventModel &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.createdAt == createdAt &&
        other.startsAt == startsAt &&
        other.endsAt == endsAt &&
        other.coverImage == coverImage &&
        other.address == address &&
        other.private == private &&
        other.deleted == deleted &&
        other.attendees == attendees &&
        other.max_capacity == max_capacity &&
        other.host == host;
  }

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$EventModelToJson(this);
}
