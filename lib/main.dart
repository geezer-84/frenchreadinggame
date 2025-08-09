import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(const FrenchWordGame());
}

class FrenchWordGame extends StatelessWidget {
  const FrenchWordGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'French Reading Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<dynamic> words = [];
  int currentIndex = 0;
  bool answered = false;
  String selectedAnswer = '';
  int score = 0;
  bool loading = true;

  final FlutterTts tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    initTTS();
    loadWords();
  }

  Future<void> initTTS() async {
    await tts.setLanguage("fr-FR");
    await tts.setSpeechRate(0.4); // slower for kids
    await tts.setPitch(1.0);
  }

  Future<void> loadWords() async {
    final String jsonString = await rootBundle.loadString('assets/words.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    jsonData.shuffle(Random());
    setState(() {
      words = jsonData;
      loading = false;
    });
    // speak first word after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (words.isNotEmpty) speakWord(words[0]['word']);
    });
  }

  Future<void> speakWord(String word) async {
    await tts.stop();
    await tts.speak(word);
  }

  void selectAnswer(String answer) {
    if (answered) return;

    setState(() {
      selectedAnswer = answer;
      answered = true;
      if (answer == words[currentIndex]['word']) {
        score++;
      }
    });
  }

  void nextQuestion() {
    setState(() {
      currentIndex = (currentIndex + 1) % words.length;
      answered = false;
      selectedAnswer = '';
    });
    speakWord(words[currentIndex]['word']);
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final currentWord = words[currentIndex];
    final List<String> options = List<String>.from(currentWord['options']);

    return Scaffold(
      appBar: AppBar(
        title: Text('Score: $score'),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up),
            onPressed: () => speakWord(currentWord['word']),
          )
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Écoute et choisis le mot correct",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              ...options.map((option) {
                bool isCorrect = option == currentWord['word'];
                Color buttonColor = Colors.blue;

                if (answered) {
                  if (option == selectedAnswer) {
                    buttonColor = isCorrect ? Colors.green : Colors.red;
                  } else if (isCorrect) {
                    buttonColor = Colors.green;
                  }
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 20.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      minimumSize: const Size.fromHeight(60),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => selectAnswer(option),
                    child: Text(option, style: const TextStyle(fontSize: 24)),
                  ),
                );
              }).toList(),
              const SizedBox(height: 16),
              if (answered)
                ElevatedButton(
                  onPressed: nextQuestion,
                  child: const Text("Suivant"),
                )
              else
                const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
