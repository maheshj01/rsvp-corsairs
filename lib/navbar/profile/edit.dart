import 'package:flutter/material.dart';
import 'package:rsvp/constants/const.dart';
import 'package:rsvp/models/user.dart';
import 'package:rsvp/services/api/appstate.dart';
import 'package:rsvp/services/api/user.dart';
import 'package:rsvp/services/database.dart';
import 'package:rsvp/themes/theme.dart';
import 'package:rsvp/utils/extensions.dart';
import 'package:rsvp/utils/responsive.dart';
import 'package:rsvp/utils/utility.dart';
import 'package:rsvp/widgets/button.dart';
import 'package:rsvp/widgets/circle_avatar.dart';

class EditProfile extends StatefulWidget {
  final UserModel? user;
  final VoidCallback? onClose;

  static const String route = '/';
  const EditProfile({Key? key, required this.user, this.onClose})
      : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      desktopBuilder: (context) => const EditProfileDesktop(),
      mobileBuilder: (context) => EditProfileMobile(
        onClose: widget.onClose,
      ),
    );
  }
}

class EditProfileMobile extends StatefulWidget {
  final VoidCallback? onClose;

  const EditProfileMobile({Key? key, this.onClose}) : super(key: key);

  @override
  State<EditProfileMobile> createState() => _EditProfileMobileState();
}

class _EditProfileMobileState extends State<EditProfileMobile> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final user = AppStateScope.of(context).user;
      _nameController.text = user!.name;
      _usernameController.text = user.username;
      _emailController.text = user.email;
      _joinedController.text = user.created_at!.formatDate();
    });
  }

  final ValueNotifier<bool?> _validNotifier = ValueNotifier<bool?>(null);
  final ValueNotifier<Response> _requestNotifier = ValueNotifier<Response>(
      Response(state: RequestState.none, didSucced: false, message: 'Failed'));
  String error = '';
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _joinedController = TextEditingController();

  @override
  void dispose() {
    _validNotifier.dispose();
    _requestNotifier.dispose();
    super.dispose();
  }

  Future<void> validateUsername(String username) async {
    _validNotifier.value = null;
    RegExp usernamePattern = RegExp(r"^[a-zA-Z0-9_]{5,}$");
    if (!usernamePattern.hasMatch(username)) {
      error =
          'Username should contain letters, numbers and underscores with minimum 5 characters';
      _validNotifier.value = false;
      return;
    } else {
      final bool isUsernameValid = await UserService.isUsernameValid(username);
      if (isUsernameValid) {
        error = 'Username is available';
      } else {
        error = 'Username is not available';
      }
      _validNotifier.value = isUsernameValid;
    }
  }

  UserModel? user;
  @override
  Widget build(BuildContext context) {
    final appState = AppStateWidget.of(context);
    user = AppStateScope.of(context).user;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: ValueListenableBuilder<Response>(
          valueListenable: _requestNotifier,
          builder: (BuildContext context, Response request, Widget? child) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: 16.0.topHorizontalPadding,
                      child: CircleAvatar(
                          radius: 46,
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.2),
                          child: CircularAvatar(
                            url: '${user!.avatarUrl}',
                            radius: 40,
                          )),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      child: const Text('Edit Avatar'),
                      onPressed: () {},
                    ),
                  ),
                  VHTextfield(
                    hint: 'Name',
                    controller: _nameController,
                    isReadOnly: true,
                  ),
                  ValueListenableBuilder<bool?>(
                      valueListenable: _validNotifier,
                      builder:
                          (BuildContext context, bool? isValid, Widget? child) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            VHTextfield(
                              hint: 'Username',
                              isReadOnly: request.state == RequestState.active,
                              controller: _usernameController,
                              onChanged: (username) {
                                user = AppStateScope.of(context).user;
                                if (user!.username == username) {
                                  _validNotifier.value = null;
                                  return;
                                }
                                validateUsername(username);
                              },
                            ),
                            isValid == null
                                ? const SizedBox.shrink()
                                : Padding(
                                    padding: 16.0.bottomLeftPadding,
                                    child: Text(error,
                                        style: TextStyle(
                                            color: isValid
                                                ? CorsairsTheme.primaryColor
                                                : CorsairsTheme.rejectedColor)),
                                  ),
                          ],
                        );
                      }),
                  VHTextfield(
                    hint: 'Email',
                    controller: _emailController,
                    isReadOnly: true,
                  ),
                  VHTextfield(
                    hint: 'Joined',
                    controller: _joinedController,
                    isReadOnly: true,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: 16.0.allPadding,
                      child: CSButton(
                          height: 48,
                          backgroundColor: CorsairsTheme.primaryColor,
                          foregroundColor: Colors.white,
                          isLoading: request.state == RequestState.active,
                          onTap: () async {
                            _requestNotifier.value = _requestNotifier.value
                                .copyWith(state: RequestState.active);
                            final userName = _usernameController.text.trim();
                            final editedUser =
                                user!.copyWith(username: userName);
                            final success =
                                await UserService.updateUser(editedUser);
                            if (success) {
                              _requestNotifier.value = _requestNotifier.value
                                  .copyWith(state: RequestState.done);
                              _validNotifier.value = null;
                              appState.setUser(editedUser);
                              showMessage(context, 'success updating user! ');
                              Navigator.of(context).pop();
                              widget.onClose!();
                            }
                          },
                          label: 'Save'),
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}

class EditProfileDesktop extends StatefulWidget {
  const EditProfileDesktop({Key? key}) : super(key: key);

  @override
  State<EditProfileDesktop> createState() => _EditProfileDesktopState();
}

class _EditProfileDesktopState extends State<EditProfileDesktop> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Edit Profile Desktop'),
      ),
    );
  }
}

class VHTextfield extends StatefulWidget {
  final String hint;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool isReadOnly;
  final bool hasLabel;
  final int maxLines;
  final Function(String)? onChanged;

  const VHTextfield(
      {super.key,
      required this.hint,
      this.controller,
      this.isReadOnly = false,
      this.hasLabel = true,
      this.onChanged,
      this.maxLines = 1,
      this.keyboardType = TextInputType.text});

  @override
  State<VHTextfield> createState() => _VHTextfieldState();
}

class _VHTextfieldState extends State<VHTextfield> {
  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  late TextEditingController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        !widget.hasLabel
            ? const SizedBox.shrink()
            : Padding(
                padding: 16.0.horizontalPadding,
                child: Text(
                  widget.hint,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: TextField(
            controller: _controller,
            keyboardType: widget.keyboardType,
            readOnly: widget.isReadOnly,
            maxLines: widget.maxLines,
            onChanged: (x) {
              if (widget.onChanged != null) {
                widget.onChanged!(x);
              }
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.hint,
            ),
          ),
        ),
        if (widget.hasLabel) 6.0.vSpacer()
      ],
    );
  }
}