import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rsvp/constants/constants.dart';
import 'package:rsvp/models/user.dart';
import 'package:rsvp/pages/authentication/login.dart';
import 'package:rsvp/services/analytics.dart';
import 'package:rsvp/services/api/appstate.dart';
import 'package:rsvp/services/auth/authentication.dart';
import 'package:rsvp/services/database.dart';
import 'package:rsvp/themes/theme.dart';
import 'package:rsvp/utils/extensions.dart';
import 'package:rsvp/utils/logger.dart';
import 'package:rsvp/utils/navigator.dart';
import 'package:rsvp/utils/settings.dart';
import 'package:rsvp/utils/size_utils.dart';
import 'package:rsvp/utils/utility.dart';
import 'package:rsvp/widgets/button.dart';
import 'package:rsvp/widgets/textfield.dart';
import 'package:rsvp/widgets/widgets.dart';
import 'package:uuid/uuid.dart';

class SignUp extends StatefulWidget {
  final UserModel? newUser;
  final bool isGoogleSignUp;
  const SignUp({Key? key, this.newUser, this.isGoogleSignUp = false})
      : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  AuthService auth = AuthService();
  // StreamSubscription<AuthState>? _subscription;

  Future<void> _handleSignUp(BuildContext context) async {
    final state = AppStateWidget.of(context);
    _responseNotifier.value = _responseNotifier.value.copyWith(
      state: RequestState.active,
    );
    try {
      user = _buildUserModel();
      final resp = auth.signUp(user!);
      if (!widget.isGoogleSignUp) {
        resp.then((value) {
          showMessage(context,
              "An email confirmation has been sent to your email address");
          state.setUser(user!.copyWith(isLoggedIn: false));
        }).onError((error, stackTrace) {
          _logger.e('error signing up $error');
          _responseNotifier.value = _responseNotifier.value.copyWith(
            state: RequestState.done,
            didSucced: false,
            message: error.toString(),
          );
        });
      } else {
        _passwordController.text = const Uuid().v4();
        state.setUser(user!.copyWith(isLoggedIn: true));
        _responseNotifier.value = _responseNotifier.value.copyWith(
          state: RequestState.done,
          didSucced: true,
          message: 'Success',
        );

        final response = await DatabaseService.insertIntoTable(
            user!.signUpSchema(),
            table: Constants.USER_TABLE_NAME);
        if (response.status == 201) {
          _responseNotifier.value = _responseNotifier.value.copyWith(
            state: RequestState.done,
            didSucced: true,
            message: 'Success',
          );
        } else {
          _responseNotifier.value = _responseNotifier.value.copyWith(
            state: RequestState.done,
            didSucced: false,
            message: 'Something went wrong!',
          );
        }
        Navigate.push(context, const LoginPage());
      }
    } catch (error) {
      showMessage(context, error.toString());
      _responseNotifier.value = _responseNotifier.value.copyWith(
        state: RequestState.done,
        didSucced: false,
        data: error,
        message: error.toString(),
      );
      await Settings.setIsSignedIn(false);
    }
  }

  UserModel? _buildUserModel() {
    final registerUser = UserModel.init();
    registerUser.email = _emailController.text.trim();
    registerUser.password = _passwordController.text.trim();
    registerUser.name = _nameController.text.trim();
    registerUser.studentId = _studentIdController.text.trim();
    registerUser.username = registerUser.email.split('@')[0];
    if (widget.newUser != null) {
      registerUser.accessToken = widget.newUser!.accessToken;
      registerUser.avatarUrl = widget.newUser!.avatarUrl;
    }
    return registerUser;
  }

  @override
  void initState() {
    firebaseAnalytics = Analytics();
    if (widget.newUser != null) {
      populateFields();
    }
    // _subscription = _supabase.auth.onAuthStateChange.listen((data) {
    //   final event = data.event;
    //   if (event == AuthChangeEvent.mfaChallengeVerified) {
    //     print("MFA Verified successfully");
    //   }
    //   final session = data.session;
    //   if (session != null && !haveNavigated) {
    //     _responseNotifier.value = _responseNotifier.value.copyWith(
    //       state: RequestState.done,
    //     );
    //   }
    //   print("Email Verified successfully");
    //   Navigate.pushAndPopAll(context, const LoginPage(),
    //       slideTransitionType: TransitionType.ttb);
    // });
    super.initState();
  }

  void populateFields({UserModel? newUser}) {
    if (newUser != null) {
      final list = newUser.name.split(' ');
      if (list.length > 2) {
        _nameController.text = list[0] + ' ' + list[1];
      } else {
        _nameController.text = newUser.name;
      }
      _nameController.text = newUser.name;
      _studentIdController.text = newUser.studentId;
      user = newUser.copyWith(
        email: newUser.email,
        name: newUser.name,
        studentId: newUser.studentId,
        password: _passwordController.text,
      );
    } else {
      final list = widget.newUser!.name.split(' ');
      if (list.length > 2) {
        _nameController.text = list[0] + ' ' + list[1];
      } else {
        _nameController.text = widget.newUser!.name;
      }
      if (widget.isGoogleSignUp) {
        _passwordController.text = const Uuid().v4();
      }
      _emailController.text = widget.newUser!.email;
      _studentIdController.text = widget.newUser!.studentId;
      user = widget.newUser;
    }
  }

  final ValueNotifier<Response> _responseNotifier =
      ValueNotifier<Response>(Response.init());
  UserModel? user;
  late Analytics firebaseAnalytics;
  final Logger _logger = const Logger('SignUp');

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<GlobalKey<FormFieldState>> _formFieldKeys =
      <GlobalKey<FormFieldState>>[
    GlobalKey<FormFieldState>(),
    GlobalKey<FormFieldState>(),
    GlobalKey<FormFieldState>(),
    GlobalKey<FormFieldState>(),
  ];

  bool _isValid() {
    for (final fieldKey in _formFieldKeys) {
      final FormFieldState? state = fieldKey.currentState;
      if (state == null || !state.isValid) {
        return false;
      }
    }
    return true;
  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _studentIdController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _studentIdController.dispose();
    // _subscription!.cancel();
    super.dispose();
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
  }

  bool haveNavigated = false;
  bool isGoogleSignUp = false;
  @override
  Widget build(BuildContext context) {
    SizeUtils.size = MediaQuery.of(context).size;
    return ValueListenableBuilder<Response>(
        valueListenable: _responseNotifier,
        builder: (BuildContext context, Response _response, Widget? child) {
          Widget _signUpWithGoogle() {
            return Align(
                alignment: Alignment.center,
                child: CSButton(
                  width: 300,
                  leading: Image.asset(GOOGLE_ASSET_PATH, height: 32),
                  label: 'Sign Up with Google',
                  isLoading:
                      isGoogleSignUp && _response.state == RequestState.active,
                  onTap: () {
                    auth.setAuthStrategy(GoogleAuthStrategy());
                    isGoogleSignUp = true;
                    _handleSignUp(context);
                  },
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                ));
          }

          return IgnorePointer(
            ignoring: _response.state == RequestState.active,
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Scaffold(
                backgroundColor: CorsairsTheme.primaryBlue,
                body: ValueListenableBuilder<Response>(
                    valueListenable: _responseNotifier,
                    builder: (BuildContext context, Response _response,
                        Widget? child) {
                      return Padding(
                        padding: 16.0.horizontalPadding,
                        child: AutofillGroup(
                          child: Form(
                            key: _formKey,
                            onChanged: () {
                              setState(() {});
                            },
                            child: ListView(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                kBottomNavigationBarHeight.vSpacer(),
                                const Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                48.0.vSpacer(),
                                TransparentField(
                                    fKey: _formFieldKeys[0],
                                    hint: 'Name',
                                    autoFillHints: const [
                                      AutofillHints.name,
                                      AutofillHints.givenName,
                                      AutofillHints.familyName
                                    ],
                                    controller: _nameController,
                                    index: Constants.NAME_VALIDATOR),
                                TransparentField(
                                    fKey: _formFieldKeys[1],
                                    hint: 'Email',
                                    readOnly: widget.isGoogleSignUp &&
                                        _emailController.text.isNotEmpty,
                                    controller: _emailController,
                                    index: Constants.EMAIL_VALIDATOR),
                                TransparentField(
                                    fKey: _formFieldKeys[2],
                                    hint: 'Student Id',
                                    controller: _studentIdController,
                                    index: Constants.STUDENT_ID_VALIDATOR),
                                TransparentField(
                                    fKey: _formFieldKeys[3],
                                    hint: 'Password',
                                    readOnly: widget.isGoogleSignUp &&
                                        _passwordController.text.isNotEmpty,
                                    controller: _passwordController,
                                    index: Constants.PASSWORD_VALIDATOR),
                                48.0.vSpacer(),
                                CSButton(
                                    height: 48,
                                    backgroundColor:
                                        CorsairsTheme.primaryYellow,
                                    isLoading: !isGoogleSignUp &&
                                        _response.state == RequestState.active,
                                    onTap: _isValid()
                                        ? () {
                                            auth.setAuthStrategy(
                                                EmailAuthStrategy());
                                            removeFocus(context);
                                            isGoogleSignUp = false;
                                            _handleSignUp(context);
                                          }
                                        : null,
                                    label: 'SignUp'),
                                16.0.vSpacer(),
                                // or divider
                                // const Align(
                                //   alignment: Alignment.center,
                                //   child: Text(
                                //     'or',
                                //     style: TextStyle(
                                //       color: Colors.white,
                                //       fontSize: 20,
                                //       fontWeight: FontWeight.bold,
                                //     ),
                                //   ),
                                // ),
                                // const SizedBox(height: 20), _signUpWithGoogle(),
                                // already have an account text button
                                16.0.vSpacer(),
                                Align(
                                  alignment: Alignment.center,
                                  child: TextButton(
                                      onPressed: () {
                                        Navigate.pushAndPopAll(
                                            context, const LoginPage());
                                      },
                                      child: RichText(
                                          text: TextSpan(children: [
                                        const TextSpan(
                                            text: 'Already have an account? ',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            )),
                                        TextSpan(
                                            text: 'Sign In',
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                Navigate.pushAndPopAll(
                                                    context, const LoginPage());
                                              },
                                            style: const TextStyle(
                                                color:
                                                    CorsairsTheme.primaryYellow,
                                                fontSize: 16,
                                                decoration:
                                                    TextDecoration.underline))
                                      ]))),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
          );
        });
  }
}
