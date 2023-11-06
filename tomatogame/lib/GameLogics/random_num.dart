import 'package:flutter/material.dart';
import 'dart:math';

import 'package:tomatogame/Features/user_auth/game_api_integration/game_api.dart';

import '../global/common/toast.dart';

class RandomNum extends StatefulWidget {
  const RandomNum({Key? key, required this.solValue}) : super(key: key);
  final String solValue;

  @override
  _RandomNumState createState() => _RandomNumState();
}

class _RandomNumState extends State<RandomNum> {
  String solValue = '';


  List<int> numbers = []; // List to store generated numbers

  void _randNum() {
    setState(() {
      numbers.clear(); // Clear the list to generate a new set of numbers
      numbers.add(int.parse(widget.solValue)); // Add the solValue to the list

      // Generate and add three new random numbers (excluding solValue)
      for (int i = 0; i < 3; i++) {
        int randomNum;
        do {
          randomNum = Random().nextInt(10); // Generate a random number
        } while (randomNum == int.parse(widget.solValue) || numbers.contains(randomNum));
        numbers.add(randomNum);
      }

      // Shuffle the numbers list to randomize the order
      numbers.shuffle();

      print(numbers);// Print the list of generated numbers
      print('Solution Value: ${widget.solValue}');
    });
  }


  /*
  //Previous running code
  void _randNum() {
    setState(() {
      numbers.clear(); // Clear the list to generate a new set of numbers
      numbers.add(int.parse(widget.solValue)); // Add the solValue to the list

      // Generate and add three new random numbers (excluding solValue)
      for (int i = 0; i < 3; i++) {
        int randomNum;
        do {
          randomNum = Random().nextInt(10); // Generate a random number
        } while (randomNum == int.parse(widget.solValue) || numbers.contains(randomNum));
        numbers.add(randomNum);
      }

      // Shuffle the numbers list to randomize the order
      numbers.shuffle();

      print(numbers);// Print the list of generated numbers
      print('Solution Value: ${widget.solValue}');
    });
  }
   */


  @override
  void initState() {
    super.initState();
    _randNum(); // Call _randNum in initState to set the initial value.
  }

  //Checking answer
  void checkAnswer(int selectedNumber) {
    if (selectedNumber == int.parse(widget.solValue)) {
      showToast(message: "Correct");
    } else {
      showToast(message: "Incorrect");
    }
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


        //Answers Buttons
        Container(
          width: 200,
          height: 120,
          // color: Colors.redAccent,
          decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(18)
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Answer Option Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed:  () => checkAnswer(numbers[0]),
                    child: Text("${numbers[0]}"),
                  ),

                  ElevatedButton(
                    onPressed: () => checkAnswer(numbers[1]),
                    child: Text("${numbers[1]}"),
                  ),

                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () => checkAnswer(numbers[2]),
                    child: Text("${numbers[2]}"),
                  ),

                  ElevatedButton(
                    onPressed: () => checkAnswer(numbers[3]),
                    child: Text("${numbers[3]}"),
                  ),

                ],
              ),

            ],
          ),
        ),


      ],
    );
  }
}
