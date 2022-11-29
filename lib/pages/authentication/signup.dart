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
import 'package:rsvp/themes/theme.dart';
import 'package:rsvp/utils/extensions.dart';
import 'package:rsvp/utils/logger.dart';
import 'package:rsvp/utils/navigator.dart';
import 'package:rsvp/utils/settings.dart';
import 'package:rsvp/utils/size_utils.dart';
import 'package:rsvp/utils/utility.dart';
import 'package:rsvp/widgets/button.dart';
import 'package:rsvp/widgets/widgets.dart';

class SignUp extends StatefulWidget {
  final UserModel? newUser;
  const SignUp({Key? key, this.newUser}) : super(key: key);

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
        user = (await auth.googleSignIn())!;
      } else {
        user = _buildUserModel();
      }
      if (user != null) {
        final existingUser =
            await UserService.findByUsername(username: user!.email);
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
          _responseNotifier.value = _responseNotifier.value.copyWith(
              state: RequestState.done,
              didSucced: true,
              message: 'User already exists',
              data: existingUser);
          throw 'User with email ${user!.email} already exists';
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
    final registerUser = UserModel.init();
    registerUser.email = _emailController.text.trim();
    registerUser.password = _passwordController.text.trim();
    registerUser.name = _nameController.text.trim();
    registerUser.studentId = _studentIdController.text.trim();
    registerUser.username = registerUser.email.split('@')[0];
    if (widget.newUser != null) {
      registerUser.accessToken = widget.newUser!.accessToken;
      registerUser.idToken = widget.newUser!.idToken;
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
    super.initState();
  }

  void populateFields() {
    _emailController.text = widget.newUser!.email;
    _nameController.text = widget.newUser!.name;
    _studentIdController.text = widget.newUser!.studentId;
    user = widget.newUser;
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
          hintText: hint,
          counterText: '',
        ),
        obscureText: index == PASSWORD_VALIDATOR,
        obscuringCharacter: obscureCharacter,
        maxLength: index == STUDENT_ID_VALIDATOR ? 8 : null,
        keyboardType: keyboardType(index),
        textInputAction: TextInputAction.next,
        style: const TextStyle(color: Colors.white),
        key: wkey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: fieldValidator(index),
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
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                ));
          }

          return GestureDetector(
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
                            _csField(_formFieldKeys[0], 'Name', _nameController,
                                NAME_VALIDATOR),
                            _csField(_formFieldKeys[1], 'email',
                                _emailController, EMAIL_VALIDATOR),
                            _csField(_formFieldKeys[2], 'Student Id',
                                _studentIdController, STUDENT_ID_VALIDATOR),
                            _csField(_formFieldKeys[3], 'Password',
                                _passwordController, PASSWORD_VALIDATOR),
                            48.0.vSpacer(),
                            CSButton(
                                height: 48,
                                backgroundColor: CorsairsTheme.primaryYellow,
                                isLoading: !isGoogleSignUp &&
                                    _response.state == RequestState.active,
                                onTap: _isValid()
                                    ? () {
                                        removeFocus(context);
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
                                        )),
                                    TextSpan(
                                        text: 'Sign In',
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigate.pushAndPopAll(
                                                context, const LoginPage());
                                          },
                                        style: const TextStyle(
                                            color: CorsairsTheme.primaryYellow,
                                            fontSize: 16,
                                            decoration:
                                                TextDecoration.underline))
                                  ]))),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          );
        });
  }
}
