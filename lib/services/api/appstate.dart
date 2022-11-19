import 'package:flutter/material.dart';
import 'package:rsvp/models/event.dart';
import 'package:rsvp/models/user.dart';
import 'package:rsvp/services/api/user.dart';

class AppState {
  final UserModel? user;
  final List<Event>? events;

  const AppState({this.user, this.events});

  AppState copyWith({
    List<Event>? events,
    UserModel? user,
  }) {
    return AppState(events: events ?? this.events, user: user ?? this.user);
  }
}

class AppStateScope extends InheritedWidget {
  AppStateScope(this.data, {Key? key, required Widget child})
      : super(key: key, child: child);

  AppState data = AppState(user: UserModel(), events: []);

  static AppState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppStateScope>()!.data;
  }

  @override
  bool updateShouldNotify(AppStateScope oldWidget) {
    return data.user?.email != oldWidget.data.user?.email ||
        data.events != oldWidget.data.events;
  }
}

/// this statefule widget is required to update the state of the AppstacteScope,
/// since inherited widget is immutable
class AppStateWidget extends StatefulWidget {
  const AppStateWidget({required this.child, Key? key}) : super(key: key);

  final Widget child;

  static AppStateWidgetState of(BuildContext context) {
    return context.findAncestorStateOfType<AppStateWidgetState>()!;
  }

  @override
  AppStateWidgetState createState() => AppStateWidgetState();
}

class AppStateWidgetState extends State<AppStateWidget> {
  AppState _data = AppState();
  final _userStore = UserService();

  void setEvents(List<Event> events) {
    if (events != _data.events) {
      setState(() {
        _data = _data.copyWith(
          events: events,
        );
      });
    }
  }

  void setUser(UserModel user) {
    setState(() {
      _data = _data.copyWith(
        user: user,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppStateScope(
      _data,
      child: widget.child,
    );
  }
}
