import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:rsvp/models/event.dart';
import 'package:rsvp/models/event_schema.dart';
import 'package:rsvp/models/user.dart';
import 'package:rsvp/navbar/events/event_detail.dart';
import 'package:rsvp/services/event_service.dart';
import 'package:rsvp/themes/theme.dart';
import 'package:rsvp/utils/responsive.dart';
import 'package:rsvp/widgets/widgets.dart';

class FavEvents extends StatefulWidget {
  final bool isBookMark;
  final UserModel user;

  const FavEvents({Key? key, required this.isBookMark, required this.user})
      : super(key: key);

  @override
  State<FavEvents> createState() => FavEventsState();
}

class FavEventsState extends State<FavEvents> {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: ResponsiveBuilder(
      desktopBuilder: (context) => const _BookmarksDesktop(),
      mobileBuilder: (context) => _BookmarksMobile(
        isBookMark: widget.isBookMark,
        user: widget.user,
      ),
    ));
  }
}

class _BookmarksMobile extends StatefulWidget {
  final bool isBookMark;
  final UserModel user;

  const _BookmarksMobile({Key? key, this.isBookMark = true, required this.user})
      : super(key: key);

  @override
  State<_BookmarksMobile> createState() => _BookmarksMobileState();
}

class _BookmarksMobileState extends State<_BookmarksMobile> {
  Future<void> getBookmarks() async {
    final events = await EventService.getBookmarks(widget.user.email,
        isBookmark: widget.isBookMark);
    _bookmarksNotifier.value = events;
  }

  @override
  void initState() {
    super.initState();
    getBookmarks();
  }

  final ValueNotifier<List<EventModel>?> _bookmarksNotifier =
      ValueNotifier<List<EventModel>?>(null);

  @override
  Widget build(BuildContext context) {
    String title = widget.isBookMark ? 'Bookmarks' : 'Mastered words';

    Widget _emptyWidget() {
      return Center(
        child: Text('No ${title.toLowerCase()} to show'),
      );
    }

    return ValueListenableBuilder(
        valueListenable: _bookmarksNotifier,
        builder: (BuildContext context, List<EventModel>? value, Widget? child) {
          if (value == null) {
            return Scaffold(
                appBar: AppBar(title: Text(title)),
                body: const LoadingWidget());
          }
          return Scaffold(
              appBar: AppBar(
                title: value.isEmpty
                    ? Text(title)
                    : Text('${value.length} $title'),
              ),
              body: value.isEmpty
                  ? _emptyWidget()
                  : ListView.builder(
                      itemCount: value.length,
                      padding: const EdgeInsets.only(
                          top: 16, bottom: kBottomNavigationBarHeight),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4.0),
                          child: OpenContainer(
                              openBuilder: (BuildContext context,
                                  VoidCallback openContainer) {
                                return EventDetail(event: value[index]);
                              },
                              tappable: true,
                              transitionType:
                                  ContainerTransitionType.fadeThrough,
                              closedBuilder: (BuildContext context,
                                  VoidCallback openContainer) {
                                return ListTile(
                                  minVerticalPadding: 24,
                                  title: Text(value[index].name!),
                                  trailing: IconButton(
                                    icon: Icon(
                                      Icons.bookmark,
                                      color: CorsairsTheme.primaryColor,
                                    ),
                                    onPressed: () async {},
                                  ),
                                );
                              }),
                        );
                      },
                    ));
        });
  }
}

class _BookmarksDesktop extends StatefulWidget {
  const _BookmarksDesktop({Key? key}) : super(key: key);

  @override
  State<_BookmarksDesktop> createState() => _BookmarksDesktopState();
}

class _BookmarksDesktopState extends State<_BookmarksDesktop> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.red,
      ),
    );
  }
}
