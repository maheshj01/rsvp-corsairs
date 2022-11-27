import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:rsvp/models/event.dart';
import 'package:uuid/uuid.dart';

part 'user.g.dart';

@JsonSerializable()
class UserModel extends ChangeNotifier {
  String? id;
  String? idToken;
  String? accessToken;
  // events hosted or attended by user
  List<Event> events;
  List<Event> interested;
  String email;
  String name;
  String? avatarUrl;
  bool isLoggedIn;
  bool isAdmin;
  String username;
  String password;
  String studentId;
  DateTime? created_at;

  UserModel(
      {this.id,
      this.name = '',
      this.email = '',
      this.avatarUrl,
      this.idToken,
      this.isAdmin = false,
      this.accessToken,
      this.username = '',
      this.created_at,
      this.studentId = '',
      this.password = '',
      this.isLoggedIn = false,
      this.interested = const [],
      this.events = const []});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// todo: add created at parameter
  factory UserModel.copyWith(UserModel w) {
    return UserModel(
        name: w.name,
        email: w.email,
        avatarUrl: w.avatarUrl,
        idToken: w.idToken,
        accessToken: w.accessToken,
        isAdmin: w.isAdmin,
        username: w.username,
        password: w.password,
        studentId: w.studentId,
        created_at: w.created_at,
        isLoggedIn: w.isLoggedIn,
        interested: w.interested,
        events: w.events);
  }
  factory UserModel.schema(UserModel w) {
    return UserModel(
      name: w.name,
      email: w.email,
      avatarUrl: w.avatarUrl,
      idToken: w.idToken,
      accessToken: w.accessToken,
      isAdmin: w.isAdmin,
      username: w.username,
      password: w.password,
      studentId: w.studentId,
      created_at: w.created_at,
      isLoggedIn: w.isLoggedIn,
      interested: w.interested,
    );
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? avatarUrl,
    String? idToken,
    String? accessToken,
    bool? isAdmin,
    bool? isLoggedIn,
    String? username,
    String? password,
    String? studentId,
    DateTime? created_at,
    List<Event>? interested,
    List<Event>? events,
  }) {
    return UserModel(
        name: name ?? this.name,
        email: email ?? this.email,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        idToken: idToken ?? this.idToken,
        accessToken: accessToken ?? this.accessToken,
        isAdmin: isAdmin ?? this.isAdmin,
        username: username ?? this.username,
        password: password ?? this.password,
        studentId: studentId ?? this.studentId,
        created_at: created_at ?? this.created_at,
        isLoggedIn: isLoggedIn ?? this.isLoggedIn,
        interested: interested ?? this.interested,
        events: events ?? this.events);
  }

  factory UserModel.init({String email = '', String name = ''}) {
    final now = DateTime.now();
    return UserModel(
        name: name,
        email: email,
        avatarUrl: '',
        idToken: '',
        accessToken: '',
        events: [],
        interested: [],
        created_at: now,
        username: '',
        password: '',
        studentId: '',
        isAdmin: false,
        isLoggedIn: false);
  }

  /// TODO: add a method to convert a User to JSON object
//  Map<String, dynamic> toJson() => {
//         'id': id,
//         'email': email,
//         'created_at': createdAt,
//         'last_sign_in_at': lastSignInAt,
//         'updated_at': updatedAt,
//       };

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  Map<String, dynamic> schematoJson() => <String, dynamic>{
        'id': const Uuid().v4(),
        'idToken': idToken,
        'accessToken': accessToken,
        'email': email,
        'name': name,
        'avatarUrl': avatarUrl,
        'isLoggedIn': true,
        'isAdmin': isAdmin,
        'username': username,
        'password': password,
        'studentId': studentId,
        'created_at': created_at?.toIso8601String(),
      };

  set setEmail(String m) {
    email = m;
    notifyListeners();
  }

  set setName(String m) {
    name = m;
    notifyListeners();
  }

  set setIdToken(String m) {
    idToken = m;
    notifyListeners();
  }

  set setAccessToken(String m) {
    accessToken = m;
    notifyListeners();
  }

  set setAvatarUrl(String m) {
    avatarUrl = m;
    notifyListeners();
  }

  set setPassword(String m) {
    password = m;
    notifyListeners();
  }

  set setStudentId(String m) {
    studentId = m;
    notifyListeners();
  }

  set user(UserModel? user) {
    if (user == null) {
      avatarUrl = null;
      accessToken = null;
      idToken = null;
      name = '';
      email = '';
      username = '';
      password = '';
      isLoggedIn = false;
    } else {
      avatarUrl = user.avatarUrl;
      accessToken = user.accessToken;
      idToken = user.idToken;
      name = user.name;
      email = user.email;
      username = user.username;
      password = user.password;
      isLoggedIn = true;
    }
    notifyListeners();
  }
}
