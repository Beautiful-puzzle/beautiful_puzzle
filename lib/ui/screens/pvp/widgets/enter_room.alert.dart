import 'package:animated_gesture_detector/animated_gesture_detector.dart';
import 'package:beautiful_puzzle/models/enums.dart';
import 'package:beautiful_puzzle/resources/colors.dart';
import 'package:beautiful_puzzle/ui/screens/pvp/room/room_await.screen.dart';
import 'package:beautiful_puzzle/ui/screens/pvp/room_list/rooms_list.bloc.dart';
import 'package:beautiful_puzzle/ui/widgets/base/dialog.navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EnterRoomAlert extends StatelessWidget {
  EnterRoomAlert({Key? key, required this.bloc}) : super(key: key);

  final RoomsListBloc bloc;

  static Future<dynamic> navigate(
    BuildContext context, {
    required RoomsListBloc bloc,
  }) {
    return dialogNavigate(
      context: context,
      barrierColor: Colors.black.withOpacity(.8),
      dialog: EnterRoomAlert(bloc: bloc),
      dialogBuilder: (dialog, animation) {
        return SlideTransition(
          position: animation,
          child: dialog,
        );
      },
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final button = AnimatedGestureDetector(
      onTap: () => bloc.createdRoom != null
          ? validate(context)
          : Navigator.pop(context, passwordController.text.trim()),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 30,
        ),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(100.0)),
          color: ColorsResource.primary,
        ),
        child: const Text(
          "Yeah",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );

    final nahButton = AnimatedGestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 30,
        ),
        child: const Text(
          "Nah",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 98),
        Text(
          'Room name: ${bloc.createdRoom?.name ?? bloc.generateRoomName()}',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 27),
        Form(
          key: _formKey,
          child: TextFormField(
            controller: passwordController,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: TextInputType.number,
            validator: (value) =>
                bloc.createdRoom != null && value != bloc.createdRoom!.password
                    ? 'Wrong password'
                    : null,
            maxLength: 8,
          ),
        ),
        const SizedBox(height: 27),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            nahButton,
            button,
          ],
        ),
        const SizedBox(height: 66),
      ],
    );

    return Material(
      color: Colors.transparent,
      child: Column(
        children: [
          const Spacer(),
          Container(
            width: 330,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: ColorsResource.surface,
              borderRadius: const BorderRadius.all(const Radius.circular(20)),
            ),
            child: content,
          ),
          const Spacer(),
        ],
      ),
    );
  }

  void validate(BuildContext context) {
    final FormState? form = _formKey.currentState;
    if (form?.validate() ?? false) {
      Navigator.pop(context, passwordController.text.trim());
    }
  }
}
