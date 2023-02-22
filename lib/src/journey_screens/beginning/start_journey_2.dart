import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:wealth_wonderland/src/style/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../style/rough/button.dart';

class StartJourney2 extends StatefulWidget {
  const StartJourney2({super.key});

  @override
  State<StartJourney2> createState() => _StartJourney2State();
}

class _StartJourney2State extends State<StartJourney2> {
  static final _log = Logger('PlaySessionScreen');

  int _questionIndex = 0;
  final List<String> _questions = [
    "First, tell us your name! What should we call you?",
    "What kind of adventurer do you want to be?",
    "How old are you? This will hep us decide..?",
    "Every adventurer needs a strong foundation to build on, and the same goes for investing. How much do you plan to invest regularly?",
    "Finally, What's your investing horizon? Do you have any financial goals in mind, like saving for a down payment on a house or planning for retirement?"
  ];

  static const dialogues = [
    "But before we set off on this adventure, we'll need to know a bit more about you!",
    "Now that we have a better understanding of your starting point, we can start to create your smart SIP. Think of it as your trusty pack, filled with a curated selection of investment options that align with your goals and risk profile. You'll be able to customize your smart SIP as you go, adding and removing investments based on your interests and market trends."
  ];

  late String _name = '';
  late bool _isDaring = false;
  late int _age = 0;
  late int _sipAmount = 0;
  late int _horizon = 0;

  String kind = '';
  String radioVal = 'lol';

  bool introFinished = false;

  @override
  void initState() {
    super.initState();
    _loadData();

    _log.info(_name);
    _log.info(_isDaring);
    _log.info(_age);
    _log.info(_sipAmount);
    _log.info(_horizon);
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name')!;
      _isDaring = prefs.getBool('isDaring')!;
      _age = prefs.getInt('age')!;
      _sipAmount = prefs.getInt('sipAmount')!;
      _horizon = prefs.getInt('horizon')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return Scaffold(
      backgroundColor: palette.beige,
      resizeToAvoidBottomInset: false,
      body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/journey/beginning/bg1.jpg"),
                  fit: BoxFit.cover)),
          child: Column(
            children: [
              Expanded(
                  child: Visibility(
                      visible: !introFinished, child: _introTitle())),
              Expanded(
                  flex: 3,
                  child: Center(
                    child: Visibility(
                      visible: introFinished,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: _buildCurrentQuestion(),
                      ),
                    ),
                  ))
            ],
          )),
    );
  }

  Widget _introTitle() {
    final palette = context.watch<Palette>();

    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(top: 65, bottom: 15),
      height: 120,
      width: 345,
      decoration: BoxDecoration(
          color: palette.trueWhite,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: palette.black, width: 2)),
      child: AnimatedTextKit(
        animatedTexts: [
          TyperAnimatedText(dialogues[0],
              textStyle:
                  const TextStyle(fontFamily: "Inconsolata", fontSize: 20)),
        ],
        // isRepeatingAnimation: false,
        totalRepeatCount: 1,
        pause: const Duration(milliseconds: 5000),
        displayFullTextOnTap: true,
        stopPauseOnTap: true,
        onFinished: () {
          setState(() {
            introFinished = true;
          });
        },
      ),
    );
  }

  Widget _buildCurrentQuestion() {
    if (_questionIndex == 0) {
      return _buildNameInput();
    } else if (_questionIndex == 1) {
      return _buildRiskProfileSelection();
    } else if (_questionIndex == 2) {
      return _buildAgeInput();
    } else if (_questionIndex == 3) {
      return _buildSipAmountInput();
    } else if (_questionIndex == 4) {
      return _buildHorizonInput();
    } else {
      return _buildFinalMessage();
    }
  }

  Widget _buildNameInput() {
    final palette = context.watch<Palette>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 40, right: 40),
          child: Text(
            _questions[_questionIndex],
            style: const TextStyle(fontSize: 30, fontFamily: 'Inconsolata'),
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(40, 20, 40, 10),
          padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: palette.gray)),
          child: TextField(
            decoration: const InputDecoration(
              border: InputBorder.none,
              labelText: "Your name",
            ),
            onChanged: (value) {
              setState(() {
                _name = value;
              });
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('name', _name);
              setState(() {
                _questionIndex++;
              });
            },
            child: const Text(
              'Next',
              style: TextStyle(fontSize: 18),
            ),
          ),
          // child: RoughButton(
          //   onTap: () async {
          //     SharedPreferences prefs = await SharedPreferences.getInstance();
          //     prefs.setString('name', _name);
          //     setState(() {
          //       _questionIndex++;
          //     });
          //   },
          //   child: const Text('Next'),
          // ),
        ),
      ],
    );
  }

  Widget _buildRiskProfileSelection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 40, right: 40),
          child: Text(
            _questions[_questionIndex],
            style: const TextStyle(fontSize: 30, fontFamily: 'Inconsolata'),
          ),
        ),
        RadioListTile(
            title: const Text(
              'Are you brave and daring, ready to take on high-risk investments?',
              style: TextStyle(fontSize: 20, fontFamily: 'Inconsolata'),
            ),
            value: 'brave',
            groupValue: kind,
            onChanged: (value) {
              setState(() {
                _isDaring = true;
                kind = 'brave';
              });
            }),
        RadioListTile(
            title: const Text(
              'Or are you more cautious and methodical, sticking to lower-risk options?',
              style: TextStyle(fontSize: 20, fontFamily: 'Inconsolata'),
            ),
            value: 'cautious',
            groupValue: kind,
            onChanged: (value) {
              setState(() {
                _isDaring = false;
                kind = 'cautious';
              });
            }),
        ElevatedButton(
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setBool('isDaring', _isDaring);
            setState(() {
              _questionIndex++;
            });
          },
          child: const Text('This is me!'),
        ),
      ],
    );
  }

  Widget _buildAgeInput() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(_questions[_questionIndex]),
        TextField(
          keyboardType: TextInputType.number,
          onChanged: (value) {
            setState(() {
              _age = int.tryParse(value)!;
            });
          },
        ),
        ElevatedButton(
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setInt('age', _age);
            setState(() {
              _questionIndex++;
            });
          },
          child: const Text('Next'),
        ),
      ],
    );
  }

  Widget _buildSipAmountInput() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(_questions[_questionIndex]),
        TextField(
          keyboardType: TextInputType.number,
          onChanged: (value) {
            setState(() {
              _sipAmount = int.tryParse(value)!;
            });
          },
        ),
        ElevatedButton(
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setInt('sipAmount', _sipAmount);
            setState(() {
              _questionIndex++;
            });
          },
          child: const Text('Next'),
        ),
      ],
    );
  }

  Widget _buildHorizonInput() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(_questions[_questionIndex]),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Radio(
              value: 'five',
              groupValue: radioVal,
              onChanged: (value) {
                setState(() {
                  radioVal = 'five';

                  _horizon = 5;
                });
              },
            ),
            const Text('5 years'),
            Radio(
              value: 'ten',
              groupValue: radioVal,
              onChanged: (value) {
                setState(() {
                  radioVal = 'ten';

                  _horizon = 10;
                });
              },
            ),
            const Text('10 years'),
            Radio(
              value: 'twenty',
              groupValue: radioVal,
              onChanged: (value) {
                setState(() {
                  radioVal = 'twenty';

                  _horizon = 20;
                });
              },
            ),
            const Text('20 years'),
            Radio(
              value: 'thirty',
              groupValue: radioVal,
              onChanged: (value) {
                setState(() {
                  radioVal = 'thirty';

                  _horizon = 30;
                });
              },
            ),
            const Text('30 years'),
          ],
        ),
        ElevatedButton(
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setInt('horizon', _horizon);
            setState(() {
              _questionIndex++;
            });
          },
          child: const Text('Next'),
        ),
      ],
    );
  }

  Widget _buildFinalMessage() {
    final palette = context.watch<Palette>();

    return Container(
      padding: const EdgeInsets.all(8),
      height: 420,
      width: 345,
      decoration: BoxDecoration(
          color: palette.trueWhite,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: palette.black, width: 2)),
      child: AnimatedTextKit(
        animatedTexts: [
          TyperAnimatedText(dialogues[1],
              textStyle:
                  const TextStyle(fontFamily: "Inconsolata", fontSize: 20)),
        ],
        // isRepeatingAnimation: false,
        totalRepeatCount: 1,
        pause: const Duration(milliseconds: 5000),
        displayFullTextOnTap: true,
        stopPauseOnTap: true,
      ),
    );
  }
}
