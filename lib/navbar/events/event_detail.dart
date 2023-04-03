import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:rsvp/constants/const.dart';
import 'package:rsvp/models/attendee.dart';
import 'package:rsvp/models/event_schema.dart';
import 'package:rsvp/models/user.dart';
import 'package:rsvp/navbar/events/add_event.dart';
import 'package:rsvp/navbar/pageroute.dart';
import 'package:rsvp/services/api/appstate.dart';
import 'package:rsvp/services/database.dart';
import 'package:rsvp/services/event_service.dart';
import 'package:rsvp/themes/theme.dart';
import 'package:rsvp/utils/extensions.dart';
import 'package:rsvp/widgets/button.dart';
import 'package:rsvp/widgets/widgets.dart';

class EventDetail extends StatefulWidget {
  static String route = '/event_detail';
  EventModel event;
  EventDetail({Key? key, required this.event}) : super(key: key);

  @override
  State<EventDetail> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _responseNotifier.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > size!.height * 0.45) {
        setState(() {
          _isCollapsed = true;
        });
      } else {
        setState(() {
          _isCollapsed = false;
        });
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchAttendees();
    });
    // scrollToBottomAndTop();
  }

  // helper method only to generate gif for demo
  void scrollToBottomAndTop() {
    _scrollController
        .animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 3500),
      curve: Curves.easeOut,
    )
        .then((value) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        _scrollController.animateTo(
          _scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 3500),
          curve: Curves.easeOut,
        );
      });
    });
  }

  Future<void> fetchAttendees() async {
    _responseNotifier.value.copyWith(state: RequestState.active);
    final response = await DatabaseService.findRowByColumnValue(
      widget.event.id!,
      columnName: 'event_id',
      tableName: Constants.ATTENDEES_TABLE_NAME,
    );
    try {
      if (response.status == 200) {
        attendees = response.data
            .map((e) => Attendee.fromJson(e))
            .toList()
            .cast<Attendee>();
        _responseNotifier.value.copyWith(state: RequestState.done);
      }
      Attendee? attendee =
          attendees.firstWhere((element) => element.user_id == user!.id!);
      if (attendee != null) {
        _responseNotifier.value = _responseNotifier.value.copyWith(data: true);
      } else {
        _responseNotifier.value = _responseNotifier.value.copyWith(data: false);
      }
    } catch (e) {
      _responseNotifier.value.copyWith(state: RequestState.error);
    }
    setState(() {});
  }

  final ValueNotifier<Response> _responseNotifier =
      ValueNotifier<Response>(Response.init(data: false));
  List<Attendee> attendees = [];
  bool _isCollapsed = false;
  Size? size;
  UserModel? user;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    user = AppStateScope.of(context).user;
    bool isHost = user!.email == widget.event.host?.email;
    bool isEventEnded = widget.event.endsAt!.isBefore(DateTime.now());
    Widget _buildDetails() {
      return Padding(
        padding: 16.0.allPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text('${widget.event.name}',
                      style: CorsairsTheme.googleFontsTextTheme.displaySmall!
                          .copyWith(color: Colors.white)),
                ),
                isHost
                    ? IconButton(
                        onPressed: () {
                          Navigator.of(context).push(PageRoutes.sharedAxis(
                              AddEvent(
                                event: widget.event,
                                isEdit: isHost,
                                onDone: () async {
                                  final updatedEvent =
                                      await EventService.findEventById(
                                          widget.event.id!);
                                  setState(() {
                                    widget.event = updatedEvent!;
                                  });
                                },
                              ),
                              SharedAxisTransitionType.vertical));
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: CorsairsTheme.primaryYellow,
                        ),
                        color: Colors.white,
                      )
                    : const SizedBox(),
              ],
            ),
            16.0.vSpacer(),
            // description
            Text('${widget.event.description}',
                style: CorsairsTheme.googleFontsTextTheme.bodyLarge!
                    .copyWith(color: Colors.white)),
            16.0.vSpacer(),
            ListTile(
              leading: const Icon(Icons.calendar_today,
                  color: CorsairsTheme.primaryYellow),
              onTap: () {},
              title: Text(widget.event.startsAt!.standardDate(),
                  style: const TextStyle(color: Colors.white)),
              subtitle: Text(widget.event.startsAt!.standardTime()),
            ),
            // vertical bar
            Padding(
              padding: 24.0.horizontalPadding,
              child: Row(
                children: [
                  Container(
                    height: 50,
                    width: 5,
                    color: CorsairsTheme.primaryYellow,
                  ),
                  16.0.hSpacer(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      16.0.vSpacer(),
                      // time difference
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                            widget.event.endsAt!
                                .standardTimeDifference(widget.event.startsAt!),
                            style: CorsairsTheme.googleFontsTextTheme.bodyLarge!
                                .copyWith(color: Colors.white, fontSize: 18)),
                      ),
                      16.0.vSpacer(),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today,
                  color: CorsairsTheme.primaryYellow),
              title: Text(widget.event.endsAt!.standardDate(),
                  style: const TextStyle(color: Colors.white)),
              subtitle: Text(widget.event.endsAt!.standardTime(),
                  style: const TextStyle(color: Colors.white)),
            ),
            16.0.vSpacer(),
            ListTile(
              leading: const Icon(Icons.location_on,
                  color: CorsairsTheme.primaryYellow),
              onTap: () {},
              title: Text(widget.event.address!,
                  style: CorsairsTheme.googleFontsTextTheme.bodyLarge!
                      .copyWith(color: Colors.white)),
            ),
            16.0.vSpacer(),
            ListTile(
              leading:
                  const Icon(Icons.people, color: CorsairsTheme.primaryYellow),
              onTap: () {},
              title: Text('${attendees.length} Attendees',
                  style: CorsairsTheme.googleFontsTextTheme.bodyLarge!
                      .copyWith(color: Colors.white)),
            ),
            16.0.vSpacer(),
            // host details
            ListTile(
              leading:
                  const Icon(Icons.person, color: CorsairsTheme.primaryYellow),
              onTap: () {},
              title: Text(widget.event.host!.name,
                  style: CorsairsTheme.googleFontsTextTheme.bodyLarge!
                      .copyWith(color: Colors.white)),
              subtitle: Text(widget.event.host!.email,
                  style: CorsairsTheme.googleFontsTextTheme.bodyLarge!
                      .copyWith(color: Colors.white)),
            ),
            ListTile(
              leading: const Icon(Icons.checkroom,
                  color: CorsairsTheme.primaryYellow),
              onTap: () {},
              title: Text("Wondering what clothes to wear?",
                  style: CorsairsTheme.googleFontsTextTheme.bodyLarge!
                      .copyWith(color: Colors.white)),
              subtitle: Text("Get clothese curated for you from H&M",
                  style: CorsairsTheme.googleFontsTextTheme.bodyLarge!
                      .copyWith(color: Colors.white)),
            ),
            ListTile(
              leading: const Icon(Icons.car_rental,
                  color: CorsairsTheme.primaryYellow),
              onTap: () {},
              title: Text("Don't have a car?",
                  style: CorsairsTheme.googleFontsTextTheme.bodyLarge!
                      .copyWith(color: Colors.white)),
              subtitle: Text("Uber available in your area in 10 minutes",
                  style: CorsairsTheme.googleFontsTextTheme.bodyLarge!
                      .copyWith(color: Colors.white)),
            ),
            (size!.width / 2).vSpacer(),
          ],
        ),
      );
    }

    return Material(
      color: const Color.fromRGBO(0, 0, 0, 1),
      child: Column(
        children: [
          Expanded(
            child: CustomScrollView(controller: _scrollController, slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: size!.height * 0.5,
                scrolledUnderElevation: 50,
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildCoverImage(),
                  collapseMode: CollapseMode.parallax,
                  stretchModes: const [
                    StretchMode.zoomBackground,
                    StretchMode.blurBackground,
                    StretchMode.fadeTitle,
                  ],
                  centerTitle: false,
                  title: !_isCollapsed
                      ? const SizedBox.shrink()
                      : Text(
                          '${widget.event.name}',
                          style: TextStyle(
                              color:
                                  !_isCollapsed ? Colors.white : Colors.black),
                        ),
                ),
                actions: [
                  IconButton(
                    onPressed: () async {
                      final resp = await EventService.updateBookMark(
                          widget.event.id!, user!.id!,
                          add: !widget.event.bookmark!);
                      if (resp.didSucced) {
                        setState(() {
                          widget.event.bookmark = !widget.event.bookmark!;
                        });
                      }
                    },
                    icon: Icon(
                      !widget.event.bookmark!
                          ? Icons.bookmark_border
                          : Icons.bookmark,
                      size: 40,
                    ),
                  ),
                  16.0.hSpacer(),
                ],
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  _buildDetails(),
                ]),
              ),
            ]),
          ),
          isHost || isEventEnded
              ? const SizedBox.shrink()
              : Center(
                  child: ValueListenableBuilder<Response>(
                      valueListenable: _responseNotifier,
                      builder: (context, response, child) {
                        return CSButton(
                          width: size!.width * 0.8,
                          isLoading: response.state == RequestState.active,
                          onTap: () async {
                            _responseNotifier.value =
                                response.copyWith(state: RequestState.active);
                            await EventService.rsvpEvent(
                                widget.event.id!, user!.id!,
                                going: !(response.data as bool));
                            _responseNotifier.value = response.copyWith(
                                data: !(response.data as bool),
                                state: RequestState.done);
                            fetchAttendees();
                          },
                          backgroundColor: CorsairsTheme.primaryYellow,
                          label: !(response.data as bool) ? 'Going' : 'Cancel',
                        );
                      }),
                ),
          24.0.vSpacer()
        ],
      ),
    );
  }

  Widget _buildCoverImage() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          widget.event.coverImage!,
          fit: BoxFit.cover,
        ),
        buildGradient(top: Colors.transparent, bottom: Colors.black),
      ],
    );
  }
}
