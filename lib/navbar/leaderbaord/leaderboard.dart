import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:rsvp/utils/size_utils.dart';

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
    confettiController.play();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          // Leaderboard coming soon widget
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Leaderboard Coming Soon',
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Stay tuned for updates',
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                ),
              ],
            ),
          ),
          Positioned(
            top: -100,
            left: SizeUtils.size.width / 2,
            child: ConfettiWidget(
              confettiController: confettiController,
              blastDirection: 0,
              blastDirectionality: BlastDirectionality.explosive,
              emissionFrequency: 0.1,
              minimumSize: const Size(10, 10),
              maximumSize: const Size(50, 50),
              numberOfParticles: 5,
              gravity: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
