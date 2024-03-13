import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_game_app/widgets/blank_pixel.dart';
import 'package:flutter_game_app/widgets/foodpixel.dart';
import 'package:flutter_game_app/widgets/highscoretile.dart';
import 'package:flutter_game_app/widgets/snake_pixel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum snake_Direction { UP, DOWN, LEFT, RIGHT }

class _HomePageState extends State<HomePage> {
  int rowSize = 10;
  int totalNumberofSqures = 100;
  bool gameHasstarted = false;
  final _namecontroller = TextEditingController();

  int currentscore = 0;

  List<int> snakePosition = [0, 1, 2];

  var currentDirection = snake_Direction.RIGHT;

  int foodposition = 55;

  List<String> highscore_docid = [];
  late final Future? letsgetdocid;

  @override
  void initState() {
    letsgetdocid = getDocid();
    super.initState();
  }

  Future getDocid() async {
    await FirebaseFirestore.instance
        .collection("highscores")
        .orderBy("score", descending: true)
        .limit(10)
        .get()
        .then((value) => value.docs.forEach((element) {
              highscore_docid.add(element.reference.id);
            }));
  }

  void startgame() {
    gameHasstarted = true;
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() {
        moveSnake();
        // claimFood();
        if (gameOver()) {
          timer.cancel();
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Game Over'),
                  content: Column(
                    children: [
                      Text("Your score is: " + currentscore.toString()),
                      TextField(
                        controller: _namecontroller,
                        decoration:
                            const InputDecoration(hintText: 'Enter name'),
                      ),
                    ],
                  ),
                  actions: [
                    MaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                        submitscore();
                        newGame();
                      },
                      child: Text("Submit"),
                      color: Colors.pink,
                    )
                  ],
                );
              });
        }
      });
    });
  }

  Future newGame() async {
    highscore_docid = [];
    await getDocid();
    setState(() {
      snakePosition = [0, 1, 2];
      foodposition = 55;
      currentDirection = snake_Direction.RIGHT;
      gameHasstarted = false;
      currentscore = 0;
    });
  }

  void submitscore() {
    var database = FirebaseFirestore.instance;
    database.collection('highscores').add({
      "name": _namecontroller.text,
      "score": currentscore,
    });
  }

  void claimFood() {
    currentscore++;
    while (snakePosition.contains(foodposition)) {
      foodposition = Random().nextInt(totalNumberofSqures);
    }
  }

  void moveSnake() {
    switch (currentDirection) {
      case snake_Direction.RIGHT:
        {
          if (snakePosition.last % rowSize == 9) {
            snakePosition.add(snakePosition.last + 1 - rowSize);
          } else {
            snakePosition.add(snakePosition.last + 1);
          }
        }
        break;
      case snake_Direction.LEFT:
        {
          if (snakePosition.last % rowSize == 0) {
            snakePosition.add(snakePosition.last - 1 + rowSize);
          } else {
            snakePosition.add(snakePosition.last - 1);
          }
        }

        break;
      case snake_Direction.UP:
        {
          if (snakePosition.last < rowSize) {
            snakePosition
                .add(snakePosition.last - rowSize + totalNumberofSqures);
          } else {
            snakePosition.add(snakePosition.last - rowSize);
          }
        }

        break;
      case snake_Direction.DOWN:
        {
          if (snakePosition.last + rowSize > totalNumberofSqures) {
            snakePosition
                .add(snakePosition.last + rowSize - totalNumberofSqures);
          } else {
            snakePosition.add(snakePosition.last + rowSize);
          }
        }

        break;
      default:
    }
    if (snakePosition.last == foodposition) {
      claimFood();
    } else {
      snakePosition.removeAt(0);
    }
  }

  bool gameOver() {
    List<int> bodySnake = snakePosition.sublist(0, snakePosition.length - 1);

    if (bodySnake.contains(snakePosition.last)) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    //getting the screen width
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: RawKeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKey: (event) {
          if (event.isKeyPressed(LogicalKeyboardKey.arrowDown) && currentDirection != snake_Direction.UP) {
            currentDirection = snake_Direction.DOWN;
          } else if (event.isKeyPressed(LogicalKeyboardKey.arrowUp)&& currentDirection != snake_Direction.DOWN) {
            currentDirection = snake_Direction.UP;
          } else if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)&& currentDirection != snake_Direction.RIGHT) {
            currentDirection = snake_Direction.LEFT;
          } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)&& currentDirection != snake_Direction.LEFT) {
            currentDirection = snake_Direction.RIGHT;
          }
        },
        child: SizedBox(
          width: screenWidth > 428 ? 428 : screenWidth,
          child: Column(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                         const Text('Current Score'),
                          Text(
                            currentscore.toString(),
                            style: const TextStyle(fontSize: 36),
                          ),
                        ],
                      ),
                    ),
                    // Text("highscores"),

                    Expanded(
                      child: gameHasstarted
                          ? Container()
                          : FutureBuilder(
                              future: letsgetdocid,
                              builder: ((context, snapshot) {
                                return ListView.builder(
                                  itemCount: highscore_docid.length,
                                  itemBuilder: ((context, index) {
                                    return HighScoreTile(
                                        documentId: highscore_docid[index]);
                                  }),
                                );
                              }),
                            ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: GestureDetector(
                  onVerticalDragUpdate: (details) {
                    if (details.delta.dy > 0 &&
                        currentDirection != snake_Direction.UP) {
                      currentDirection = snake_Direction.DOWN;
                    } else if (details.delta.dy < 0 &&
                        currentDirection != snake_Direction.DOWN) {
                      currentDirection = snake_Direction.UP;
                    }
                  },
                  onHorizontalDragUpdate: (details) {
                    if (details.delta.dx > 0 &&
                        currentDirection != snake_Direction.LEFT) {
                      currentDirection = snake_Direction.RIGHT;
                    } else if (details.delta.dx < 0 &&
                        currentDirection != snake_Direction.RIGHT) {
                      currentDirection = snake_Direction.LEFT;
                    }
                  },
                  child: GridView.builder(
                      itemCount: totalNumberofSqures,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: rowSize),
                      itemBuilder: (context, index) {
                        if (snakePosition.contains(index)) {
                          return const SnakePixel();
                        } else if (foodposition == index) {
                          return const FoodPixel();
                        } else {
                          return const BlankPixel();
                        }
                      }),
                ),
              ),
              Expanded(
                child: Container(
                  child: Center(
                    child: MaterialButton(
                      child: Text("PLAY"),
                      color: gameHasstarted ? Colors.grey : Colors.pink,
                      onPressed: gameHasstarted ? () {} : startgame,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
