import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import '../../settings/settings.dart';
import '../../style/palette.dart';

class StartJourney extends StatefulWidget {
  const StartJourney({super.key});

  @override
  State<StartJourney> createState() => _StartJourneyState();
}

class _StartJourneyState extends State<StartJourney> {
  static final _log = Logger('PlaySessionScreen');

  static const dialogues = [
    "Welcome adventurer! You've embarked on an exciting new journey, where you'll explore the world of investing and learn how to make smart financial decisions.",
    "As your guide, we'll help you navigate the ups and downs of the market and build a solid financial foundation for your future."
  ];

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();
    final palette = context.watch<Palette>();

    return Scaffold(
        backgroundColor: palette.beige,
        body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/journey/beginning/bg1.jpg"),
                  fit: BoxFit.cover)),
          child: Stack(alignment: Alignment.center, children: [
            Positioned(
              bottom: 180,
              child: Image.asset(
                  "assets/images/journey/beginning/Open Peeps - Bust 1.png"),
            ),
            Positioned(
              bottom: 40,
              child: Container(
                padding: const EdgeInsets.all(8),
                height: 188,
                width: 345,
                decoration: BoxDecoration(
                    color: palette.trueWhite,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: palette.black, width: 2)),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TyperAnimatedText(dialogues[0],
                        textStyle: const TextStyle(
                            fontFamily: "Inconsolata", fontSize: 20)),
                    TyperAnimatedText(dialogues[1],
                        textStyle: const TextStyle(
                            fontFamily: "Inconsolata", fontSize: 20)),
                  ],
                  isRepeatingAnimation: false,
                  pause: const Duration(milliseconds: 5000),
                  displayFullTextOnTap: true,
                  stopPauseOnTap: true,
                ),
              ),
            )
          ]),
        ));
  }
}
