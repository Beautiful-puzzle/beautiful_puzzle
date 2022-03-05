import 'package:beautiful_puzzle/ui/widgets/base/dialog.navigator.dart';
import 'package:beautiful_puzzle/utils/simple_code.dart';
import 'package:flutter/material.dart';

class SaveGameResultAlert extends StatefulWidget {
  const SaveGameResultAlert({Key? key}) : super(key: key);

  static Future<dynamic> navigate(BuildContext context) {
    return dialogNavigate(
      context: context,
      barrierColor: Colors.black.withOpacity(1.0),
      dialog: const SaveGameResultAlert(),
      dialogBuilder: (dialog, animation) {
        return SlideTransition(
          position: animation,
          child: dialog,
        );
      },
    );
  }

  @override
  State<SaveGameResultAlert> createState() => _SaveGameResultAlertState();
}

class _SaveGameResultAlertState extends State<SaveGameResultAlert> {
  @override
  void initState() {
    runAfterBuild((_) async {
      await Future.delayed(const Duration(milliseconds: 1500));
      if (mounted) {
        Navigator.pop(context);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: const [
          Positioned(
            bottom: 40,
            right: 20,
            child: SizedBox(
              width: 260,
              child: Text(
                'You complete the game. Congratulations!',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
