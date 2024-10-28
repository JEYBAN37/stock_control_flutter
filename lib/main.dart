import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_hive/todo_page.dart';

/* void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var directory = Directory.current.path;
  Hive.init(directory);

  await Hive.openBox('todoBox');

  runApp(const MyApp());
} */

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Directory appDocDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);

  await Hive.openBox('todoBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'To-Do App with Hive',
      home: InventoryPage(),
    );
  }
}
