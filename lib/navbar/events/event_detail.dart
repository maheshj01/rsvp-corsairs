import 'package:flutter/material.dart';
import 'package:rsvp/models/event.dart';

class EventDetail extends StatefulWidget {
  static String route = '/event_detail';
  final Event event;
  const EventDetail({Key? key, required this.event}) : super(key: key);

  @override
  State<EventDetail> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.name!),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(widget.event.coverImage),
          const Center(
            child: Text('Event Detail'),
          ),
        ],
      ),
    );
  }
}
