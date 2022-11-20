import 'package:flutter/material.dart';
import 'package:rsvp/models/event.dart';
import 'package:rsvp/widgets/widgets.dart';

class EventDetail extends StatefulWidget {
  static String route = '/event_detail';
  final Event event;
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
    // TODO: implement initState
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

    Widget _buildDetails() {
      return Column(
        children: [
          for (int i = 0; i < 20; i++)
            const Text('Hello world',
                style: TextStyle(fontSize: 48, color: Colors.white)),
        ],
      );
    }

    return Material(
      color: const Color.fromARGB(255, 0, 0, 0),
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
            title: Text(
              'Demo',
              style:
                  TextStyle(color: !_isCollapsed ? Colors.white : Colors.black),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            _buildDetails(),
          ]),
        ),
      ]),
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
