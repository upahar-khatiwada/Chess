import 'package:chess/components/chess_board.dart';
import 'package:chess/helper_methods/board_initializer.dart';
import 'package:chess/helper_methods/chess_piece_class.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ChessGame());
}

class ChessGame extends StatefulWidget {
  const ChessGame({super.key});

  @override
  State<ChessGame> createState() => _ChessGameState();
}

class _ChessGameState extends State<ChessGame> {
  List<List<ChessPiece?>> board = [];

  @override
  void initState() {
    super.initState();
    board = initializeBoard(board);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey[400],
        body: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            width: double.maxFinite,
            child: AspectRatio(
              aspectRatio: 1,
              child: GridView.builder(
                itemCount: 64,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                ),
                itemBuilder: (BuildContext context, int index) {
                  ChessPiece? piece = board[index ~/ 8][index % 8];
                  return ChessBoard(index: index, piece: piece);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
