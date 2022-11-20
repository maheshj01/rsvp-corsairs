import 'package:animations/animations.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:navbar_router/navbar_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rsvp/constants/constants.dart';
import 'package:rsvp/models/event.dart';
import 'package:rsvp/navbar/events/add_event.dart';
import 'package:rsvp/services/api/appstate.dart';
import 'package:rsvp/services/event_service.dart';
import 'package:rsvp/themes/theme.dart';
import 'package:rsvp/utils/utility.dart';
import 'package:rsvp/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

import 'navbar/events/event_detail.dart';
import 'navbar/navbar.dart';

const appBarDesktopHeight = 128.0;
TextEditingController searchController = TextEditingController();

class AdaptiveLayout extends StatefulWidget {
  const AdaptiveLayout({Key? key}) : super(key: key);

  @override
  State<AdaptiveLayout> createState() => _AdaptiveLayoutState();
}

class _AdaptiveLayoutState extends State<AdaptiveLayout> {
  @override
  void initState() {
    super.initState();
    getEvents();
    isUpdateAvailable();
  }

  Future<void> getEvents() async {
    final events = await EventService.getAllEvents();
    if (events.isNotEmpty) {
      AppStateWidget.of(context).setEvents(events);
    }
  }

  Future<void> isUpdateAvailable() async {
    final packageInfo = await PackageInfo.fromPlatform();
    String appVersion = packageInfo.version;
    int appBuildNumber = int.parse(packageInfo.buildNumber);
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(seconds: 1),
    ));
    await remoteConfig.fetchAndActivate();
    final version = remoteConfig.getString(VERSION_KEY);
    final buildNumber = remoteConfig.getInt(BUILD_NUMBER_KEY);
    if (appVersion != version || buildNumber > appBuildNumber) {
      hasUpdate = true;
    } else {
      hasUpdate = false;
    }
    // todo: remove this line once ready
    hasUpdate = false;
    setState(() {});
  }

  late AppState state;

  bool animatePageOnce = false;
  DateTime oldTime = DateTime.now();
  DateTime newTime = DateTime.now();
  final ValueNotifier<int> _selectedIndex = ValueNotifier<int>(0);

  @override
  void dispose() {
    _selectedIndex.dispose();
    super.dispose();
  }

  double bannerHeight = 0;
  bool hasUpdate = false;

  @override
  Widget build(BuildContext context) {
    SizeUtils.size = MediaQuery.of(context).size;
    List<NavbarItem> items = const [
      NavbarItem(Icons.event, 'Events'),
      NavbarItem(Icons.leaderboard, 'Leaderboard'),
      NavbarItem(Icons.people, 'Profile'),
    ];

    final Map<int, Map<String, Widget>> _routes = {
      0: {
        CorsairEvents.route: const CorsairEvents(),
        EventDetail.route: EventDetail(event: Event.init()),
      },
      1: {
        LeaderBoard.route: const LeaderBoard(),
      },
      2: {UserProfile.route: const UserProfile()},
    };

    final user = AppStateScope.of(context).user;

    if (!user!.isLoggedIn || hasUpdate) {
      bannerHeight =
          kBottomNavigationBarHeight + MediaQuery.of(context).padding.bottom;
    } else {
      bannerHeight = 0;
    }
    return ValueListenableBuilder<int>(
        valueListenable: _selectedIndex,
        builder: (context, int currentIndex, Widget? child) {
          bannerHeight = kBottomNavigationBarHeight +
              MediaQuery.of(context).padding.bottom;
          return Scaffold(
            resizeToAvoidBottomInset: false,
            floatingActionButton: hasUpdate
                ? null
                : Padding(
                    padding: (kBottomNavigationBarHeight * 0.9).bottomPadding,
                    child: OpenContainer<bool>(
                        openBuilder:
                            (BuildContext context, VoidCallback openContainer) {
                          return AddEvent();
                        },
                        tappable: true,
                        closedShape: 22.0.rounded,
                        openShape: 22.0.rounded,
                        transitionType: ContainerTransitionType.fadeThrough,
                        closedBuilder:
                            (BuildContext context, VoidCallback openContainer) {
                          return FloatingActionButton.extended(
                              shape: 22.0.rounded,
                              isExtended: true,
                              icon: const Icon(Icons.music_note,
                                  color: CorsairsTheme.primaryYellow, size: 28),
                              backgroundColor: CorsairsTheme.primaryColor,
                              onPressed: null,
                              label: const Text(
                                'Host Event',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: CorsairsTheme.primaryYellow,
                                  fontWeight: FontWeight.w600,
                                ),
                              ));
                        }),
                  ),
            body: Stack(
              children: [
                NavbarRouter(
                  errorBuilder: (context) {
                    return const Center(child: Text('Error 404'));
                  },
                  onBackButtonPressed: (isExiting) {
                    if (isExiting) {
                      newTime = DateTime.now();
                      int difference =
                          newTime.difference(oldTime).inMilliseconds;
                      oldTime = newTime;
                      if (difference < 1000) {
                        hideToast();
                        return isExiting;
                      } else {
                        showToast('Press back button to exit');
                        return false;
                      }
                    } else {
                      return isExiting;
                    }
                  },
                  isDesktop: !SizeUtils.isMobile,
                  destinationAnimationCurve: Curves.fastOutSlowIn,
                  destinationAnimationDuration: 600,
                  onChanged: (x) {},
                  decoration: NavbarDecoration(
                      backgroundColor: CorsairsTheme.primaryBlue,
                      isExtended: SizeUtils.isExtendedDesktop,
                      // showUnselectedLabels: false,
                      unselectedItemColor: Colors.white38,
                      selectedLabelTextStyle: const TextStyle(
                          fontSize: 12, color: CorsairsTheme.primaryYellow),
                      unselectedLabelTextStyle: const TextStyle(fontSize: 10),
                      navbarType: BottomNavigationBarType.fixed),
                  destinations: [
                    for (int i = 0; i < items.length; i++)
                      DestinationRouter(
                        navbarItem: items[i],
                        destinations: [
                          for (int j = 0; j < _routes[i]!.keys.length; j++)
                            Destination(
                              route: _routes[i]!.keys.elementAt(j),
                              widget: _routes[i]!.values.elementAt(j),
                            ),
                        ],
                        initialRoute: _routes[i]!.keys.elementAt(0),
                      ),
                  ],
                ),
                if (hasUpdate)
                  AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      bottom: bannerHeight,
                      left: 0,
                      right: 0,
                      child: VocabBanner(
                        description: hasUpdate
                            ? 'New update available'
                            : 'Sign in for better experience',
                        actions: [
                          !hasUpdate
                              ? const SizedBox.shrink()
                              : TextButton(
                                  onPressed: () {
                                    launchUrl(Uri.parse(PLAY_STORE_URL),
                                        mode: LaunchMode.externalApplication);
                                  },
                                  child: Text('Update',
                                      style: TextStyle(
                                        color: CorsairsTheme.primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      )),
                                ),
                          user.isLoggedIn
                              ? const SizedBox.shrink()
                              : TextButton(
                                  onPressed: () async {},
                                  child: Text('Sign In',
                                      style: TextStyle(
                                        color: CorsairsTheme.primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      )),
                                ),
                        ],
                      ))
              ],
            ),
          );
        });
  }
}

class VocabBanner extends StatelessWidget {
  final String description;
  final List<Widget> actions;

  const VocabBanner(
      {Key? key, required this.description, required this.actions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.grey.shade800,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            description,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          16.0.hSpacer(),
          for (int i = 0; i < actions.length; i++) actions[i]
        ],
      ),
    );
  }
}

class DesktopHome extends StatefulWidget {
  const DesktopHome({Key? key}) : super(key: key);

  @override
  State<DesktopHome> createState() => _DesktopHomeState();
}

class _DesktopHomeState extends State<DesktopHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Container(
              color: Colors.red,
              child: const Center(
                child: Text('Desktop Home'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScrollableEvent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DraggableScrollableSheet'),
      ),
      body: SizedBox.expand(
        child: DraggableScrollableSheet(
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              color: Colors.blue[100],
              child: ListView.builder(
                controller: scrollController,
                itemCount: 25,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(title: Text('Item $index'));
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
