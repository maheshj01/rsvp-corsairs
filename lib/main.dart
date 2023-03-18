import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:rsvp/base_home.dart';
import 'package:rsvp/constants/const.dart';
import 'package:rsvp/models/event_schema.dart';
import 'package:rsvp/pages/authentication/login.dart';
import 'package:rsvp/services/analytics.dart';
import 'package:rsvp/services/api/appstate.dart';
import 'package:rsvp/services/deep_links.dart';
import 'package:rsvp/splashscreen.dart';
import 'package:rsvp/themes/theme.dart';
import 'package:rsvp/utils/firebase_options.dart';
import 'package:rsvp/utils/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'services/auth/authentication.dart';
import 'utils/settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  analytics = FirebaseAnalytics.instance;
  usePathUrlStrategy();
  Settings.init();
  await Supabase.initialize(
    url: Constants.SUPABASE_URL,
    anonKey: Constants.SUPABASE_API_KEY,
  );
  AuthService(client: Supabase.instance.client);
  runApp(const CorsairsApp());
}

const _logger = Logger('CorsairsApp');
final ValueNotifier<bool> darkNotifier = ValueNotifier<bool>(false);
final ValueNotifier<int> totalNotifier = ValueNotifier<int>(0);
final ValueNotifier<List<EventModel>?> listNotifier =
    ValueNotifier<List<EventModel>>([]);
// final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
late FirebaseAnalytics analytics;
FirebaseAnalyticsObserver observer =
    FirebaseAnalyticsObserver(analytics: analytics);

class CorsairsApp extends StatefulWidget {
  const CorsairsApp({super.key});

  @override
  _CorsairsAppState createState() => _CorsairsAppState();
}

class _CorsairsAppState extends State<CorsairsApp> {
  Future<void> initializeApp() async {
    firebaseAnalytics = Analytics();
    firebaseAnalytics.appOpen();
    final email = await Settings.email;
    if (email.isNotEmpty) {
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
    _deepLinkService.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initializeApp();
    _deepLinkService = DeepLinkService(navigatorKey: _navigatorKey);
  }

  late DeepLinkService _deepLinkService;

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return AppStateWidget(
      child: AnimatedBuilder(
          animation: Settings(),
          builder: (BuildContext context, Widget? child) {
            return MaterialApp(
              title: Constants.APP_TITLE,
              debugShowCheckedModeBanner: !kDebugMode,
              darkTheme: CorsairsTheme.darkThemeData,
              theme: CorsairsTheme.lightThemeData,
              navigatorKey: _navigatorKey,
              initialRoute: '/',
              routes: {
                '/': (context) => const SplashScreen(),
                '/verified': (context) => const LoginPage()
              },
              themeMode:
                  CorsairsTheme.isDark ? ThemeMode.dark : ThemeMode.light,
              // home: const SplashScreen(),
            );
          }),
    );
  }
}
