import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rsvp/utils/secrets.dart';
import 'package:rsvp/utils/utility.dart';
import 'package:uni_links/uni_links.dart';

class DeepLinkService {
  StreamSubscription? _sub;

  late GlobalKey<NavigatorState> _navigatorKey;

  DeepLinkService.internal();

  static final DeepLinkService _instance = DeepLinkService.internal();

  DeepLinkService({required GlobalKey<NavigatorState> navigatorKey}) {
    _navigatorKey = navigatorKey;
    initUniLinks();
  }

  factory DeepLinkService.instance() => _instance;

  Future<void> initUniLinks() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      //   final initialLink = await getInitialLink();
      //   if (initialLink != null) {
      //     handleDeepLinks(initialLink);
      //   }
      _sub = linkStream.listen((String? link) {
        // Parse the link and warn the user, if it is not correct
        handleDeepLinks(link!);
      }, onError: (err) {
        print("could not parse link $err");
        // Handle exception by warning the user their action did not succeed
      });

      // Parse the link and warn the user, if it is not correct,
      // but keep in mind it could be `null`.
    } on PlatformException {
      // Handle exception by warning the user their action did not succeed
      // return?
    }
  }

  Future<void>? handleDeepLinks(String link) {
    // Parse the link and warn the user, if it is not correct
    print("link $link");
    if (link.contains(REDIRECT_URL)) {
      // parse link
      _navigatorKey.currentState!.pushNamed('/verified');
      showMessage(
          _navigatorKey.currentContext!, "Your email has been verified");
      return null;
    }
    final route = link.split('/').last;
    switch (route) {
      case 'verified':
        _navigatorKey.currentState!.pushNamed('/verified');
        break;
      default:
    }
    return null;
  }

  void dispose() {
    _sub!.cancel();
  }
}
