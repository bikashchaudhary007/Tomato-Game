import 'package:flutter/material.dart';
import '../Features/user_auth/game_api_integration/game_api.dart';
import 'random_num.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
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
      });
      _increaseScore();
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
