import 'package:flutter/material.dart';
import 'package:flutter_canvas/pages/game_page.dart';

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: const Color.fromARGB(255, 59, 100, 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Number of tiles',
                style: TextStyle(fontSize: 32, color: Colors.black),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _openGamePage(8, context),
                    child: const Text('8'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () => _openGamePage(15, context),
                    child: const Text('15'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () => _openGamePage(24, context),
                    child: const Text('24'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _openGamePage(35, context),
                    child: const Text('35'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () => _openGamePage(48, context),
                    child: const Text('48'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () => _openGamePage(63, context),
                    child: const Text('63'),
                  ),
                ],
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
