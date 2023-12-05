import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Features/user_auth/game_api_integration/game_api.dart';
import 'random_num.dart';

class Game2 extends StatefulWidget {
  const Game2({Key? key}) : super(key: key);

  @override
  State<Game2> createState() => _GameState();
}

class _GameState extends State<Game2> {
  int score = 0;
  int level = 1; // Added level variable
  late GameData currentGameData;
  late User? currentUser; // Variable to store the current user

  late Future<GameData> gameQuestions;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadScoreFromFirestore();
    _updateGameData();
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
        level = ((score ~/ 10) + 1); // Update level based on the score
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
    gameQuestions = fetchGameDataFromAPI();
    gameQuestions.then((gameData) {
      setState(() {
        currentGameData = gameData;
        score++;
        print('Score: $score');
        _saveScoreToFirestore();

        // Check if score is a multiple of 10 to increase the level
        if (score % 10 == 0) {
          level++;
          print('Level increased to: $level');
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Level and Scores
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Level Container
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
                    "$level", // Display the current level
                    style: TextStyle(
                        color: Colors.yellow,
                        fontWeight: FontWeight.bold,
                        fontSize: 24),
                  ),
                ],
              ),
            ),

            // Score Container
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

        // Game Data
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
                Text(
                  currentGameData.solution,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Divider(),
                if (currentUser != null)
                  Column(
                    children: [
                      Text(
                        'Welcome, ${currentUser!.displayName}!',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Your current username is: ${currentUser!.displayName}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
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
