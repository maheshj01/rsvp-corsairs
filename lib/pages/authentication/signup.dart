import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rsvp/base_home.dart';
import 'package:rsvp/constants/constants.dart';
import 'package:rsvp/models/user.dart';
import 'package:rsvp/pages/authentication/login.dart';
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

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  AuthService auth = AuthService();

  Future<void> _handleSignUp(BuildContext context) async {
    final state = AppStateWidget.of(context);
    _responseNotifier.value = _responseNotifier.value.copyWith(
      state: RequestState.active,
    );
    try {
      if (isGoogleSignUp) {
        user = (await auth.googleSignIn(context))!;
      } else {
        user = _buildUserModel();
      }
      if (user != null) {
        final existingUser = await UserService.findByEmail(email: user!.email);
        if (existingUser.email.isEmpty) {
          _logger.d('registering new user ${user!.email}');
          final resp = await AuthService.registerUser(user!);
          if (resp.didSucced) {
            state.setUser(user!.copyWith(isLoggedIn: true));
            _responseNotifier.value = _responseNotifier.value.copyWith(
              state: RequestState.done,
            );
            Navigate.pushAndPopAll(context, const AdaptiveLayout(),
                slideTransitionType: TransitionType.ttb);
            await Settings.setIsSignedIn(true, email: user!.email);
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
        _responseNotifier.value = _responseNotifier.value.copyWith(
          state: RequestState.done,
          didSucced: false,
          message: 'failed to register new user',
        );
        throw 'failed to register new user';
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
    final _email = _emailController.text.trim();
    final _password = _passwordController.text.trim();
    final _name = _nameController.text.trim();
    final _studentId = _studentIdController.text.trim();
    final _username = _email.split('@')[0];

    if (_email.isEmpty ||
        _password.isEmpty ||
        _name.isEmpty ||
        _studentId.isEmpty) {
      return null;
    }

    return UserModel(
      email: _email,
      password: _password,
      name: _name,
      studentId: _studentId,
      accessToken: '',
      isLoggedIn: false,
      avatarUrl: '',
      created_at: DateTime.now(),
      isAdmin: false,
      username: _username,
    );
  }

  @override
  void initState() {
    firebaseAnalytics = Analytics();
    super.initState();
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

  static FormFieldValidator<String> _fieldValidator(int field) {
    switch (field) {
      case NAME_VALIDATOR:
        return (String? value) {
          final regexp = RegExp(firstAndLastNamePattern);
          if (value == null || value.isEmpty || !value.contains(regexp)) {
            return 'Please enter a valid first and last name';
          }
          return null;
        };
      case EMAIL_VALIDATOR:
        return (String? value) {
          // email validate @umassd.edu
          final regexp = RegExp(emailPattern);
          if (value != null && value.length > 5 && value.contains(regexp)) {
            return null;
          }
          return 'Please enter a valid UMassd email';
        };
      case PASSWORD_VALIDATOR:
        return (String? value) {
          if (value != null && value.length > 7) {
            return null;
          }
          return 'Password must be at least 8 characters long';
        };

      case STUDENT_ID_VALIDATOR:
        return (String? value) {
          if (value != null && value.length == 8) {
            return null;
          }
          return 'Please enter a valid Student ID';
        };
      default:
        return (String? value) {
          return null;
        };
    }
  }

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
    super.dispose();
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
  }

  Widget _csField(Key wkey, hint, TextEditingController controller, int index) {
    return Padding(
      padding: 8.0.verticalPadding,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: inputborder,
          enabledBorder: inputborder,
          focusedBorder: inputborder,
          hintText: hint,
          counterText: '',
          errorStyle: const TextStyle(
            color: Colors.red,
            fontSize: 14,
          ),
          hintStyle: const TextStyle(color: Colors.white),
        ),
        obscureText: index == PASSWORD_VALIDATOR,
        obscuringCharacter: '◦',
        maxLength: index == STUDENT_ID_VALIDATOR ? 8 : null,
        keyboardType: index == STUDENT_ID_VALIDATOR
            ? TextInputType.number
            : TextInputType.text,
        textInputAction: TextInputAction.next,
        style: const TextStyle(color: Colors.white),
        key: wkey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: _fieldValidator(index),
      ),
    );
  }

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
                    isGoogleSignUp = true;
                    _handleSignUp(context);
                  },
                  backgroundColor: Colors.white,
                ));
          }

          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              backgroundColor: const Color(0xff006d77),
              body: ValueListenableBuilder<Response>(
                  valueListenable: _responseNotifier,
                  builder: (BuildContext context, Response _response,
                      Widget? child) {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: 16.0.horizontalPadding,
                        child: Form(
                          key: _formKey,
                          onChanged: () {
                            setState(() {});
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                              _csField(_formFieldKeys[0], 'Name',
                                  _nameController, NAME_VALIDATOR),
                              _csField(_formFieldKeys[1], 'email',
                                  _emailController, EMAIL_VALIDATOR),
                              _csField(_formFieldKeys[2], 'Student Id',
                                  _studentIdController, STUDENT_ID_VALIDATOR),
                              _csField(_formFieldKeys[3], 'Password',
                                  _passwordController, PASSWORD_VALIDATOR),
                              48.0.vSpacer(),
                              CSButton(
                                  height: 48,
                                  isLoading: !isGoogleSignUp &&
                                      _response.state == RequestState.active,
                                  onTap: _isValid()
                                      ? () {
                                          isGoogleSignUp = false;
                                          _handleSignUp(context);
                                        }
                                      : null,
                                  label: 'SignUp'),
                              16.0.vSpacer(),
                              // or divider
                              const Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'or',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20), _signUpWithGoogle(),
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
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                          text: 'Sign In',
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigate.pushAndPopAll(
                                                  context, const LoginPage());
                                            },
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
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
          );
        });
  }
}
