import 'package:flutter/material.dart';
import 'package:rsvp/models/event_schema.dart';
import 'package:rsvp/utils/extensions.dart';
import 'package:rsvp/widgets/widgets.dart';

class EventTile extends StatelessWidget {
  const EventTile({
    super.key,
    this.onBookmarkTap,
    required this.event,
  });

  final EventModel event;
  final Function? onBookmarkTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildCardBackground(),
              buildGradient(),
              _buildTitleAndSubtitle(),
              // grey out the event if it's in the past
              if (event.hasEnded()) buildGreyOut(),
              // bookmark icon
              Positioned(
                  top: 0,
                  right: 12,
                  child: IconButton(
                    onPressed: () {
                      if (onBookmarkTap != null) onBookmarkTap!();
                    },
                    icon: Icon(
                      !event.bookmark! ? Icons.bookmark_border : Icons.bookmark,
                      size: 40,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGreyOut() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: const Center(
        child: Text(
          'Event has ended',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildCardBackground() {
    return Image.network(
      event.coverImage!,
      fit: BoxFit.fitWidth,
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
            event.name!,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            event.startsAt!.standardDate(),
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
