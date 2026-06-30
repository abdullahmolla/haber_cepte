import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:haber_cepte/app/app.dart';
import 'package:haber_cepte/core/cache/hive_service.dart';
import 'package:haber_cepte/firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveService.init();

 /* await MasterApp.runBefore(
  hydrated: true,
);
*/
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const HaberCepteApp());
}