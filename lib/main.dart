import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:rsvp/base_home.dart';
import 'package:rsvp/models/event.dart';
import 'package:rsvp/services/analytics.dart';
import 'package:rsvp/services/api/appstate.dart';
import 'package:rsvp/splashscreen.dart';
import 'package:rsvp/themes/theme.dart';
import 'package:rsvp/utils/firebase_options.dart';
import 'package:rsvp/utils/logger.dart';

import 'constants/constants.dart';
import 'services/authentication.dart';
import 'utils/settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  analytics = FirebaseAnalytics.instance;
  usePathUrlStrategy();
  Settings.init();
  runApp(CorsairsApp());
}

const _logger = Logger('CorsairsApp');
final ValueNotifier<bool> darkNotifier = ValueNotifier<bool>(false);
final ValueNotifier<int> totalNotifier = ValueNotifier<int>(0);
final ValueNotifier<List<Event>?> listNotifier = ValueNotifier<List<Event>>([]);
// final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
late FirebaseAnalytics analytics;
FirebaseAnalyticsObserver observer =
    FirebaseAnalyticsObserver(analytics: analytics);

class CorsairsApp extends StatefulWidget {
  @override
  _CorsairsAppState createState() => _CorsairsAppState();
}

class _CorsairsAppState extends State<CorsairsApp> {
  Future<void> initializeApp() async {
    firebaseAnalytics = Analytics();
    firebaseAnalytics.appOpen();
    final email = await Settings.email;
    if (email.isNotEmpty) {
      final response =
          await AuthService.updateLoginStatus(email: email, isLoggedIn: true);
    }
  }

  // static final FirebaseMessaging _firebaseMessaging =
  //     FirebaseMessaging.instance;
  late Analytics firebaseAnalytics;
  @override
  void dispose() {
    darkNotifier.dispose();
    totalNotifier.dispose();
    searchController.dispose();
    listNotifier.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return AppStateWidget(
      child: AnimatedBuilder(
          animation: Settings(),
          builder: (BuildContext context, Widget? child) {
            return MaterialApp(
              title: APP_TITLE,
              debugShowCheckedModeBanner: !kDebugMode,
              darkTheme: CorsairsTheme.darkThemeData,
              theme: CorsairsTheme.lightThemeData,
              // routes: {
              //   Notifications.route: (context) => Notifications(),
              // },
              themeMode:
                  CorsairsTheme.isDark ? ThemeMode.dark : ThemeMode.light,
              home: const SplashScreen(),
            );
          }),
    );
  }
}
