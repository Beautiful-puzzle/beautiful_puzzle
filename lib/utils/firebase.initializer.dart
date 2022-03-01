import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class FirebaseInitializer {

  static Future<void> initialize() async {
    await Firebase.initializeApp();
    WidgetsFlutterBinding.ensureInitialized();
  }
}