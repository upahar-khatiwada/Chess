import 'package:chess/components/chess_board.dart';
import 'package:chess/constants/project_constants.dart';
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
  List<List<ChessPiece?>> board = <List<ChessPiece?>>[];

  // holds the current selected piece
  ChessPiece? selectedPiece;

  // default row and columns if piece not selected
  int sRow = -1;
  int sCol = -1;

  @override
  void initState() {
    super.initState();
    board = initializeBoard(board);
  }

  void selectChessPiece(int row, int col) {
    setState(() {
      // puts the current selected piece in the [selectedPiece] object declared above
      if (board[row][col] != null) {
        selectedPiece = board[row][col];
        sRow = row;
        sCol = col;
      } else {
        // if some null square tapped, resets the color of the square
        sRow = sCol = -1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: bgColor,
        body: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            width: double.maxFinite,
            child: AspectRatio(
              aspectRatio: 1,
              child: GridView.builder(
                itemCount: 64,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                ),
                itemBuilder: (BuildContext context, int index) {
                  int row = index ~/ 8;
                  int col = index % 8;
                  ChessPiece? piece = board[row][col];
                  return ChessBoard(
                    index: index,
                    piece: piece,
                    isPieceSelected: sRow == row && sCol == col,
                    onTap: () {
                      return selectChessPiece(row, col);
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
