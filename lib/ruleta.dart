import 'dart:async';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:ruleta/constants.dart' as constants;
import 'package:ruleta/delayed_button.dart';
import 'package:ruleta/local_storage.dart';

class Ruleta extends StatefulWidget {
  const Ruleta({super.key});

  @override
  State<Ruleta> createState() => _RuletaState();
}

class _RuletaState extends State<Ruleta> {
  StreamController<int> selected = StreamController<int>();
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(
        seconds: 5,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    selected.close();
  }

  bool isRunning = false;
  Duration animationDuration = const Duration(seconds: 5);
  void _showConffeti() {
    Overlay.of(context).insert(OverlayEntry(
      builder: (context) => Align(
        alignment: Alignment.center,
        child: ConfettiWidget(
          confettiController: _confettiController,
          blastDirectionality: BlastDirectionality.explosive,
          numberOfParticles: 25,
          maxBlastForce: 25,
        ),
      ),
    ));
  }

  void saveReward(int winner) async {
    await LocalStorage.setReward(rewardAccess, winner);
    await LocalStorage.setLastTimeUsed(DateTime.now().microsecondsSinceEpoch);
    return;
  }

  void _onRunning() async {
    if (!mounted) return;

    if (await LocalStorage.canTryFortune() == false) {
      final reward = LocalStorage.getReward();
      late final String rewardString;
      if (reward != null) {
        rewardString = rewards[reward];
      } else {
        rewardString = "";
      }

      if (mounted) {
        if (rewardString.contains("Perdiste")) {
          showDialog(
            context: context,
            builder: (context) => const AlertDialog(
              title: Text(constants.noRewardWinDialogTitle),
              content: Text(constants.noRewardWinDialogContent),
            ),
          );
        } else {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text(constants.rewardClaimedTitle),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(constants.rewardClaimedContent),
                        Text("Tu premio: $rewardString"),
                      ],
                    ),
                  ));
        }
      }

      return;
    }

    setState(() => isRunning = true);

    final previousWinner = LocalStorage.getReward();
    late final int winner;
    if (previousWinner != null) {
      winner = previousWinner;
    } else {
      winner = Fortune.randomInt(0, rewards.length);
    }

    selected.add(winner);
    await Future.delayed(animationDuration);

    if (mounted) {
      setState(() => isRunning = false);
      final winString = rewards[winner];

      if (winString.contains("Perdiste")) {
        saveReward(winner);
        showDialog(
          context: context,
          builder: (context) => const AlertDialog(
            title: Text(constants.noRewardWinDialogTitle),
            content: Text(constants.noRewardWinDialogContent),
          ),
        );
        return;
      }

      _showConffeti();
      _confettiController.play();

      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: const Text(
                constants.winDialogTitle,
              ),
              content: Text(
                "${constants.winDialogContent} ${rewards[winner]}",
              ),
              actions: [
                DelayedButton(
                  winner: rewards[winner],
                ),
              ],
            );
          });

      saveReward(winner);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          constants.title,
          style: TextStyle(letterSpacing: 2),
        ),
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Flexible(flex: 1, child: SizedBox()),
              Flexible(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FortuneWheel(
                    hapticImpact: HapticImpact.light,
                    onFling: _onRunning,
                    animateFirst: false,
                    duration: animationDuration,
                    selected: selected.stream,
                    items: [
                      ...rewards.map((reward) =>
                          FortuneItem(child: Text(reward.toUpperCase())))
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: ElevatedButton(
                  onPressed: isRunning ? null : _onRunning,
                  child: const Text(constants.startFortune),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
