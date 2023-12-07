import 'package:http/http.dart' as http;
import 'dart:convert';

/// Fetches game data from the API and returns a [GameData] object.
///
/// Makes an asynchronous HTTP GET request to retrieve JSON data from the API
/// endpoint. If the request is successful, parses the JSON data and creates a
/// [GameData] object.
Future<GameData> fetchGameDataFromAPI() async {
  final response = await http
      .get(Uri.parse('https://marcconrad.com/uob/tomato/api.php?out=json'));
  if (response.statusCode == 200) {

    // Parse JSON response
    Map<String, dynamic> responseJson = json.decode(response.body);

    // Create GameData object from parsed JSON
    GameData gameData = createGameData(responseJson);
    return gameData;
  } else {
    // Throw an exception if the API request fails
    throw Exception('Failed to load data from the API');
  }
}

/// Creates a [GameData] object from the given JSON data.
///
/// Extracts the image URL and solution from the JSON data and constructs a
/// [GameData] object.
GameData createGameData(Map<String, dynamic> data) {
  // Extract image URL and solution from the JSON data
  String imageUrl = data["question"];
  String solution = data["solution"].toString(); // Convert to String;

  // Create and return a GameData object
  return GameData(
    imageUrl: imageUrl,
    solution: solution,
  );
}

/// Represents data for a game, including the image URL and solution.
///
/// This class is used to encapsulate information retrieved from the game API.
class GameData {
  final String imageUrl; // Represents the image URL
  final String solution; // Represents the solution string

  /// Class representing game data
  GameData({required this.imageUrl, required this.solution});
}
