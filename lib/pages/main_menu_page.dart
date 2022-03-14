import 'package:flutter/material.dart';
import 'package:flutter_canvas/pages/game_page.dart';

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              primary: const Color.fromARGB(255, 177, 100, 0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
        ),
      ),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 0, 0, 0),
                  Color.fromARGB(255, 73, 0, 0),
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Puzzle',
                style: TextStyle(
                  fontSize: 72,
                  color: Color.fromARGB(255, 255, 184, 62),
                  fontWeight: FontWeight.bold,
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(20, 20),
                      blurRadius: 8.0,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ],
                  fontFamily: 'Georgia',
                ),
              ),
              const SizedBox(height: 16),

              /// 8 tiles button
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () => _openGamePage(8, context),
                  child: const Text(
                    'Tiles: 8',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              /// 15 tiles button
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () => _openGamePage(15, context),
                  child: const Text(
                    'Tiles: 15',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openGamePage(int nTiles, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GamePage(nTiles: nTiles)),
    );
  }
}
