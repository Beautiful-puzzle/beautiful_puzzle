import 'dart:ui';

import 'package:flutter/material.dart';

/// Runs 'function' after the original build is built
void runAfterBuild(FrameCallback callback) {
  WidgetsBinding.instance!
      .addPostFrameCallback(callback);
}

void hideKeyboard(BuildContext context) {
  FocusScope.of(context).unfocus();
}