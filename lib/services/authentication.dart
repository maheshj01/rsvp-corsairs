import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rsvp/models/user.dart';
import 'package:rsvp/services/database.dart';
import 'package:rsvp/utils/logger.dart';
import 'package:rsvp/utils/utility.dart';
import 'package:supabase/supabase.dart';

import '../constants/constants.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      //   'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  static const String _tableName = USER_TABLE_NAME;
  static const _logger = Logger('AuthService');
  static Future<Response> registerUser(UserModel user) async {
    final resp = Response(didSucced: false, message: "Failed");
    final json = user.schematoJson();
    try {
      final response =
          await DatabaseService.insertIntoTable(json, table: USER_TABLE_NAME);
      if (response.status == 201) {
        resp.didSucced = true;
        resp.message = 'Success';
      } else {
        _logger.e('error caught');
        throw "Failed to register new user";
      }
    } on PostgrestException catch (_) {
      _logger.e('error caught $_');
      throw "Failed to register new user: ${_.details}";
    }
    return resp;
  }

  Future<UserModel?> googleSignIn(
      {bool isLogin = true, bool socialSignUp = false}) async {
    UserModel? user;
    try {
      await _googleSignIn.signOut();
      final result = await _googleSignIn.signIn();
      final googleKey = await result!.authentication;
      final String? accessToken = googleKey.accessToken;
      final String? idToken = googleKey.idToken;
      final String email = _googleSignIn.currentUser!.email;

      /// default username
      final String username = email.split('@').first;
      user = UserModel(
          name: _googleSignIn.currentUser!.displayName ?? '',
          email: _googleSignIn.currentUser!.email,
          avatarUrl: _googleSignIn.currentUser!.photoUrl,
          idToken: idToken,
          username: username,
          isAdmin: false,
          created_at: DateTime.now(),
          password: '',
          studentId: '',
          accessToken: accessToken);
    } catch (error) {
      _logger.e(error.toString());
      throw 'Failed to signIn';
    }
    return user;
  }

  Future<bool> googleSignOut(BuildContext context) async {
    try {
      await _googleSignIn.disconnect();
      return true;
    } catch (err) {
      _logger.e(err.toString());
      showMessage(context, 'Failed to signout!');
      return false;
    }
  }

  static Future<Response> updateLoginStatus(
      {required String email, bool isLoggedIn = false}) async {
    final resp = Response.init();
    try {
      final response = await DatabaseService.updateColumn(
          searchColumn: USER_EMAIL_COLUMN,
          searchValue: email,
          columnValue: isLoggedIn,
          columnName: USER_LOGGEDIN_COLUMN,
          tableName: _tableName);
      if (response.status == 200) {
        return resp.copyWith(
            didSucced: true,
            message: 'Success',
            data: UserModel.fromJson(
              (response.data as List).first,
            ));
      } else {
        _logger.d('existing user not found');
        return resp.copyWith(
            didSucced: false, message: 'existing user not found');
      }
    } on PostgrestException catch (_) {
      _logger.e(_.toString());
      return resp.copyWith(didSucced: false, message: _.details);
    }
  }
}
