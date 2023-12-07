import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tomatogame/Features/user_auth/presentation/pages/welcome_page.dart';
import 'package:tomatogame/GameLogics/random_num.dart';
import '../Features/user_auth/game_api_integration/game_api.dart';

/// Widget representing the main game screen in the Tomato Game application.
class Game extends StatefulWidget {
  const Game({Key? key}) : super(key: key);

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
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

  /// Start a countdown timer for the game.
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        print("Timer tick");
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer.cancel(); // Stop the timer when time is up
          _showGameOverDialog();
        }
      });
    });
  }

  /// Reset the game timer.
  void _resetTimer() {
    setState(() {
      _remainingTime = 30;
    });
  }

  /// Add extra time to the game timer.
  void _addTimeToTimer(int seconds) {
    setState(() {
      _remainingTime += seconds;
    });
  }

  /// Load the current user's data.
  Future<void> _loadUserData() async {
    currentUser = FirebaseAuth.instance.currentUser;
  }

  /// Load the user's score from Firestore.
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

  /// Update the game data from the university provided (External) API.
  void _updateGameData() {
    gameQuestions = fetchGameDataFromAPI();
    gameQuestions.then((gameData) {
      setState(() {
        currentGameData = gameData;
      });
    });
  }

  /// Fetch a new question and answer, updating the game state.
  void fetchNewQuestionAndAnswer() {
    _addTimeToTimer(5); // Add 5 seconds to the timer
    gameQuestions = fetchGameDataFromAPI();
    gameQuestions.then((gameData) {
      setState(() {
        currentGameData = gameData;
        score++;
      });

      // Move the score update to Firestore to the then block
      _saveScoreToFirestore().then((_) {
        if (score % 10 == 0) {
          setState(() {
            level++;
          });
        }

      });
    });
  }

  /// Save the user's score to Firestore.
  Future<void> _saveScoreToFirestore() async {
    if (currentUser != null) {
      await _firestore.collection('scores').doc(currentUser!.uid).set(
        {
          'score': score,
          'level': level,
        },
        SetOptions(
            merge: true), // Use merge option to update or create the document
      );
    }
  }

  /// Show the game over dialog when the game ends.
  void _showGameOverDialog() {
    showDialog(
      barrierDismissible: false,
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
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => WelcomePage()),
              );
              _timer.cancel(); //to stop the timer event
              // Update the remaining score to Firestore before exiting
              _saveRemainingScoreToFirestore(_remainingTime);
            },
            child: Text('Exit'),
          ),
        ],
      ),
    );
  }

  /// Save the remaining score to Firestore before exiting the game.
  Future<void> _saveRemainingScoreToFirestore(int remainingTime) async {
    if (currentUser != null) {
      // Calculate remaining score based on remaining time
      int remainingScore = score +
          (remainingTime * 2); // You can adjust the calculation as needed

      await _firestore.collection('scores').doc(currentUser!.uid).set(
        {
          'score': remainingScore,
          'level': level,
        },
        SetOptions(merge: true),
      );
    }
  }

  /// Restart the game with a new set of questions
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
    return WillPopScope(
      onWillPop: () async {
        _timer.cancel(); // Stop the timer when the back button is pressed
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => WelcomePage()),
        );
        return false; // Return false to prevent default back button behavior
      },
      child: Column(
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
                        // Add your UI components here
                        ),
                  RandomNum(
                    solValue: currentGameData.solution,
                    onAnswerCorrect: fetchNewQuestionAndAnswer,
                    score: score,
                    onUpdateScore: (updatedScore) {
                      setState(() {
                        score = updatedScore;
                      });
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
