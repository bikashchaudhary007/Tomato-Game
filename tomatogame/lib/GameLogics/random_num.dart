import 'package:flutter/material.dart';
import 'dart:math';

import 'package:tomatogame/GameLogics/game.dart';

import '../global/common/toast.dart';

class RandomNum extends StatefulWidget {
  const RandomNum({Key? key, required this.solValue, required this.onAnswerCorrect}) : super(key: key);
  final String solValue;
  final VoidCallback onAnswerCorrect;

  @override
  _RandomNumState createState() => _RandomNumState();
}

class _RandomNumState extends State<RandomNum> {
  //game score


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




  @override
  void initState() {
    super.initState();
    _randNum(); // Call _randNum in initState to set the initial value.
  }

  //Checking answer
  void checkAnswer(int selectedNumber) {
    if (selectedNumber == int.parse(widget.solValue)) {
      // If the answer is correct, call the callback to fetch new data
      showToast(message: "Correct Answer");
      widget.onAnswerCorrect();
    } else {
      showToast(message: "Incorrect");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        //Answers Buttons
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 250,
            height: 200,
            // color: Colors.redAccent,
            decoration: BoxDecoration(
                color: Colors.redAccent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(18)
            ),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Answer Option Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints.tightFor(height: 60,width: 70),
                      child: ElevatedButton(
                        onPressed:  () => checkAnswer(numbers[0]),
                        child: Text("${numbers[0]}"),
                        style: ElevatedButton.styleFrom(
                            primary:  Colors.red,
                            elevation: 25,
                            shadowColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                            )
                        ),
                      ),
                    ),

                    ConstrainedBox(
                      constraints: BoxConstraints.tightFor(height: 60,width: 70),
                      child: ElevatedButton(
                        onPressed: () => checkAnswer(numbers[1]),
                        child: Text("${numbers[1]}"),
                        style: ElevatedButton.styleFrom(
                            primary:  Colors.red,
                            elevation: 25,
                            shadowColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                            )
                        ),
                      ),
                    ),

                  ],
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints.tightFor(height: 60,width: 70),
                      child: ElevatedButton(
                        onPressed: () => checkAnswer(numbers[2]),
                        child: Text("${numbers[2]}"),
                        style: ElevatedButton.styleFrom(
                            primary:  Colors.red,
                            elevation: 25,
                            shadowColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                            )
                        ),
                      ),
                    ),

                    ConstrainedBox(
                      constraints: BoxConstraints.tightFor(height: 60,width: 70),
                      child: ElevatedButton(
                        onPressed: () => checkAnswer(numbers[3]),
                        child: Text("${numbers[3]}"),
                        style: ElevatedButton.styleFrom(
                            primary:  Colors.red,
                            elevation: 25,
                            shadowColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                            )
                        ),
                      ),
                    ),

                  ],
                ),

              ],
            ),
          ),
        ),


      ],
    );
  }
}
