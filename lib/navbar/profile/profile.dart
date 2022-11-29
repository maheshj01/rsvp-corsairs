import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:rsvp/navbar/pageroute.dart';
import 'package:rsvp/navbar/profile/edit.dart';
import 'package:rsvp/navbar/profile/settings.dart';
import 'package:rsvp/services/api/appstate.dart';
import 'package:rsvp/services/api/user.dart';
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
    return const UserProfileMobile();
  }
}

class UserProfileMobile extends StatefulWidget {
  const UserProfileMobile({Key? key}) : super(key: key);

  @override
  State<UserProfileMobile> createState() => _UserProfileMobileState();
}

class _UserProfileMobileState extends State<UserProfileMobile> {
  Future<void> getEditStats() async {
    _statsNotifier.value = stats;
  }

  List<int> stats = [0, 0, 0];

  @override
  void initState() {
    super.initState();
    getEditStats();
  }

  @override
  void dispose() {
    _statsNotifier.dispose();
    super.dispose();
  }

  final ValueNotifier<List<int>> _statsNotifier = ValueNotifier([0, 0, 0]);
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    final user = AppStateScope.of(context).user;
    return Scaffold(
        body: Center(
      child: user == null
          ? const LoadingWidget()
          : ValueListenableBuilder<List<int>>(
              valueListenable: _statsNotifier,
              builder: (BuildContext context, List<int> stats, Widget? child) {
                return RefreshIndicator(
                  key: _refreshIndicatorKey,
                  onRefresh: () async {
                    await getEditStats();
                    setState(() {});
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: ListView(
                      children: [
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
                                  Container(
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
                                            backgroundColor:
                                                const Color.fromARGB(
                                                        255, 25, 79, 172)
                                                    .withOpacity(0.8),
                                            child: CircularAvatar(
                                              url: '${user.avatarUrl}',
                                              name: user.name.initals(),
                                              radius: 40,
                                            )),
                                      ),
                                      Positioned(
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
                                                SharedAxisTransitionType.scaled,
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
                                          .copyWith(
                                              fontWeight: FontWeight.w600),
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
                              for (int i = 0; i < stats.length; i++)
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${stats[i]}',
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
