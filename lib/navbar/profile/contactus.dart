import 'package:flutter/material.dart';
import 'package:rsvp/utils/extensions.dart';
import 'package:rsvp/utils/utility.dart';

import '../../constants/constants.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Contact Us'),
        ),
        body: Column(children: [
          const Text('Contact Us'),
          24.0.vSpacer(),
          // Email
          ListTile(
              minVerticalPadding: 24.0,
              title: const Text(
                'Email',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () {
                // launch email app
                launchURL('mailto:${Constants.FEEDBACK_EMAIL_TO}');
              })
        ]));
  }
}
