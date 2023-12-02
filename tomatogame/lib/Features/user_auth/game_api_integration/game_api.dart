
import 'package:http/http.dart' as http;
import 'dart:convert';

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

