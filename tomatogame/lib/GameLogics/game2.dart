import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tomatogame/GameLogics/random_num.dart';
import '../Features/user_auth/game_api_integration/game_api.dart';


class Game2 extends StatefulWidget {
  const Game2({Key? key}) : super(key: key);

  @override
  State<Game2> createState() => _GameState();
}

class _GameState extends State<Game2> {
  int score = 0;
  int level = 1;
  late GameData currentGameData;
  late User? currentUser;
  late Future<GameData> gameQuestions;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late bool _gameOver = false;
  late Timer _timer;
  late int _remainingTime = 30;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadScoreFromFirestore();
    _updateGameData();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer to avoid memory leaks
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer.cancel(); // Stop the timer when time is up
          _showGameOverDialog();
        }
      });
    });
  }

  void _resetTimer() {
    setState(() {
      _remainingTime = 30;
    });
  }

  void _addTimeToTimer(int seconds) {
    setState(() {
      _remainingTime += seconds;
    });
  }

  Future<void> _loadUserData() async {
    currentUser = FirebaseAuth.instance.currentUser;
  }

  Future<void> _loadScoreFromFirestore() async {
    if (currentUser != null) {
      DocumentSnapshot<Map<String, dynamic>> scoreDoc =
      await _firestore.collection('scores').doc(currentUser!.uid).get();

      setState(() {
        score = scoreDoc.exists ? scoreDoc.data()!['score'] ?? 0 : 0;
        level = ((score ~/ 10) + 1);
      });
    }
  }

  void _updateGameData() {
    gameQuestions = fetchGameDataFromAPI();
    gameQuestions.then((gameData) {
      setState(() {
        currentGameData = gameData;
      });
    });
  }

  void fetchNewQuestionAndAnswer() {
    _addTimeToTimer(5); // Add 5 seconds to the timer
    gameQuestions = fetchGameDataFromAPI();
    gameQuestions.then((gameData) {
      setState(() {
        currentGameData = gameData;
        score++;

        _saveScoreToFirestore();

        if (score % 10 == 0) {
          level++;
        }
      });
    });
  }

  Future<void> _saveScoreToFirestore() async {
    if (currentUser != null) {
      await _firestore.collection('scores').doc(currentUser!.uid).set({
        'score': score,
        'level': level,
      });
    }
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Game Over'),
        content: Text('Your final score is $score'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _restartGame();
            },
            child: Text('Play Again'),
          ),
        ],
      ),
    );
  }

  void _restartGame() {
    setState(() {
      _gameOver = false;
      _remainingTime = 30;
    });

    _startTimer();
    _updateGameData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 120,
              height: 35,
              decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(18)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Level",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                  Text(
                    "$level",
                    style: TextStyle(
                        color: Colors.yellow,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                ],
              ),
            ),
            Container(
              width: 120,
              height: 35,
              decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(18)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Score: $score",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: 16),
        FutureBuilder<GameData>(
          future: gameQuestions,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData) {
              return Center(child: Text("No data available."));
            }

            currentGameData = snapshot.data!;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Image.network(
                    currentGameData.imageUrl,
                    errorBuilder: (context, error, stackTrace) {
                      return Column(
                        children: [
                          Text("Failed to load the image."),
                          Text("Error: ${error.toString()}"),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(height: 16),

                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: 1 - (_remainingTime / 30),
                      color: Colors.red,
                    ),
                    Text(
                      '$_remainingTime',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                Divider(),
                if (currentUser != null)
                  Column(

                  ),
                RandomNum(
                  solValue: currentGameData.solution,
                  onAnswerCorrect: fetchNewQuestionAndAnswer,
                ),

              ],
            );
          },
        ),
      ],
    );
  }
}
