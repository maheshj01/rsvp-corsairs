import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rsvp/base_home.dart';
import 'package:rsvp/constants/constants.dart';
import 'package:rsvp/models/user.dart';
import 'package:rsvp/pages/authentication/signup.dart';
import 'package:rsvp/services/analytics.dart';
import 'package:rsvp/services/api/appstate.dart';
import 'package:rsvp/services/api/user.dart';
import 'package:rsvp/services/authentication.dart';
import 'package:rsvp/services/database.dart';
import 'package:rsvp/themes/theme.dart';
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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Future<void> _handleSignIn(BuildContext context) async {
    final state = AppStateWidget.of(context);
    try {
      if (isGoogleSignIn) {
        user = (await auth.googleSignIn(context))!;
      }
      bool isEmail = user!.email.contains('@');
      if (user != null) {
        final existingUser = await UserService.findByUsername(
            username: isEmail ? user!.email : user!.studentId,
            isEmail: isEmail);
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

  @override
  void dispose() {
    _responseNotifier.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  final ValueNotifier<Response> _responseNotifier =
      ValueNotifier<Response>(Response.init());
  UserModel? user;
  late Analytics firebaseAnalytics;
  final Logger _logger = const Logger('LoginPage');
  bool isGoogleSignIn = false;
  @override
  Widget build(BuildContext context) {
    SizeUtils.size = MediaQuery.of(context).size;
    Widget _csField(String hint, TextEditingController controller, int index) {
      return Padding(
        padding: 8.0.verticalPadding,
        child: TextFormField(
            controller: controller,
            autofillHints:
                index == 0 ? [AutofillHints.email] : [AutofillHints.password],
            decoration: InputDecoration(
              border: inputborder,
              enabledBorder: inputborder,
              focusedBorder: inputborder,
              hintText: hint,
              counterText: '',
              hintStyle: const TextStyle(color: Colors.white),
            ),
            maxLength: index == STUDENT_ID_VALIDATOR ? 8 : null,
            keyboardType: index == STUDENT_ID_VALIDATOR
                ? TextInputType.number
                : TextInputType.text,
            textInputAction: TextInputAction.next,
            style: const TextStyle(color: Colors.white),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (index == 0) {
                final regexp1 = RegExp(emailPattern);
                final regexp2 = RegExp(studentIdPattern);
                if (value != null &&
                    (value.contains(regexp1) || value.contains(regexp2))) {
                  return null;
                }
                return 'Please enter a valid UMassd email';
              } else {
                if (value != null && value.length > 3) {
                  return null;
                }
                return 'Please enter a valid password';
              }
            }),
      );
    }

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
                  isLoading:
                      isGoogleSignIn && _response.state == RequestState.active,
                  onTap: () {
                    isGoogleSignIn = true;
                    _handleSignIn(context);
                  },
                  backgroundColor: Colors.white,
                ));
          }

          return Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                color: Color(0xff006d77),
              ),
              padding: 16.0.horizontalPadding,
              child: AutofillGroup(
                child: ListView(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: SizeUtils.size.height * 0.12,
                    ),
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
                    _csField('email/student id', _emailController, 0),
                    8.0.vSpacer(),
                    _csField('password', _passwordController, 1),
                    const SizedBox(height: 20),
                    CSButton(
                        height: 48,
                        backgroundColor: CorsairsTheme.primaryYellow,
                        onTap: () {
                          TextInput.finishAutofillContext(shouldSave: true);
                          isGoogleSignIn = false;
                          final _email = _emailController.text.trim();
                          final _password = _passwordController.text.trim();
                          if (_email.isEmpty || _password.isEmpty) {
                            showMessage(context, 'Please fill all fields');
                            return;
                          }
                          _handleSignIn(context);
                        },
                        isLoading: !isGoogleSignIn &&
                            _response.state == RequestState.active,
                        label: 'Login'),
                    // new user sign up
                    48.0.vSpacer(),
                    RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: [
                          const TextSpan(
                              text: 'Don\'t have an account? ',
                              style: TextStyle(color: Colors.white)),
                          TextSpan(
                              text: 'Sign Up',
                              style: const TextStyle(
                                  color: CorsairsTheme.primaryYellow),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigate()
                                      .pushReplace(context, const SignUp());
                                })
                        ])),
                    SizedBox(
                      height: SizeUtils.size.height * 0.12,
                    ),
                    _signInButton()
                  ],
                ),
              ),
            ),
          );
        });
  }
}
