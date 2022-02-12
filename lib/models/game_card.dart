import 'package:flutter/material.dart';

class GameCardModel {
  GameCardModel({
    required this.isEmpty,
    required this.offset,
    required this.id,
  });

  final bool isEmpty;

  Offset offset;
  final int id;
}
