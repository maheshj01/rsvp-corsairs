import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rsvp/constants/const.dart';
import 'package:rsvp/constants/constants.dart';
import 'package:rsvp/models/event_schema.dart';
import 'package:rsvp/models/user.dart';
import 'package:rsvp/themes/theme.dart';

extension StringExtension on String {
  String? capitalize() {
    return toBeginningOfSentenceCase(this);
  }

  /// Returns the first letter of each word in the string.
  String initials() {
    if (isEmpty) return '';
    if (contains(' ')) {
      return split(' ').map((e) => e.capitalize()!.substring(0, 1)).join();
    } else {
      return substring(0, 1);
    }
  }
}

extension CompareEvents on EventModel {
  bool equals(EventModel other) =>
      runtimeType == other.runtimeType &&
      id == other.id &&
      name == other.name &&
      description == other.description &&
      createdAt == other.createdAt &&
      startsAt == other.startsAt &&
      endsAt == other.endsAt &&
      coverImage == other.coverImage &&
      listEquals(attendees, other.attendees);
}

extension CompareUsers on UserModel {
  bool equals(UserModel other) =>
      runtimeType == other.runtimeType &&
      idToken == other.idToken &&
      accessToken == other.accessToken &&
      listEquals(hosted, other.hosted) &&
      listEquals(bookmarks, other.bookmarks) &&
      email == other.email &&
      name == other.name &&
      avatarUrl == other.avatarUrl &&
      isLoggedIn == other.isLoggedIn &&
      isAdmin == other.isAdmin &&
      username == other.username &&
      created_at == other.created_at;
}

extension ConatainsInBookmarks on EventModel{
    bool containsInBookmarks(List<EventModel> bookmarks){
        return bookmarks.any((element) => element.id == id);
    }
}

extension DateHelper on DateTime {
  String formatDate() {
    final now = DateTime.now();
    final differenceInDays = getDifferenceInDaysWithNow();
    if (isSameDate(now)) {
      return 'Today';
    } else if (differenceInDays == 1) {
      return 'Yesterday';
    } else {
      final formatter = DateFormat(dateFormatter);
      return formatter.format(this);
    }
  }

  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  int getDifferenceInDaysWithNow() {
    final now = DateTime.now();
    return now.difference(this).inDays;
  }

  String standardDate() {
    final formatter = DateFormat(dateFormatter);
    return formatter.format(this);
  }

  String standardTime() {
    final formatter = DateFormat(timeFormatter);
    return formatter.format(this);
  }

// return time difference in hrs and minutes
// format: 1hr 30min
  String standardTimeDifference(DateTime date) {
    final difference = this.difference(date).inMinutes;
    final hours = difference ~/ 60;
    final minutes = difference % 60;
    return '$hours hr' + (minutes > 0 ? ' $minutes mins' : '');
  }
}

extension ContainerBorderRadius on double {
  BorderRadiusGeometry get allRadius => BorderRadius.circular(this);

  BorderRadiusGeometry get topLeftRadius =>
      BorderRadius.only(topLeft: Radius.circular(this));

  BorderRadiusGeometry get topRightRadius =>
      BorderRadius.only(topRight: Radius.circular(this));

  BorderRadiusGeometry get bottomLeftRadius =>
      BorderRadius.only(bottomLeft: Radius.circular(this));

  BorderRadiusGeometry get bottomRightRadius =>
      BorderRadius.only(bottomRight: Radius.circular(this));

  BorderRadiusGeometry get verticalRadius => BorderRadius.vertical(
      top: Radius.circular(this), bottom: Radius.circular(this));

  BorderRadiusGeometry get horizontalRadius => BorderRadius.horizontal(
      left: Radius.circular(this), right: Radius.circular(this));

  BorderRadiusGeometry get topRadius =>
      BorderRadius.vertical(top: Radius.circular(this));

  BorderRadiusGeometry get bottomRadius =>
      BorderRadius.vertical(bottom: Radius.circular(this));

  BorderRadiusGeometry get leftRadius =>
      BorderRadius.horizontal(left: Radius.circular(this));

  BorderRadiusGeometry get rightRadius =>
      BorderRadius.horizontal(right: Radius.circular(this));

  BorderRadiusGeometry get topLeftBottomRightRadius => BorderRadius.only(
      topLeft: Radius.circular(this), bottomRight: Radius.circular(this));

  BorderRadiusGeometry get topRightBottomLeftRadius => BorderRadius.only(
      topRight: Radius.circular(this), bottomLeft: Radius.circular(this));
}

extension ContainerPadding on double {
  EdgeInsetsGeometry get allPadding => EdgeInsets.all(this);

  EdgeInsetsGeometry get topPadding => EdgeInsets.only(top: this);

  EdgeInsetsGeometry get bottomPadding => EdgeInsets.only(bottom: this);

  EdgeInsetsGeometry get leftPadding => EdgeInsets.only(left: this);

  EdgeInsetsGeometry get rightPadding => EdgeInsets.only(right: this);

  EdgeInsetsGeometry get bottomRightPadding =>
      EdgeInsets.only(bottom: this, right: this);

  EdgeInsetsGeometry get bottomLeftPadding =>
      EdgeInsets.only(bottom: this, left: this);

  EdgeInsetsGeometry get topRightPadding =>
      EdgeInsets.only(top: this, right: this);

  EdgeInsetsGeometry get topLeftPadding =>
      EdgeInsets.only(top: this, left: this);

  EdgeInsetsGeometry get topHorizontalPadding =>
      EdgeInsets.only(top: this, left: this, right: this);

  EdgeInsetsGeometry get bottomHorizontalPadding =>
      EdgeInsets.only(bottom: this, left: this, right: this);

  EdgeInsetsGeometry get leftVerticalPadding =>
      EdgeInsets.only(left: this, top: this, bottom: this);

  EdgeInsetsGeometry get rightVerticalPadding =>
      EdgeInsets.only(right: this, top: this, bottom: this);

  EdgeInsetsGeometry get verticalPadding =>
      EdgeInsets.symmetric(vertical: this);

  EdgeInsetsGeometry get horizontalPadding =>
      EdgeInsets.symmetric(horizontal: this);
}

extension RoundedShape on double {
  ShapeBorder get rounded =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(this));

  ShapeBorder get roundedTop => RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(this), topRight: Radius.circular(this)));

  ShapeBorder get roundedBottom => RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(this),
          bottomRight: Radius.circular(this)));

  ShapeBorder get roundedLeft => RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(this), bottomLeft: Radius.circular(this)));

  ShapeBorder get roundedRight => RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(this), bottomRight: Radius.circular(this)));

  ShapeBorder get roundedTopLeft => RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(this)));

  ShapeBorder get roundedTopRight => RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topRight: Radius.circular(this)));

  ShapeBorder get roundedBottomLeft => RoundedRectangleBorder(
      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(this)));

  ShapeBorder get roundedBottomRight => RoundedRectangleBorder(
      borderRadius: BorderRadius.only(bottomRight: Radius.circular(this)));

  ShapeBorder get roundedTopBottom => RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
          top: Radius.circular(this), bottom: Radius.circular(this)));

  ShapeBorder get roundedLeftRight => RoundedRectangleBorder(
      borderRadius: BorderRadius.horizontal(
          left: Radius.circular(this), right: Radius.circular(this)));

  ShapeBorder get roundedTopLeftBottomRight => RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(this), bottomRight: Radius.circular(this)));

  ShapeBorder get roundedTopRightBottomLeft => RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(this), bottomLeft: Radius.circular(this)));
}

extension RoundedBorderSide on dynamic {
  Border get rounded => Border.all();

  Border get roundedTop => const Border(
      top: BorderSide(
          color: CorsairsTheme.primaryYellow,
          width: 1,
          style: BorderStyle.solid));

  Border get roundedBottom => const Border(
      bottom: BorderSide(
          color: CorsairsTheme.primaryYellow,
          width: 1,
          style: BorderStyle.solid));

  Border get roundedLeft => const Border(
      left: BorderSide(
          color: CorsairsTheme.primaryYellow,
          width: 1,
          style: BorderStyle.solid));

  Border get roundedRight => const Border(
      right: BorderSide(
          color: CorsairsTheme.primaryYellow,
          width: 1,
          style: BorderStyle.solid));

  Border get roundedTopLeft => const Border(
      top: BorderSide(
          color: CorsairsTheme.primaryYellow,
          width: 1,
          style: BorderStyle.solid),
      left: BorderSide(
          color: CorsairsTheme.primaryYellow,
          width: 1,
          style: BorderStyle.solid));

  Border get roundedTopRight => const Border(
      top: BorderSide(
          color: CorsairsTheme.primaryYellow,
          width: 1,
          style: BorderStyle.solid),
      right: BorderSide(
          color: CorsairsTheme.primaryYellow,
          width: 1,
          style: BorderStyle.solid));

  Border get roundedBottomLeft => const Border(
      bottom: BorderSide(
          color: CorsairsTheme.primaryYellow,
          width: 1,
          style: BorderStyle.solid),
      left: BorderSide(
          color: CorsairsTheme.primaryYellow,
          width: 1,
          style: BorderStyle.solid));
}

extension SizedBoxSpacer on double {
  SizedBox vSpacer() => SizedBox(height: this);

  SizedBox hSpacer() => SizedBox(width: this);
}
