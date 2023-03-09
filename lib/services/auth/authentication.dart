import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rsvp/models/user.dart';
import 'package:rsvp/services/database.dart';
import 'package:rsvp/utils/logger.dart';
import 'package:rsvp/utils/utility.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../constants/constants.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      //   'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  static final AuthService _instance = AuthService._internal();

  factory AuthService.instance() => _instance;

  AuthService._internal();
  late AuthStrategy _authStrategy;

  AuthService({AuthStrategy? authStrategy, SupabaseClient? client}) {
    _authStrategy = authStrategy ?? EmailAuthStrategy();
  }

  SupabaseClient get supabaseClient => Supabase.instance.client;

  void setAuthStrategy(AuthStrategy strategy) {
    _authStrategy = strategy;
  }

  Future<AuthResponse?> signUp(UserModel user) {
    return _authStrategy.signUp(user);
  }

  Future<UserModel?> signIn(String email, String password) {
    return _authStrategy.signIn(email, password);
  }

  Future<bool> signOut(BuildContext context) {
    return _authStrategy.signOut(context);
  }

  static const String _tableName = Constants.USER_TABLE_NAME;
  static const _logger = Logger('AuthService');

  static Future<Response> updateLoginStatus(
      {required String email, bool isLoggedIn = false}) async {
    final resp = Response.init();
    try {
      final response = await DatabaseService.updateColumn(
          searchColumn: Constants.USER_EMAIL_COLUMN,
          searchValue: email,
          columnValue: isLoggedIn,
          columnName: Constants.USER_LOGGEDIN_COLUMN,
          tableName: _tableName);
      if (response.status == 200 || response.status == 204) {
        return resp.copyWith(
          didSucced: true,
          message: 'Success',
        );
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

abstract class AuthStrategy {
  Future<UserModel?> signIn(String email, String password);
  Future<bool> signOut(BuildContext context);
  Future<AuthResponse?> signUp(UserModel user);
}

class EmailAuthStrategy implements AuthStrategy {
  static const _logger = Logger('EmailAuthService');
  static final _supabase = AuthService.instance().supabaseClient;

  @override
  Future<UserModel?> signIn(String email, String password) {
    final Future<AuthResponse> response = _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return response.then((data) {
      _supabase.auth.setSession(data.session!.refreshToken!);
      final user = UserModel.fromJson(data.user!.appMetadata);
      return user;
    }).onError((error, stackTrace) {
      _logger.e(error.toString());
      throw "Invalid email or password";
    });
  }

  @override
  Future<bool> signOut(BuildContext context) async {
    try {
      await _supabase.auth.signOut();
      return Future.value(true);
    } catch (_) {
      return Future.value(false);
    }
  }

  @override
  Future<AuthResponse?> signUp(UserModel user) async {
    AuthResponse? authResponse;
    try {
      final Future<AuthResponse> authResponse = _supabase.auth.signUp(
          password: user.password,
          email: user.email,
          emailRedirectTo: Constants.REDIRECT_URL,
          data: user.schematoJson());
      authResponse.then((value) async {}).onError((error, stackTrace) {});
    } on PostgrestException catch (_) {
      _logger.e('error caught $_');
      throw "Failed to register new user: ${_.details}";
    }
    return authResponse;
  }

  @override
  Future<UserModel> signUpWithGoogle() {
    throw UnimplementedError();
  }
}

class GoogleAuthStrategy implements AuthStrategy {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      //   'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  final _supabase = AuthService.instance().supabaseClient;
  static const _logger = Logger('GoogleAuthService');

  @override
  Future<UserModel?> signIn(String email, String password) async {
    await _googleSignIn.signOut();
    final result = await _googleSignIn.signIn();
    final googleKey = await result!.authentication;
    final String? idToken = googleKey.idToken;
    final response = await Supabase.instance.client.auth.signInWithIdToken(
        provider: Provider.google,
        // redirectTo: REDIRECT_URL,
        idToken: idToken!
        // authScreenLaunchMode: LaunchMode.inAppWebView
        );
    // .signInWithIdToken(provider: Provider.google, idToken: idToken!);
    if (response.session != null) {
      final currentUser = response.session!.user;
      return UserModel.fromJson(currentUser.userMetadata!);
    }
    return null;
  }

  @override
  Future<bool> signOut(BuildContext context) async {
    try {
      await _googleSignIn.disconnect();
      return true;
    } catch (err) {
      _logger.e(err.toString());
      showMessage(context, 'Failed to signout!');
      return false;
    }
  }

  @override
  Future<AuthResponse?> signUp(UserModel user) async {
    UserModel? newUser = UserModel.init();
    try {
      await _googleSignIn.signOut();
      final result = await _googleSignIn.signIn();
      final googleKey = await result!.authentication;
      final String? accessToken = googleKey.accessToken;
      final String? idToken = googleKey.idToken;
      final String email = _googleSignIn.currentUser!.email;

      /// default username
      final String username = email.split('@').first;
      newUser.copyWith(
          name: _googleSignIn.currentUser!.displayName ?? '',
          email: _googleSignIn.currentUser!.email,
          avatarUrl: _googleSignIn.currentUser!.photoUrl,
          idToken: idToken,
          username: username,
          isAdmin: false,
          created_at: DateTime.now().toUtc(),
          password: '',
          studentId: '',
          accessToken: accessToken);
      final AuthResponse authResponse = await _supabase.auth.signUp(
          password: user.password,
          email: user.email,
          data: user.schematoJson());
      return authResponse;
    } catch (error) {
      _logger.e(error.toString());
      throw 'Failed to Signup new user';
    }
  }

  @override
  Future<UserModel> signUpWithGoogle() async {
    UserModel? newUser = UserModel.init();
    await _googleSignIn.signOut();
    final result = await _googleSignIn.signIn();
    final googleKey = await result!.authentication;
    final String? accessToken = googleKey.accessToken;
    final String? idToken = googleKey.idToken;
    final String email = _googleSignIn.currentUser!.email;

    /// default username
    final String username = email.split('@').first;
    newUser = newUser.copyWith(
        name: _googleSignIn.currentUser!.displayName ?? '',
        email: _googleSignIn.currentUser!.email,
        avatarUrl: _googleSignIn.currentUser!.photoUrl,
        idToken: idToken,
        username: username,
        isAdmin: false,
        created_at: DateTime.now().toUtc(),
        password: '',
        studentId: '',
        accessToken: accessToken);
    return newUser;
  }
}
