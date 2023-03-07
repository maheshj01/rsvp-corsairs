import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:navbar_router/navbar_router.dart';
import 'package:rsvp/utils/extensions.dart';
import 'package:rsvp/utils/size_utils.dart';
import 'package:rsvp/widgets/circle_avatar.dart';

class LeaderBoard extends StatefulWidget {
  static String route = '/';
  const LeaderBoard({
    Key? key,
  }) : super(key: key);

  @override
  State<LeaderBoard> createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  final confettiController = ConfettiController();

  @override
  void initState() {
    super.initState();

    notifier.addListener(() async {
      int index = NavbarNotifier.currentIndex;
      if (index == 1) {
        print("play");
        // confettiController.play();
        // TODO: This is crashing the app
        // FlutterRingtonePlayer.play(
        //   // android: AndroidSounds.notification,
        //   // ios: IosSounds.horn,
        //   fromAsset: 'assets/applause.mp3',
        //   looping: false,
        //   volume: 0.2,
        //   // asAlarm: true,
        // );
      } else {
        print("stop");
        // await stopRingtone();
        // confettiController.stop();
      }
    });
  }

  Future<void> getLeaderBoard() async {
    await Future.delayed(const Duration(seconds: 2));
    return;
  }

  late FlutterRingtonePlayer player = FlutterRingtonePlayer();
  Future<void> stopRingtone() async {
    await FlutterRingtonePlayer.stop();
  }

  NavbarNotifier notifier = NavbarNotifier();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        CustomScrollView(
          slivers: [
            // SliverAppBar for top 3 users with CircleAvatar
            SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                    title: const Text(
                      'Leaderboard',
                      style: TextStyle(color: Colors.black),
                    ),
                    background: Stack(children: [
                      // first second and third position at different heights
                      for (int i = 0; i < 3; i++)
                        Positioned(
                          top: i == 0
                              ? 100
                              : i == 1
                                  ? 50
                                  : 130,
                          left: SizeUtils.size.width / 2.8 * i,
                          child: CircularAvatar(
                            radius: 50,
                            name: 'John Doe'.initials(),
                          ),
                        ),
                    ]))),

            // SliverList for the rest of the users
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              return ListTile(
                leading: CircularAvatar(
                  radius: 30,
                  name: 'John Doe'.initials(),
                ),
                title: const Text('John Doe'),
                subtitle: const Text('Joined 2 days ago'),
                trailing: const Text('100'),
              );
            }, childCount: 10)),
          ],
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: ConfettiWidget(
            confettiController: confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            blastDirection: pi / 2,
            emissionFrequency: 0.05,
            numberOfParticles: 10,
            maxBlastForce: 100,
            minBlastForce: 50,
            gravity: 0.2,
          ),
        ),
      ],
    ));
  }
}
