import 'package:flutter/material.dart';
import 'dart:math';

import 'package:tomatogame/Features/user_auth/game_api_integration/game_api.dart';

class RandomNum extends StatefulWidget {
  const RandomNum({Key? key}) : super(key: key);

  @override
  _RandomNumState createState() => _RandomNumState();
}

class _RandomNumState extends State<RandomNum> {



  List<int> numbers = []; // List to store generated numbers

  void _randNum() {
    setState(() {
      numbers.clear(); // Clear the list to generate a new set of numbers
      for (int i = 0; i < 4; i++) {
        numbers.add(Random().nextInt(10)); // Generate and add three new random numbers
      }
      print(numbers); // Print the list of generated numbers
    });
  }

  @override
  void initState() {
    super.initState();
    _randNum(); // Call _randNum in initState to set the initial value.
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Text(
            "Random numbers: ${numbers.join(', ')}", // Display the list of numbers
            style: TextStyle(
              color: Colors.green,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: _randNum, // Call _randNum when the button is pressed.
          child: Text("Generate Random Numbers"),
        ),
      ],
    );
  }
}
