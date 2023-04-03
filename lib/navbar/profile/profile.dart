import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:rsvp/constants/const.dart';
import 'package:rsvp/constants/strings.dart';
import 'package:rsvp/navbar/pageroute.dart';
import 'package:rsvp/navbar/profile/edit.dart';
import 'package:rsvp/navbar/profile/settings.dart';
import 'package:rsvp/services/api/appstate.dart';
import 'package:rsvp/services/api/user.dart';
import 'package:rsvp/services/database.dart';
import 'package:rsvp/themes/theme.dart';
import 'package:rsvp/utils/extensions.dart';
import 'package:rsvp/widgets/circle_avatar.dart';
import 'package:rsvp/widgets/icon.dart';
import 'package:rsvp/widgets/widgets.dart';

class UserProfile extends StatefulWidget {
  static const String route = '/';
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> getUser() async {
    await Future.delayed(Duration.zero);
    final userState = AppStateScope.of(context).user;
    if (userState!.isLoggedIn) {
      final user = await UserService.findByUsername(username: userState.email);
      if (user.email.isNotEmpty) {
        AppStateWidget.of(context).setUser(user);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return UserProfileMobile();
  }
}

class UserProfileMobile extends StatefulWidget {
  bool isReadOnly;
  final String? email;
  UserProfileMobile({Key? key, this.email, this.isReadOnly = false})
      : super(key: key);

  @override
  State<UserProfileMobile> createState() => _UserProfileMobileState();
}

class _UserProfileMobileState extends State<UserProfileMobile> {
  Future<void> getUserProfile(String email) async {
    _statsNotifier.value =
        _statsNotifier.value.copyWith(state: RequestState.active);
    final userModel = UserService.findByUsername(
      username: email,
    );
    _statsNotifier.value = _statsNotifier.value
        .copyWith(data: userModel, state: RequestState.done);
  }

  @override
  void initState() {
    super.initState();
    if (widget.isReadOnly) {
      getUserProfile(widget.email!);
    }
  }

  @override
  void dispose() {
    _statsNotifier.dispose();
    super.dispose();
  }

  final ValueNotifier<Response> _statsNotifier = ValueNotifier(Response.init());
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    final user = AppStateScope.of(context).user;
    return Scaffold(
        body: Center(
      child: ValueListenableBuilder<Response>(
          valueListenable: _statsNotifier,
          builder: (BuildContext context, Response response, Widget? child) {
            if (user == null || (response.state == RequestState.active)) {
              return const LoadingWidget();
            } else {
              return RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: () async {
                  await getUserProfile(user.email);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: ListView(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: widget.isReadOnly
                            ? const BackButton()
                            : const SizedBox.shrink(),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: 16.0.allRadius,
                            border: Border.all(
                                color: CorsairsTheme.primaryColor
                                    .withOpacity(0.5))),
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: 18.0.verticalPadding,
                            child: Column(
                              children: [
                                widget.isReadOnly
                                    ? const SizedBox.shrink()
                                    : Container(
                                        alignment: Alignment.topRight,
                                        child: Padding(
                                          padding: 16.0.horizontalPadding,
                                          child: VHIcon(
                                            Icons.settings,
                                            size: 38,
                                            onTap: () {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .push(PageRoutes.sharedAxis(
                                                      const SettingsPageMobile(),
                                                      SharedAxisTransitionType
                                                          .horizontal));
                                            },
                                          ),
                                        ),
                                      ),
                                Stack(
                                  children: [
                                    Padding(
                                      padding: 16.0.allPadding,
                                      child: CircleAvatar(
                                          radius: 46,
                                          backgroundColor: const Color.fromARGB(
                                                  255, 25, 79, 172)
                                              .withOpacity(0.8),
                                          child: CircularAvatar(
                                            url: user.avatarUrl ??
                                                defaultAvatarUrl,
                                            name: user.name.initials(),
                                            radius: 40,
                                          )),
                                    ),
                                    widget.isReadOnly
                                        ? const SizedBox.shrink()
                                        : Positioned(
                                            right: 8,
                                            bottom: 16,
                                            child: VHIcon(Icons.edit, size: 30,
                                                onTap: () {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .push(
                                                PageRoutes.sharedAxis(
                                                  EditProfile(
                                                    user: user,
                                                  ),
                                                  SharedAxisTransitionType
                                                      .scaled,
                                                ),
                                              );
                                            }))
                                  ],
                                ),
                                Padding(
                                    padding: 8.0.horizontalPadding,
                                    child: Text('@${user.username} ' +
                                        (!user.isAdmin
                                            ? ' (User)'
                                            : '(Admin)'))),
                                Text(
                                  '${user.name.capitalize()}',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium!
                                      .copyWith(
                                          fontSize: 26,
                                          fontWeight: FontWeight.w500),
                                ),
                                10.0.vSpacer(),
                                RichText(
                                    text: TextSpan(children: [
                                  TextSpan(
                                      text: 'Joined ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12)),
                                  TextSpan(
                                    text: user.created_at!.formatDate(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ])),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // 16.0.vSpacer(),
                      // Container(
                      //     alignment: Alignment.centerLeft,
                      //     child: heading('Stats')),
                      16.0.vSpacer(),

                      /// rounded Container with border

                      Container(
                        height: 80,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: 16.0.allRadius,
                            border: Border.all(
                                color: CorsairsTheme.primaryColor
                                    .withOpacity(0.5))),
                        child: Row(
                          children: [
                            for (int i = 0; i < 3; i++)
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      i == 0
                                          ? Icons.star_rounded
                                          : i == 1
                                              ? Icons.event
                                              : Icons.bookmark,
                                      color: CorsairsTheme.primaryYellow,
                                      size: 28,
                                    ),
                                    Text(
                                      '${user.reputation}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium!
                                          .copyWith(
                                              fontSize: 28,
                                              fontWeight: FontWeight.w500),
                                    ),
                                    4.0.vSpacer(),
                                    Text(
                                      i == 0
                                          ? 'Events Attended'
                                          : i == 1
                                              ? 'Events Hosted'
                                              : 'Bookmarks',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
          }),
    ));
  }
}

class UserProfileDesktop extends StatelessWidget {
  const UserProfileDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Desktop'),
      ),
      body: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: 20,
          itemBuilder: (BuildContext context, int x) {
            return ListTile(
              title: Text('item $x'),
            );
          }),
    );
  }
}
