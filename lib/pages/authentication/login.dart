import 'package:flutter/material.dart';
import 'package:rsvp/base_home.dart';
import 'package:rsvp/constants/constants.dart';
import 'package:rsvp/models/user.dart';
import 'package:rsvp/pages/authentication/signup.dart';
import 'package:rsvp/services/analytics.dart';
import 'package:rsvp/services/api/appstate.dart';
import 'package:rsvp/services/api/user.dart';
import 'package:rsvp/services/authentication.dart';
import 'package:rsvp/services/database.dart';
import 'package:rsvp/utils/extensions.dart';
import 'package:rsvp/utils/logger.dart';
import 'package:rsvp/utils/navigator.dart';
import 'package:rsvp/utils/settings.dart';
import 'package:rsvp/utils/size_utils.dart';
import 'package:rsvp/utils/utility.dart';
import 'package:rsvp/widgets/button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthService auth = AuthService();

  Future<void> _handleSignIn(BuildContext context) async {
    final state = AppStateWidget.of(context);
    try {
      user = (await auth.googleSignIn(context))!;
      if (user != null) {
        final existingUser = await UserService.findByEmail(email: user!.email);
        if (existingUser.email.isEmpty) {
          _logger.d('registering new user ${user!.email}');
          final resp = await AuthService.registerUser(user!);
          if (resp.didSucced) {
            final user = UserModel.fromJson((resp.data as List<dynamic>)[0]);
            state.setUser(user.copyWith(isLoggedIn: true));
            _responseNotifier.value = _responseNotifier.value.copyWith(
              state: RequestState.done,
            );
            Navigate.pushAndPopAll(context, const AdaptiveLayout(),
                slideTransitionType: TransitionType.ttb);
            await Settings.setIsSignedIn(true, email: user.email);
          } else {
            _logger.d(signInFailure);
            await Settings.setIsSignedIn(false, email: existingUser.email);
            showMessage(context, signInFailure);
            _responseNotifier.value = _responseNotifier.value.copyWith(
              state: RequestState.done,
              didSucced: false,
              message: signInFailure,
            );
            throw 'failed to register new user';
          }
        } else {
          _logger.d('found existing user ${user!.email}');
          await Settings.setIsSignedIn(true, email: existingUser.email);
          await AuthService.updateLoginStatus(
              email: existingUser.email, isLoggedIn: true);
          state.setUser(existingUser.copyWith(isLoggedIn: true));
          _responseNotifier.value = _responseNotifier.value.copyWith(
              state: RequestState.done, didSucced: true, data: existingUser);
          Navigate.pushAndPopAll(context, const AdaptiveLayout());
          firebaseAnalytics.logSignIn(user!);
        }
      } else {
        showMessage(context, signInFailure);
        _responseNotifier.value = _responseNotifier.value.copyWith(
          state: RequestState.done,
        );
        throw 'failed to register new user';
      }
    } catch (error) {
      showMessage(context, error.toString());
      _responseNotifier.value = Response.init();
      await Settings.setIsSignedIn(false);
    }
  }

  @override
  void initState() {
    firebaseAnalytics = Analytics();
    super.initState();
  }

  final ValueNotifier<Response> _responseNotifier = ValueNotifier<Response>(
      Response(state: RequestState.none, didSucced: false, message: 'Failed'));
  UserModel? user;
  late Analytics firebaseAnalytics;
  final Logger _logger = const Logger('LoginPage');
  @override
  Widget build(BuildContext context) {
    SizeUtils.size = MediaQuery.of(context).size;
    return ValueListenableBuilder<Response>(
        valueListenable: _responseNotifier,
        builder: (BuildContext context, Response _response, Widget? child) {
          Widget _signInButton() {
            return Align(
                alignment: Alignment.center,
                child: CSButton(
                  width: 300,
                  leading: Image.asset(GOOGLE_ASSET_PATH, height: 32),
                  label: 'Sign In with Google',
                  isLoading: _response.state == RequestState.active,
                  onTap: () => _handleSignIn(context),
                  backgroundColor: Colors.white,
                ));
          }

          return Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                color: Color(0xff006d77),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'RSVP',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  48.0.vSpacer(),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'email/student Id',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  // Google Sign In Button
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  20.0.vSpacer(),
                  _signInButton(),
                  20.0.vSpacer(),
                  CSButton(
                      onTap: () {
                        Navigate.pushAndPopAll(context, const AdaptiveLayout());
                      },
                      label: 'Login'),
                  // signup text
                  TextButton(
                      onPressed: () {
                        Navigate().pushReplace(context, const SignUp());
                      },
                      child: const Text('Sign up'))
                ],
              ),
            ),
          );
        });
  }
}
