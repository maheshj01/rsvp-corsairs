import 'package:flutter/material.dart';
import 'package:rsvp/models/event_schema.dart';
import 'package:rsvp/navbar/events/add_event.dart';
import 'package:rsvp/services/api/appstate.dart';
import 'package:rsvp/themes/theme.dart';
import 'package:rsvp/utils/extensions.dart';
import 'package:rsvp/utils/navigator.dart';
import 'package:rsvp/widgets/button.dart';
import 'package:rsvp/widgets/widgets.dart';

class EventDetail extends StatefulWidget {
  static String route = '/event_detail';
  final EventModel event;
  const EventDetail({Key? key, required this.event}) : super(key: key);

  @override
  State<EventDetail> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
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
  }

  bool _isCollapsed = false;
  Size? size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    final user = AppStateScope.of(context).user;
    bool isHost = user!.email == widget.event.host?.email;
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
                      style: CorsairsTheme.googleFontsTextTheme.headline3!
                          .copyWith(color: Colors.white)),
                ),
                // TODO: toggle isHost
                !isHost
                    ? IconButton(
                        onPressed: () {
                          Navigate.push(
                              context,
                              AddEvent(
                                event: widget.event,
                                isEdit: !isHost,
                              ));
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
                style: CorsairsTheme.googleFontsTextTheme.bodyText1!
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
                      Text(
                          widget.event.startsAt!
                              .standardTimeDifference(widget.event.endsAt!),
                          style: CorsairsTheme.googleFontsTextTheme.bodyText1!
                              .copyWith(color: Colors.white)),
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
            // ADDRESS
            ListTile(
              leading: const Icon(Icons.location_on,
                  color: CorsairsTheme.primaryYellow),
              onTap: () {},
              title: Text(widget.event.address,
                  style: CorsairsTheme.googleFontsTextTheme.bodyLarge!
                      .copyWith(color: Colors.white)),
            ),
            (size!.width / 2).vSpacer(),
          ],
        ),
      );
    }

    return Material(
      color: Color.fromRGBO(0, 0, 0, 1),
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
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  _buildDetails(),
                ]),
              ),
            ]),
          ),
          Center(
            child: VHButton(
              width: size!.width * 0.8,
              onTap: () {},
              backgroundColor: CorsairsTheme.primaryYellow,
              label: 'Going',
            ),
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
          widget.event.coverImage,
          fit: BoxFit.cover,
        ),
        buildGradient(top: Colors.transparent, bottom: Colors.black),
      ],
    );
  }
}
