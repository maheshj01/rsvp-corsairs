import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:navbar_router/navbar_router.dart';
import 'package:rsvp/constants/strings.dart';
import 'package:rsvp/models/event.dart';
import 'package:rsvp/models/event_schema.dart';
import 'package:rsvp/models/user.dart';
import 'package:rsvp/navbar/events/event_detail.dart';
import 'package:rsvp/services/api/appstate.dart';
import 'package:rsvp/themes/theme.dart';
import 'package:rsvp/utils/navigator.dart';
import 'package:rsvp/utils/responsive.dart';
import 'package:rsvp/utils/size_utils.dart';
import 'package:rsvp/widgets/event_parallax.dart';
import 'package:uuid/uuid.dart';

class CorsairEvents extends StatefulWidget {
  static String route = '/';
  const CorsairEvents({Key? key}) : super(key: key);

  @override
  State<CorsairEvents> createState() => _CorsairEventsState();
}

class _CorsairEventsState extends State<CorsairEvents> {
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

  final double _offsetThreshold = 50.0;

  @override
  Widget build(BuildContext context) {
    final user = AppStateScope.of(context).user;

    List<EventModel> events = [
      EventModel(
        id: const Uuid().v4(),
        name: 'Mount Rushmore',
        description: 'U.S.A',
        endsAt: DateTime.now().add(const Duration(days: 1)),
        host: UserModel.init(name: 'John Doe', email: "johndoe@email.com"),
        startsAt: DateTime.now(),
        attendees: [],
        createdAt: DateTime.now(),
        coverImage: '$urlPrefix/01-mount-rushmore.jpg',
      ),
      EventModel(
        id: const Uuid().v4(),
        name: 'Gardens By The Bay',
        description:
            'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',
        endsAt: DateTime.now().add(const Duration(minutes: 1)),
        host: UserModel.init(name: 'John Doe', email: "johndoe@email.com"),
        startsAt: DateTime.now(),
        attendees: [
          UserModel(
            name: 'John Doe',
            email: "jsa@hotmail.com",
            avatarUrl: '$urlPrefix/01-mount-rushmore.jpg',
          )
        ],
        createdAt: DateTime.now(),
        address: '18 Marina Gardens Drive, Singapore 018953',
        coverImage: '$urlPrefix/02-singapore.jpg',
      ),
      EventModel(
        id: const Uuid().v4(),
        name: 'Machu Picchu',
        description: 'Peru',
        address: 'Machu Picchu, Peru',
        endsAt: DateTime.now().add(const Duration(days: 1)),
        host: UserModel.init(name: 'John Doe', email: "johndoe@email.com"),
        startsAt: DateTime.now(),
        attendees: [],
        createdAt: DateTime.now(),
        coverImage: '$urlPrefix/03-machu-picchu.jpg',
      ),
      EventModel(
        name: 'Vitznau',
        description: 'Switzerland',
        endsAt: DateTime.now().add(const Duration(minutes: 1)),
        host: UserModel.init(name: 'John Doe', email: "johndoe@email.com"),
        startsAt: DateTime.now(),
        attendees: [],
        createdAt: DateTime.now(),
        coverImage: '$urlPrefix/04-vitznau.jpg',
      ),
      EventModel(
        id: const Uuid().v4(),
        name: 'Bali',
        description: 'Indonesia',
        endsAt: DateTime.now().add(const Duration(minutes: 1)),
        host: UserModel.init(name: 'John Doe', email: "johndoe@email.com"),
        startsAt: DateTime.now(),
        attendees: [],
        createdAt: DateTime.now(),
        coverImage: '$urlPrefix/05-bali.jpg',
      ),
      EventModel(
        id: const Uuid().v4(),
        name: 'Mexico City',
        description: 'Mexico',
        endsAt: DateTime.now().add(const Duration(minutes: 1)),
        host: UserModel.init(name: 'John Doe', email: "johndoe@email.com"),
        startsAt: DateTime.now(),
        attendees: [],
        createdAt: DateTime.now(),
        coverImage: '$urlPrefix/06-mexico-city.jpg',
      ),
      EventModel(
        id: const Uuid().v4(),
        name: 'Cairo',
        description: 'Egypt',
        endsAt: DateTime.now().add(const Duration(minutes: 1)),
        host: UserModel.init(name: 'John Doe', email: "johndoe@email.com"),
        startsAt: DateTime.now(),
        attendees: [],
        createdAt: DateTime.now(),
        coverImage: '$urlPrefix/07-cairo.jpg',
      ),
    ];

    return CustomScrollView(
      controller: _scrollController,
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
                  style: CorsairsTheme.googleFontsTextTheme.titleSmall!
                      .copyWith(fontSize: 28, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            actions: [
              IconButton(
                  onPressed: () {},
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
        SliverList(
            delegate: SliverChildListDelegate([
          for (EventModel event in events)
            InkWell(
              onTap: () {
                Navigate.push(context, EventDetail(event: event));
              },
              child: EventParallaxTile(
                event: event,
              ),
            )
        ]))
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
            style: CorsairsTheme.googleFontsTextTheme.displayMedium!
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
