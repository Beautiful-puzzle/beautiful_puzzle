import 'package:flutter/material.dart';

class GameCardModel {
  GameCardModel({
    required this.isEmpty,
    required this.offset,
    required this.id,
    required this.number,
  });

  final bool isEmpty;

  Offset offset;
  final String id;
  final int number;
}
