import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  static List<int> snakePosition = [45, 65, 85, 105, 125];
  static int numberOfSquares = 540;
  int numberInRow = 20;
  bool gameHasStarted = false;

  static var randomNumber = Random();

  ///try removing the -1
  int food = randomNumber.nextInt(numberOfSquares);

  void generateNewFood() {
    food = randomNumber.nextInt(numberOfSquares) ;
  }

  void startGame() {
    gameHasStarted = true;
    snakePosition = [45, 65, 85, 105, 125];
    const duration = const Duration(milliseconds: 160);
    Timer.periodic(duration, (Timer timer) {
      updateSnake();
      if (gameOver()) {
        timer.cancel();
        _showGameOverScreen();
      }
    });
  }

  var direction = 'down';

  void updateSnake() {
    setState(() {
      switch (direction) {
        case 'down':
          if (snakePosition.last > numberOfSquares - numberInRow) {
            snakePosition
                .add(snakePosition.last + numberInRow - numberOfSquares);
          } else {
            snakePosition.add(snakePosition.last + numberInRow);
          }
          break;

        case 'up':
          if (snakePosition.last < numberInRow) {
            snakePosition
                .add(snakePosition.last - numberInRow + numberOfSquares);
          } else {
            snakePosition.add(snakePosition.last - numberInRow);
          }
          break;

        case 'left':
          if (snakePosition.last % numberInRow == 0) {
            snakePosition.add(snakePosition.last - 1 + numberInRow);
          } else {
            snakePosition.add(snakePosition.last - 1);
          }

          break;

        case 'right':
          if ((snakePosition.last + 1) % numberInRow == 0) {
            snakePosition.add(snakePosition.last + 1 - numberInRow);
          } else {
            snakePosition.add(snakePosition.last + 1);
          }
          break;

        default:
      }
      if(snakePosition.last == food) {
        generateNewFood();
      } else {
        snakePosition.removeAt(0);
      }
    });
  }

  bool gameOver() {
    for (int i = 0; i < snakePosition.length; i++) {
      int count = 0;
      for (int j = 0; j < snakePosition.length; j++) {
        if (snakePosition[i] == snakePosition[j]) {
          count += 1;
        }
        if (count == 2) {
          return true;
        }
      }
    }
    return false;
  }

  void _showGameOverScreen() {
    gameHasStarted = false;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('GAME OVER'),
            content: Text('You\'re score: ' + snakePosition.length.toString()),
            actions: <Widget>[
              TextButton(
                child: Text('Play Again'),
                onPressed: () {
                  Navigator.of(context).pop();
                  startGame();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.18,
            ),
            Expanded(
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (direction != 'up' && details.delta.dy > 0) {
                    direction = 'down';
                    print(details);
                  } else if (direction != 'down' && details.delta.dy < 0) {
                    direction = 'up';
                    print(details);
                  }
                },
                onHorizontalDragUpdate: (DragUpdateDetails details) {
                  if (direction != 'left' && details.delta.dx > 0) {
                    direction = 'right';
                    print(details);
                  } else if (direction != 'right' && details.delta.dx < 0) {
                    direction = 'left';
                    print(details);
                  }
                },
                child: Container(
                  child: GridView.builder(
                    itemCount: numberOfSquares,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: numberInRow,
                    ),
                    itemBuilder: (context, index) {
                      if(snakePosition.contains(index)) {
                        return Center(
                          child: Container(
                            padding: EdgeInsets.all(2.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: Container(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      }
                      if(index == food) {
                        return Container(
                          padding: EdgeInsets.all(2.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Container(
                              color: Colors.green,
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          padding: EdgeInsets.all(2),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(color: Colors.grey[700])),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){
                      if(gameHasStarted == false) {
                        startGame();
                      }
                    },
                    child: Text(
                      'Start',
                      style: TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
