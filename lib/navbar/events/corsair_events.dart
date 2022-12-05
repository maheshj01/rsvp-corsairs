import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:navbar_router/navbar_router.dart';
import 'package:rsvp/navbar/events/event_detail.dart';
import 'package:rsvp/navbar/events/notifications.dart';
import 'package:rsvp/navbar/events/search.dart';
import 'package:rsvp/navbar/pageroute.dart';
import 'package:rsvp/services/api/appstate.dart';
import 'package:rsvp/services/event_service.dart';
import 'package:rsvp/themes/theme.dart';
import 'package:rsvp/utils/responsive.dart';
import 'package:rsvp/utils/size_utils.dart';
import 'package:rsvp/widgets/event_tile.dart';

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
  String selected = 'All';
  @override
  Widget build(BuildContext context) {
    final events = AppStateScope.of(context).events ?? [];
    final user = AppStateScope.of(context).user;
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxScrolled) => [
        SliverAppBar(
            pinned: false,
            floating: true,
            expandedHeight: 60.0,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              background: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 16, top: 16),
                child: Text(
                  'Corsair Events',
                  style: CorsairsTheme.googleFontsTextTheme.titleSmall!
                      .copyWith(fontSize: 28, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).push(
                        PageRoutes.sharedAxis(const NotificationsPage(),
                            SharedAxisTransitionType.horizontal));
                  },
                  icon: const Icon(
                    Icons.notifications_on,
                    color: CorsairsTheme.primaryYellow,
                  )),
              IconButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).push(
                        PageRoutes.sharedAxis(const EventsSearch(),
                            SharedAxisTransitionType.horizontal));
                  },
                  icon: const Icon(
                    Icons.search,
                    color: CorsairsTheme.primaryYellow,
                  ))
            ]),
        SliverToBoxAdapter(
          // Horizontal selectable chips
          child: SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                const SizedBox(
                  width: 16,
                ),
                CorsairChip(
                  label: 'All',
                  selected: selected == 'All',
                  onSelected: (x) {
                    setState(() {
                      selected = 'All';
                    });
                  },
                ),
                const SizedBox(
                  width: 16,
                ),
                CorsairChip(
                  label: 'Going',
                  selected: selected == 'Going',
                  onSelected: (x) {
                    setState(() {
                      selected = 'Going';
                    });
                  },
                ),
                const SizedBox(
                  width: 16,
                ),
                CorsairChip(
                  label: 'My Events',
                  selected: selected == 'My Events',
                  onSelected: (x) {
                    setState(() {
                      selected = 'My Events';
                    });
                  },
                ),
                const SizedBox(
                  width: 16,
                ),
                CorsairChip(
                  label: 'Past Events',
                  selected: selected == 'Past Events',
                  onSelected: (x) {
                    setState(() {
                      selected = 'Past Events';
                    });
                  },
                ),
              ],
            ),
          ),
        )
      ],
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        color: CorsairsTheme.primaryYellow,
        onRefresh: () async {
          await getEvents();
        },
        child: ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.only(bottom: 24),
          itemBuilder: (_, index) {
            return OpenContainer<bool>(
                openBuilder:
                    (BuildContext context, VoidCallback openContainer) {
                  return EventDetail(event: events[index]);
                },
                tappable: true,
                openElevation: 0.0,
                transitionType: ContainerTransitionType.fadeThrough,
                useRootNavigator: true,
                closedBuilder:
                    (BuildContext context, VoidCallback openContainer) {
                  return Animate(
                    effects: [
                      ScaleEffect(
                        delay: Duration(milliseconds: 100 * (index % 4)),
                        begin: Offset(0.6, 0.05 * index),
                        end: const Offset(1, 1),
                      )
                    ],
                    child: EventTile(
                      event: events[index],
                      onBookmarkTap: () async {
                        final resp = await EventService.updateBookMark(
                            events[index].id!, user!.id!,
                            add: !events[index].bookmark!);
                        if (resp.didSucced) {
                          setState(() {
                            events[index].bookmark = !events[index].bookmark!;
                          });
                        }
                      },
                    ),
                  );
                });
          },
          itemCount: events.length,
        ),
      ),
    );
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

class CorsairChip extends StatefulWidget {
  final String label;
  final bool selected;
  final Function(bool)? onSelected;
  const CorsairChip(
      {Key? key,
      required this.label,
      required this.selected,
      required this.onSelected})
      : super(key: key);

  @override
  State<CorsairChip> createState() => _CorsairChipState();
}

class _CorsairChipState extends State<CorsairChip> {
  @override
  Widget build(BuildContext context) {
    // TAPPABLE CHIP
    return FilterChip(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
                color: widget.selected
                    ? CorsairsTheme.primaryYellow
                    : CorsairsTheme.primaryYellow.withOpacity(0.5))),
        backgroundColor:
            widget.selected ? CorsairsTheme.primaryYellow : Colors.transparent,
        label: Text(
          widget.label,
          textAlign: TextAlign.center,
        ),
        onSelected: (x) {
          if (widget.onSelected != null) widget.onSelected!(x);
        });
  }
}
