// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_analytics/observer.dart';
import 'package:flutter/foundation.dart';
import 'package:rsvp/main.dart';
import 'package:rsvp/models/event.dart';
import 'package:rsvp/models/user.dart';

class Analytics {
//   FirebaseAnalyticsObserver observer;
//   FirebaseAnalytics analytics;

  Future<void> logEventSelection(Event event) async {
    await analytics
        .logEvent(name: 'Event_selected', parameters: {'event': event.name});
  }

  /// Platform is either Desktop or Web(PWA)
  Future<void> logRedirectToStore(String platform) async {
    await analytics
        .logEvent(name: 'play_store', parameters: {'Platform': '$platform'});
  }

  Future<void> logEventEdit(Event event, String email) async {
    await analytics.logEvent(
        name: 'Event_edit', parameters: {'Event': event.name, 'email': email});
  }

  Future<void> logEventDelete(Event event, String email) async {
    await analytics.logEvent(
        name: 'Event_delete',
        parameters: {'Event': event.name, 'email': email});
  }

  Future<void> logEventAdd(Event event, [String email = '']) async {
    await analytics.logEvent(
        name: 'Event_add', parameters: {'Event': event.name, 'email': email});
  }

  Future<void> logNewUser(UserModel user) async {
    await analytics.logEvent(name: 'sign_up', parameters: {
      'email': user.email,
      'name': user.name,
      'platform': kIsWeb ? 'web' : 'mobile'
    });
  }

  Future<void> logSignIn(UserModel user) async {
    await analytics.logEvent(name: 'sign_in', parameters: {
      'email': user.email,
      'name': user.name,
      'platform': kIsWeb ? 'web' : 'mobile'
    });
  }

  Future<void> appOpen() async {
    await analytics.logAppOpen();
  }

//   Future<void> logInitiateSignup(String signupMethod) async {
//     await analytics.logSignUp(signUpMethod: signupMethod);
//   }

//   Future<void> logLogin(String loginMethod) async {
//     await analytics.logLogin(loginMethod: loginMethod);
//   }

//   Future<void> logAddToCart(String id) async {
//     await analytics.logAddToCart(itemId: id);
//   }
}
