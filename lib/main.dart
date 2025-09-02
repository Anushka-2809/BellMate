
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rock, Paper, Scissors',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Rock, Paper, Scissors'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _playerChoice = '';
  String _computerChoice = '';
  String _result = '';

  void _play(String playerChoice) {
    setState(() {
      _playerChoice = playerChoice;
      _computerChoice = _getComputerChoice();
      _result = _getResult(_playerChoice, _computerChoice);
    });
  }

  String _getComputerChoice() {
    const choices = ['Rock', 'Paper', 'Scissors'];
    return choices[Random().nextInt(choices.length)];
  }

  String _getResult(String playerChoice, String computerChoice) {
    if (playerChoice == computerChoice) {
      return 'It\'s a tie!';
    } else if ((playerChoice == 'Rock' && computerChoice == 'Scissors') ||
        (playerChoice == 'Scissors' && computerChoice == 'Paper') ||
        (playerChoice == 'Paper' && computerChoice == 'Rock')) {
      return 'You win!';
    } else {
      return 'You lose!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Choose your weapon:',
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _play('Rock'),
                  child: const Text('Rock'),
                ),
                ElevatedButton(
                  onPressed: () => _play('Paper'),
                  child: const Text('Paper'),
                ),
                ElevatedButton(
                  onPressed: () => _play('Scissors'),
                  child: const Text('Scissors'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text('You chose: $_playerChoice'),
            Text('Computer chose: $_computerChoice'),
            const SizedBox(height: 20),
            Text(
              _result,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
