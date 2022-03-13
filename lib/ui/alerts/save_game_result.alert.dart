import 'package:beautiful_puzzle/ui/widgets/base/dialog.navigator.dart';
import 'package:beautiful_puzzle/utils/simple_code.dart';
import 'package:flutter/material.dart';

class SaveGameResultAlert extends StatefulWidget {
  const SaveGameResultAlert({Key? key, this.name}) : super(key: key);

  final String? name;

  static Future<dynamic> navigate(BuildContext context, {String? name}) {
    return dialogNavigate(
      context: context,
      barrierColor: Colors.black.withOpacity(1.0),
      dialog: SaveGameResultAlert(name: name),
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
        children: [
          Positioned(
            bottom: 40,
            right: 20,
            child: SizedBox(
              width: 260,
              child: Text(
                widget.name != null
                    ? '${widget.name} complete the game.'
                    : 'You complete the game. Congratulations!',
                textAlign: TextAlign.right,
                style: const TextStyle(
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
