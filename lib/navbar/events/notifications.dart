import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rsvp/utils/extensions.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Animate(
              effects: const [ShakeEffect()],
              delay: const Duration(seconds: 1),
              child: Image.asset(
                'assets/images/arnie.png',
                height: 200,
                width: 200,
              ),
            ),
            16.0.vSpacer(),
            const Text(
              'Please come back later, this page is under construction',
            ),
          ],
        )));
  }
}
