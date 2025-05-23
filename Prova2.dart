import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const TreasureGameApp());
}

class TreasureGameApp extends StatelessWidget {
  const TreasureGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'THE JOGO',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const TreasureGamePage(),
    );
  }
}

class TreasureGamePage extends StatefulWidget {
  const TreasureGamePage({super.key});

  @override
  State<TreasureGamePage> createState() => _TreasureGamePageState();
}

class _TreasureGamePageState extends State<TreasureGamePage> {
  int? treasure;
  int? bomb;
  int? monster;
  String message = 'Escolha um número de 1 a 20';
  List<bool> disabled = List.generate(20, (index) => false);
  List<String> buttonTexts = List.generate(20, (index) => '${index + 1}');
  bool gameEnded = false;

  void startNewGame() {
    final rand = Random();
    Set<int> numbers = {};
    while (numbers.length < 3) {
      numbers.add(rand.nextInt(20) + 1);
    }
    final list = numbers.toList();
    treasure = list[0];
    bomb = list[1];
    monster = list[2];
    disabled = List.generate(20, (index) => false);
    buttonTexts = List.generate(20, (index) => '${index + 1}');
    message = 'Escolha um número de 1 a 20';
    gameEnded = false;
    setState(() {});
  }

  void handlePress(int index) {
    if (gameEnded || disabled[index]) return;

    int number = index + 1;
    setState(() {
      if (number == treasure) {
        message = 'Você encontrou o tesouro! 🪙';
        buttonTexts[index] = '🪙';
        gameEnded = true;
        disabled = List.generate(20, (i) => true);
      } else if (number == bomb) {
        message = 'Você explodiu na bomba! 💣';
        buttonTexts[index] = '💣';
        gameEnded = true;
        disabled = List.generate(20, (i) => true);
      } else if (number == monster) {
        message = 'O monstro te pegou! 👾';
        buttonTexts[index] = '👾';
        gameEnded = true;
        disabled = List.generate(20, (i) => true);
      } else {
        message = 'O tesouro está em um número ' +
            (number < treasure! ? 'maior' : 'menor') + '! ❓';
        buttonTexts[index] = '❓';
        disabled[index] = true;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startNewGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('THE JOGO'),
        centerTitle: true,
        backgroundColor: Colors.teal[100],
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                message,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: 20,
                itemBuilder: (context, index) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal[200],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: disabled[index] ? null : () => handlePress(index),
                    child: Text(
                      buttonTexts[index],
                      style: const TextStyle(fontSize: 18),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.replay),
                label: const Text('Novo Jogo'),
                onPressed: startNewGame,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
