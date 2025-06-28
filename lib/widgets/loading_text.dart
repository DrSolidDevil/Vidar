import "dart:async";
import "dart:math";
import "package:flutter/material.dart";
import "package:vidar/configuration.dart";

class LoadingText extends StatefulWidget {
  const LoadingText({required this.style, super.key});
  final TextStyle style;

  @override
  _LoadingTextState createState() => _LoadingTextState();
}

class _LoadingTextState extends State<LoadingText> {
  String currentText = "Loading";
  int numberOfDots = 1;
  bool reverse = false;
  late Timer timer;
  late final TextStyle style;

  @override
  void initState() {
    super.initState();
    style = widget.style;

    timer = Timer.periodic(const Duration(seconds: 2), (final Timer t) {
      setState(() {
        switch (numberOfDots) {
          case 1:
            currentText = "Loading.";
            if (reverse) {
              reverse = false;
              numberOfDots = 1;
            } else {
              numberOfDots = 2;
            }
            break;
          case 2:
            currentText = "Loading..";
            if (reverse) {
              --numberOfDots;
            } else {
              ++numberOfDots;
            }
            break;
          case 3:
            currentText = "Loading...";
            reverse = true;
            --numberOfDots;
            break;
        }
      });
    });
  }

  @override
  void dispose() {
    timer.cancel(); // Always clean up the timer
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return TextField(
      controller: TextEditingController(text: currentText),
      readOnly: true,
      textAlign: TextAlign.center,
      style: style,
      decoration: const InputDecoration(border: InputBorder.none),
    );
  }
}

class DecryptingText extends StatefulWidget {
  const DecryptingText({required this.targets, required this.style, super.key});
  final TextStyle style;
  final List<String> targets;

  @override
  _DecryptingTextState createState() => _DecryptingTextState();
}

class _DecryptingTextState extends State<DecryptingText> {
  String currentText = "";
  List<int> placedFromTarget = <int>[];
  int currentTarget = 0;
  late int generationLength;
  late int targetLength;
  late final List<String> targets;
  final Random random = Random();
  int skip = 0;
  static const int numberOfSkips =
      TimeConfiguration.delayOnCompletedDecryptedLoading *
      1e3 ~/
      TimeConfiguration.decryptingLoadingText;

  late Timer timer;
  late final TextStyle style;
  int iteration = 0;

  @override
  void initState() {
    super.initState();
    style = widget.style;
    targets = widget.targets;
    generationLength = targets[currentTarget].length;
    targetLength = targets[currentTarget].length;
    currentText = List<String>.generate(
      targetLength,
      (_) => _generateRandomChar(),
    ).join();
    timer = Timer.periodic(
      const Duration(milliseconds: TimeConfiguration.decryptingLoadingText),
      (final Timer t) {
        setState(() {
          if (skip != 0) {
            skip = skip > numberOfSkips ? 0 : skip + 1;
          } else {
            if (currentText == targets[currentTarget]) {
              // Changing target
              if (currentTarget == targets.length - 1) {
                currentTarget = 0;
              } else {
                ++currentTarget;
              }
              targetLength = targets[currentTarget].length;
              placedFromTarget = <int>[];
              skip = 1;
            } else {
              if (generationLength != targetLength) {
                if (generationLength > targetLength) {
                  --generationLength;
                } else {
                  ++generationLength;
                }
              }
              if (iteration++ % 3 == 0) {
                placedFromTarget.add(
                  _generateUniqueRandomInt(placedFromTarget, targetLength),
                );
              }
              final List<String> newText = <String>[];
              for (final int i in Iterable<int>.generate(generationLength)) {
                if (placedFromTarget.contains(i)) {
                  newText.add(targets[currentTarget][i]);
                } else {
                  newText.add(_generateRandomChar());
                }
              }
              currentText = newText.join();
            }
          }
        });
      },
    );
  }

  @override
  void dispose() {
    timer.cancel(); // Always clean up the timer
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return TextField(
      controller: TextEditingController(text: currentText),
      readOnly: true,
      textAlign: TextAlign.center,
      style: style,
      decoration: const InputDecoration(border: InputBorder.none),
    );
  }
}

String _generateRandomChar() {
  //MiscellaneousConfiguration.loadingTextChars
  final Random random = Random();
  const String chars =
      r"AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890!@#%&/()=?+}][{$@}]*<>-_.:,;~^§\";
  return chars[random.nextInt(chars.length)];
}

int _generateUniqueRandomInt(final List<int> reserved, final int max) {
  if (reserved.length == max) {
    throw Exception("All numbers are reserved!");
  }
  final Random random = Random();
  late int x;
  do {
    x = random.nextInt(max);
  } while (reserved.contains(x));
  return x;
}
