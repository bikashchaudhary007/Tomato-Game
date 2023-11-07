import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../GameLogics/random_num.dart';

class GameApi extends StatefulWidget {
  const GameApi({super.key});

  @override
  State<GameApi> createState() => _GameApiState();
}

class _GameApiState extends State<GameApi> {
  int score =0;
  void _increaseScore() {
    setState(() {
      score++;
      print('Score: $score');
    });
  }

  late GameData currentGameData;

  @override
  void initState() {
    super.initState();
    fetchGameDataFromAPI().then((gameData) {
      setState(() {
        currentGameData = gameData;
      });
    });
  }

  void fetchNewDataAndRestart() {
    fetchGameDataFromAPI().then((gameData) {
      setState(() {
        currentGameData = gameData;
        _increaseScore();
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Level and Scores
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            //Level
            Container(
              width: 120,
              height: 35,
              // color: Colors.redAccent,
              decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(18)
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Level", style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24
                  ),),

                  Text("07", style: TextStyle(
                      color: Colors.yellow,
                      fontWeight: FontWeight.bold,
                      fontSize: 24
                  ),),
                ],
              ),
            ),

            //Score
            Container(
              width: 120,
              height: 35,
              // color: Colors.redAccent,
              decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(18)
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Text("Level", style: TextStyle(
                  //     color: Colors.white,
                  //     fontWeight: FontWeight.bold,
                  //     fontSize: 24
                  // ),),

                  Text("Score: $score", style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24
                  ),),
                ],
              ),
            ),
          ],
        ),

        FutureBuilder<GameData>(
          future: fetchGameDataFromAPI(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData) {
              return Center(child: Text("No data available."));
            }

            currentGameData = snapshot.data!;

            // Display the image using Image.network
            return Column(
              mainAxisAlignment:
              MainAxisAlignment.center, // Center the contents vertically.
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
                SizedBox(
                    height: 16), // Add some space between the image and the text.
                Text(
                  currentGameData.solution,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center, // Center the text horizontally.
                ),
                Divider(),

                // RandomNum(solValue: snapshot.data?.solution ?? '',)
                RandomNum(
                  solValue: currentGameData.solution,
                  onAnswerCorrect: fetchNewDataAndRestart,
                )
              ],
            );
          },
        ),

      ],
    );
  }
}

Future<GameData> fetchGameDataFromAPI() async {
  final response =
  // await http.get(Uri.parse('https://marcconrad.com/uob/tomato/api.php'));
  await http
      .get(Uri.parse('https://marcconrad.com/uob/tomato/api.php?out=json'));
  if (response.statusCode == 200) {
    Map<String, dynamic> responseJson = json.decode(response.body);
    GameData gameData = createGameData(responseJson);
    return gameData;
  } else {
    throw Exception('Failed to load data from the API');
  }
}

GameData createGameData(Map<String, dynamic> data) {
  String imageUrl = data["question"];
  // print(imageUrl);
  String solution = data["solution"].toString(); // Convert to String;
  return GameData(
    imageUrl: imageUrl,
    solution: solution,
  );
}

class GameData {
  final String imageUrl; // Represents the image URL
  final String solution; // Represents the solution string

  GameData({required this.imageUrl, required this.solution});
}

