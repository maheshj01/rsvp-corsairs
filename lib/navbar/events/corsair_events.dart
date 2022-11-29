import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:navbar_router/navbar_router.dart';
import 'package:rsvp/navbar/events/event_detail.dart';
import 'package:rsvp/navbar/events/notifications.dart';
import 'package:rsvp/services/api/appstate.dart';
import 'package:rsvp/services/event_service.dart';
import 'package:rsvp/themes/theme.dart';
import 'package:rsvp/utils/extensions.dart';
import 'package:rsvp/utils/navigator.dart';
import 'package:rsvp/utils/responsive.dart';
import 'package:rsvp/utils/size_utils.dart';
import 'package:rsvp/widgets/event_parallax.dart';

class CorsairEvents extends StatefulWidget {
  static String route = '/';
  const CorsairEvents({Key? key}) : super(key: key);

  @override
  State<CorsairEvents> createState() => _CorsairEventsState();
}

class _CorsairEventsState extends State<CorsairEvents> {
  /// todo word of the day
  // Future<void> publishWordOfTheDay() async {
  //   final Event word = await VocabStoreService.getLastUpdatedRecord();
  //   final state = AppStateWidget.of(context);
  //   final now = DateTime.now().toUtc();
  //   if (now.difference(word.created_at!.toUtc()).inHours > 24) {
  //     final allWords = await VocabStoreService.getAllWords();
  //     final random = Random();
  //     final randomWord = allWords[random.nextInt(allWords.length)];
  //     final wordOfTheDay = {
  //       'word': randomWord.word,
  //       'id': randomWord.id,
  //       'created_at': now.toIso8601String()
  //     };
  //     final resp = await DatabaseService.insertIntoTable(
  //       wordOfTheDay,
  //       table: WORD_OF_THE_DAY_TABLE_NAME,
  //     );
  //     if (resp.status == 201) {
  //       print('word of the day published');
  //       state.setWordOfTheDay(randomWord);
  //     } else {
  //       throw Exception('word of the day not published');
  //     }
  //   } else {
  //     state.setWordOfTheDay(word);
  //     print('word of the day already published');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: ResponsiveBuilder(
      desktopBuilder: (context) => const CorsairEventsDesktop(),
      mobileBuilder: (context) => const CorsairEventsMobile(),
    ));
  }
}

class CorsairEventsMobile extends StatefulWidget {
  static String route = '/';
  const CorsairEventsMobile({Key? key}) : super(key: key);

  @override
  State<CorsairEventsMobile> createState() => _CorsairEventsMobileState();
}

class _CorsairEventsMobileState extends State<CorsairEventsMobile> {
  final ScrollController _scrollController = ScrollController();
  late ScrollDirection _lastScrollDirection;
  late double _lastScrollOffset;
  @override
  void initState() {
    super.initState();
    _lastScrollDirection = ScrollDirection.idle;
    _lastScrollOffset = 0;
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection !=
          _lastScrollDirection) {
        _lastScrollDirection = _scrollController.position.userScrollDirection;
        _lastScrollOffset = _scrollController.offset;
      }
      double difference = (_scrollController.offset - _lastScrollOffset).abs();
      if (difference > _offsetThreshold) {
        _lastScrollOffset = _scrollController.offset;
        if (_scrollController.position.userScrollDirection ==
            ScrollDirection.forward) {
          NavbarNotifier.hideBottomNavBar = false;
        } else {
          NavbarNotifier.hideBottomNavBar = true;
        }
      }
    });
  }

  Future<void> getEvents() async {
    final events = await EventService.getAllEvents();
    if (events.isNotEmpty) {
      AppStateWidget.of(context).setEvents(events);
    } else {
      AppStateWidget.of(context).setEvents([]);
    }
  }

  final double _offsetThreshold = 50.0;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    final user = AppStateScope.of(context).user;
    final events = AppStateScope.of(context).events ?? [];

    return NestedScrollView(
      controller: _scrollController,
      headerSliverBuilder: (context, innerBoxScrolled) => [
        SliverAppBar(
            pinned: false,
            expandedHeight: 80.0,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              background: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 16, top: 16),
                child: Text(
                  'CorsairEvents',
                  style: CorsairsTheme.googleFontsTextTheme.titleSmall!
                      .copyWith(fontSize: 28, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigate.push(context, const NotificationsPage(),
                        slideTransitionType: TransitionType.rtl);
                  },
                  icon: const Icon(
                    Icons.notifications_on,
                    color: CorsairsTheme.primaryYellow,
                  )),
              IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        barrierColor: Colors.transparent,
                        useRootNavigator: false,
                        builder: (context) => const NewPage());
                  },
                  icon: const Icon(
                    Icons.search,
                    color: CorsairsTheme.primaryYellow,
                  ))
            ]),
      ],
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          await getEvents();
        },
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemBuilder: (_, index) {
            // Navigate.push(context, EventDetail(event: events[index]));
            return OpenContainer<bool>(
                openBuilder:
                    (BuildContext context, VoidCallback openContainer) {
                  return EventDetail(event: events[index]);
                },
                tappable: true,
                closedShape: 22.0.rounded,
                openShape: 22.0.rounded,
                transitionType: ContainerTransitionType.fadeThrough,
                closedBuilder:
                    (BuildContext context, VoidCallback openContainer) {
                  return Animate(
                    effects: [
                      SlideEffect(
                        // begin based on index of item
                        begin: Offset(0, 0.8 * index),
                        end: const Offset(0, 0),
                        duration: const Duration(milliseconds: 500),
                      ),
                    ],
                    child: EventParallaxTile(
                      event: events[index],
                    ),
                  );
                });
          },
          itemCount: events.length,
        ),
      ),
    );
    // return CustomScrollView(
    //   controller: _scrollController,
    //   slivers: <Widget>[
    //     SliverAppBar(
    //         pinned: false,
    //         expandedHeight: 80.0,
    //         flexibleSpace: FlexibleSpaceBar(
    //           centerTitle: true,
    //           background: Container(
    //             alignment: Alignment.centerLeft,
    //             padding: const EdgeInsets.only(left: 16, top: 16),
    //             child: Text(
    //               'CorsairEvents',
    //               style: CorsairsTheme.googleFontsTextTheme.titleSmall!
    //                   .copyWith(fontSize: 28, fontWeight: FontWeight.w700),
    //             ),
    //           ),
    //         ),
    //         actions: [
    //           IconButton(
    //               onPressed: () {
    //                 Navigate.push(context, const NotificationsPage(),
    //                     slideTransitionType: TransitionType.rtl);
    //               },
    //               icon: const Icon(
    //                 Icons.notifications_on,
    //                 color: CorsairsTheme.primaryYellow,
    //               )),
    //           IconButton(
    //               onPressed: () {
    //                 showModalBottomSheet(
    //                     context: context,
    //                     isScrollControlled: true,
    //                     barrierColor: Colors.transparent,
    //                     useRootNavigator: false,
    //                     builder: (context) => const NewPage());
    //               },
    //               icon: const Icon(
    //                 Icons.search,
    //                 color: CorsairsTheme.primaryYellow,
    //               ))
    //         ]),
    //     SliverList(
    //         delegate: SliverChildListDelegate([
    //       for (EventModel event in events)
    //         InkWell(
    //           onTap: () {
    //             Navigate.push(context, EventDetail(event: event));
    //           },
    //           child: EventParallaxTile(
    //             event: event,
    //           ),
    //         ),
    //     ])),
    //     SliverToBoxAdapter(
    //       child: 100.0.vSpacer(),
    //     )
    //   ],
    // );
  }
}

class CorsairEventsDesktop extends StatelessWidget {
  static String route = '/';
  const CorsairEventsDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: const [
                Center(
                  child: Text('CorsairEvents Desktop'),
                ),
              ],
            ),
          ),
          SizedBox(
              height: SizeUtils.size.height * 0.5,
              width: 400,
              child: Column(
                children: [
                  Expanded(child: Container()),
                ],
              ))
        ],
      ),
    );
  }
}

class NewPage extends StatefulWidget {
  const NewPage({Key? key}) : super(key: key);

  @override
  State<NewPage> createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Material(
      child: SizedBox(
          height: size.height * 0.9,
          child: ListView(
            children: [
              for (int i = 0; i < 100; i++)
                ListTile(
                    title: Text('Item $i'),
                    onTap: () {
                      Navigator.of(context).pop();
                    })
            ],
          )),
    );
  }
}
