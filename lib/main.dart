import 'package:flutter/material.dart';
import 'package:flutter_canvas/pages/main_menu_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Canvas',
      home: MainMenuPage(),
    );
  }
}
