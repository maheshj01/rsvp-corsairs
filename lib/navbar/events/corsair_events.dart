import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rsvp/models/event.dart';
import 'package:rsvp/navbar/events/bookmarks.dart';
import 'package:rsvp/navbar/events/event_detail.dart';
import 'package:rsvp/services/api/appstate.dart';
import 'package:rsvp/themes/theme.dart';
import 'package:rsvp/utils/extensions.dart';
import 'package:rsvp/utils/responsive.dart';
import 'package:rsvp/utils/size_utils.dart';
import 'package:rsvp/widgets/widgets.dart';

class CorsairEvents extends StatefulWidget {
  static String route = '/';
  const CorsairEvents({Key? key}) : super(key: key);

  @override
  State<CorsairEvents> createState() => _CorsairEventsState();
}

class _CorsairEventsState extends State<CorsairEvents> {
  @override
  void initState() {
    super.initState();
  }

  /// get latest word of the day sort by descending order of created_at
  /// check current DateTime UTC and compare with the latest word of the day
  /// if the date is same, then don't publish a new word of the day
  /// else publish a new word of the day

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
      mobileBuilder: (context) => CorsairEventsMobile(),
    ));
  }
}

class CorsairEventsMobile extends StatelessWidget {
  static String route = '/';
  CorsairEventsMobile({Key? key, this.event}) : super(key: key);

  Event? event = Event.init().copyWith(name: "New Event");
  @override
  Widget build(BuildContext context) {
    final user = AppStateScope.of(context).user;

    return CustomScrollView(
      slivers: <Widget>[
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
                  style: CorsairsTheme.googleFontsTextTheme.subtitle2!
                      .copyWith(fontSize: 28, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            actions: [
              user!.isLoggedIn
                  ? IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.notifications_on,
                        color: CorsairsTheme.primaryColor,
                      ))
                  : const SizedBox.shrink()
            ]),
        SliverToBoxAdapter(
          child: Padding(
            padding: 16.0.horizontalPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: 16.0.verticalPadding,
                  child: heading('Word of the day'),
                ),
                OpenContainer<bool>(
                    openBuilder:
                        (BuildContext context, VoidCallback openContainer) {
                      return EventDetail(
                        event: event!,
                      );
                    },
                    tappable: true,
                    closedShape: 16.0.rounded,
                    transitionType: ContainerTransitionType.fadeThrough,
                    closedBuilder:
                        (BuildContext context, VoidCallback openContainer) {
                      return EventCard(
                        event: event,
                        color: Colors.green.shade300,
                        title: '${event!.name}'.toUpperCase(),
                      );
                    }),
                Padding(
                  padding: 6.0.verticalPadding,
                ),
                !user.isLoggedIn
                    ? const SizedBox.shrink()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: 12.0.verticalPadding,
                            child: heading('Progress'),
                          ),
                          OpenContainer<bool>(
                              openBuilder: (BuildContext context,
                                  VoidCallback openContainer) {
                                return FavEvents(
                                  isBookMark: true,
                                  user: user,
                                );
                              },
                              closedShape: 16.0.rounded,
                              tappable: true,
                              transitionType:
                                  ContainerTransitionType.fadeThrough,
                              closedBuilder: (BuildContext context,
                                  VoidCallback openContainer) {
                                return EventCard(
                                  event: event,
                                  height: 180,
                                  fontSize: 42,
                                  color: Colors.amberAccent.shade400,
                                  title: 'Bookmarks',
                                );
                              }),
                          Padding(
                            padding: 6.0.verticalPadding,
                          ),
                          OpenContainer<bool>(
                              openBuilder: (BuildContext context,
                                  VoidCallback openContainer) {
                                return FavEvents(
                                  isBookMark: false,
                                  user: user,
                                );
                              },
                              tappable: true,
                              closedShape: 16.0.rounded,
                              transitionType:
                                  ContainerTransitionType.fadeThrough,
                              closedBuilder: (BuildContext context,
                                  VoidCallback openContainer) {
                                return EventCard(
                                  event: event,
                                  height: 180,
                                  fontSize: 42,
                                  image: 'assets/dart.jpg',
                                  title: 'Mastered\nWords',
                                );
                              })
                        ],
                      ),
                100.0.vSpacer()
              ],
            ),
          ),
        )
      ],
    );
  }
}

class EventCard extends StatelessWidget {
  final Event? event;
  final String title;
  final Color? color;
  final double? height;
  final String? image;
  final double fontSize;

  const EventCard(
      {super.key,
      this.event,
      this.height,
      required this.title,
      this.color,
      this.fontSize = 48,
      this.image});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: height ?? size.height / 3,
      width: size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: color,
          image: image != null
              ? const DecorationImage(
                  fit: BoxFit.fill,
                  opacity: 0.7,
                  image: AssetImage('assets/dart.jpg'))
              : null),
      child: Align(
          alignment: Alignment.center,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: CorsairsTheme.googleFontsTextTheme.headline2!
                .copyWith(fontSize: fontSize),
          )),
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

class ExampleParallax extends StatelessWidget {
  const ExampleParallax({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          for (final location in locations)
            LocationListItem(
              imageUrl: location.imageUrl,
              name: location.name,
              country: location.place,
            ),
        ],
      ),
    );
  }
}

class LocationListItem extends StatelessWidget {
  LocationListItem({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.country,
  });

  final String imageUrl;
  final String name;
  final String country;
  final GlobalKey _backgroundImageKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              _buildParallaxBackground(context),
              _buildGradient(),
              _buildTitleAndSubtitle(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParallaxBackground(BuildContext context) {
    return Flow(
      delegate: ParallaxFlowDelegate(
        scrollable: Scrollable.of(context)!,
        listItemContext: context,
        backgroundImageKey: _backgroundImageKey,
      ),
      children: [
        Image.network(
          imageUrl,
          key: _backgroundImageKey,
          fit: BoxFit.cover,
        ),
      ],
    );
  }

  Widget _buildGradient() {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.6, 0.95],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleAndSubtitle() {
    return Positioned(
      left: 20,
      bottom: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            country,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class ParallaxFlowDelegate extends FlowDelegate {
  ParallaxFlowDelegate({
    required this.scrollable,
    required this.listItemContext,
    required this.backgroundImageKey,
  }) : super(repaint: scrollable.position);


  final ScrollableState scrollable;
  final BuildContext listItemContext;
  final GlobalKey backgroundImageKey;

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    return BoxConstraints.tightFor(
      width: constraints.maxWidth,
    );
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    // Calculate the position of this list item within the viewport.
    final scrollableBox = scrollable.context.findRenderObject() as RenderBox;
    final listItemBox = listItemContext.findRenderObject() as RenderBox;
    final listItemOffset = listItemBox.localToGlobal(
        listItemBox.size.centerLeft(Offset.zero),
        ancestor: scrollableBox);

    // Determine the percent position of this list item within the
    // scrollable area.
    final viewportDimension = scrollable.position.viewportDimension;
    final scrollFraction =
        (listItemOffset.dy / viewportDimension).clamp(0.0, 1.0);

    // Calculate the vertical alignment of the background
    // based on the scroll percent.
    final verticalAlignment = Alignment(0.0, scrollFraction * 2 - 1);

    // Convert the background alignment into a pixel offset for
    // painting purposes.
    final backgroundSize =
        (backgroundImageKey.currentContext!.findRenderObject() as RenderBox)
            .size;
    final listItemSize = context.size;
    final childRect =
        verticalAlignment.inscribe(backgroundSize, Offset.zero & listItemSize);

    // Paint the background.
    context.paintChild(
      0,
      transform:
          Transform.translate(offset: Offset(0.0, childRect.top)).transform,
    );
  }

  @override
  bool shouldRepaint(ParallaxFlowDelegate oldDelegate) {
    return scrollable != oldDelegate.scrollable ||
        listItemContext != oldDelegate.listItemContext ||
        backgroundImageKey != oldDelegate.backgroundImageKey;
  }
}

class Parallax extends SingleChildRenderObjectWidget {
  const Parallax({
    super.key,
    required Widget background,
  }) : super(child: background);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderParallax(scrollable: Scrollable.of(context)!);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderParallax renderObject) {
    renderObject.scrollable = Scrollable.of(context)!;
  }
}

class ParallaxParentData extends ContainerBoxParentData<RenderBox> {}

class RenderParallax extends RenderBox
    with RenderObjectWithChildMixin<RenderBox>, RenderProxyBoxMixin {
  RenderParallax({
    required ScrollableState scrollable,
  }) : _scrollable = scrollable;

  ScrollableState _scrollable;

  ScrollableState get scrollable => _scrollable;

  set scrollable(ScrollableState value) {
    if (value != _scrollable) {
      if (attached) {
        _scrollable.position.removeListener(markNeedsLayout);
      }
      _scrollable = value;
      if (attached) {
        _scrollable.position.addListener(markNeedsLayout);
      }
    }
  }

  @override
  void attach(covariant PipelineOwner owner) {
    super.attach(owner);
    _scrollable.position.addListener(markNeedsLayout);
  }

  @override
  void detach() {
    _scrollable.position.removeListener(markNeedsLayout);
    super.detach();
  }

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! ParallaxParentData) {
      child.parentData = ParallaxParentData();
    }
  }

  @override
  void performLayout() {
    size = constraints.biggest;

    // Force the background to take up all available width
    // and then scale its height based on the image's aspect ratio.
    final background = child!;
    final backgroundImageConstraints =
        BoxConstraints.tightFor(width: size.width);
    background.layout(backgroundImageConstraints, parentUsesSize: true);

    // Set the background's local offset, which is zero.
    (background.parentData as ParallaxParentData).offset = Offset.zero;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // Get the size of the scrollable area.
    final viewportDimension = scrollable.position.viewportDimension;

    // Calculate the global position of this list item.
    final scrollableBox = scrollable.context.findRenderObject() as RenderBox;
    final backgroundOffset =
        localToGlobal(size.centerLeft(Offset.zero), ancestor: scrollableBox);

    // Determine the percent position of this list item within the
    // scrollable area.
    final scrollFraction =
        (backgroundOffset.dy / viewportDimension).clamp(0.0, 1.0);

    // Calculate the vertical alignment of the background
    // based on the scroll percent.
    final verticalAlignment = Alignment(0.0, scrollFraction * 2 - 1);

    // Convert the background alignment into a pixel offset for
    // painting purposes.
    final background = child!;
    final backgroundSize = background.size;
    final listItemSize = size;
    final childRect =
        verticalAlignment.inscribe(backgroundSize, Offset.zero & listItemSize);

    // Paint the background.
    context.paintChild(
        background,
        (background.parentData as ParallaxParentData).offset +
            offset +
            Offset(0.0, childRect.top));
  }
}

class Location {
  const Location({
    required this.name,
    required this.place,
    required this.imageUrl,
  });

  final String name;
  final String place;
  final String imageUrl;
}

const urlPrefix =
    'https://docs.flutter.dev/cookbook/img-files/effects/parallax';
const locations = [
  Location(
    name: 'Mount Rushmore',
    place: 'U.S.A',
    imageUrl: '$urlPrefix/01-mount-rushmore.jpg',
  ),
  Location(
    name: 'Gardens By The Bay',
    place: 'Singapore',
    imageUrl: '$urlPrefix/02-singapore.jpg',
  ),
  Location(
    name: 'Machu Picchu',
    place: 'Peru',
    imageUrl: '$urlPrefix/03-machu-picchu.jpg',
  ),
  Location(
    name: 'Vitznau',
    place: 'Switzerland',
    imageUrl: '$urlPrefix/04-vitznau.jpg',
  ),
  Location(
    name: 'Bali',
    place: 'Indonesia',
    imageUrl: '$urlPrefix/05-bali.jpg',
  ),
  Location(
    name: 'Mexico City',
    place: 'Mexico',
    imageUrl: '$urlPrefix/06-mexico-city.jpg',
  ),
  Location(
    name: 'Cairo',
    place: 'Egypt',
    imageUrl: '$urlPrefix/07-cairo.jpg',
  ),
];