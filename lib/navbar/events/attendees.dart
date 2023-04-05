import 'package:flutter/material.dart';
import 'package:rsvp/models/attendee.dart';
import 'package:rsvp/utils/utils.dart';
import 'package:rsvp/widgets/circle_avatar.dart';

class AttendeesList extends StatefulWidget {
  List<Attendee> attendees = [];
  AttendeesList({Key? key, required this.attendees}) : super(key: key);

  @override
  State<AttendeesList> createState() => _AttendeesListState();
}

class _AttendeesListState extends State<AttendeesList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: 24.0.topPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // horizontal line to show the draggable area
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // title for attendees list
            Padding(
              padding: 16.0.horizontalPadding,
              child: const Text(
                'Attendees',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                  itemCount: widget.attendees.length,
                  itemBuilder: (context, index) {
                    final user = widget.attendees[index].user;
                    return Column(
                      children: [
                        ListTile(
                          leading: CircularAvatar(
                            name: user.name,
                            url: user.avatarUrl,
                          ),
                          title: Text(user.name),
                          subtitle: Text(user.email),
                        ),
                        const Divider(),
                      ],
                    );
                  }),
            ),
          ],
        ));
  }
}
