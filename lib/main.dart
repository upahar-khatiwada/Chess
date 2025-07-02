import 'package:chess/components/chess_board.dart';
import 'package:chess/helper_methods/square_selector.dart';
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

  void initializeBoard() {
    board = List.generate(
      8,
      (int index) => List.generate(8, (int index) => null),
    );

    for (int i = 0; i < 8; i++) {
      board[6][i] = ChessPiece(
        pieceName: 'pawn',
        isWhite: true,
        imagePath: 'assets/white/pawn.png',
      );

      board[1][i] = ChessPiece(
        pieceName: 'pawn',
        isWhite: false,
        imagePath: 'assets/black/pawn.png',
      );
    }

    board[0][0] = board[0][7] = ChessPiece(
      pieceName: 'rook',
      isWhite: false,
      imagePath: 'assets/black/rook.png',
    );

    board[7][0] = board[7][7] = ChessPiece(
      pieceName: 'rook',
      isWhite: true,
      imagePath: 'assets/white/rook.png',
    );

    board[0][1] = board[0][6] = ChessPiece(
      pieceName: 'knight',
      isWhite: false,
      imagePath: 'assets/black/knight.png',
    );

    board[7][1] = board[7][6] = ChessPiece(
      pieceName: 'knight',
      isWhite: true,
      imagePath: 'assets/white/knight.png',
    );

    board[0][2] = board[0][5] = ChessPiece(
      pieceName: 'bishop',
      isWhite: false,
      imagePath: 'assets/black/bishop.png',
    );

    board[7][2] = board[7][5] = ChessPiece(
      pieceName: 'bishop',
      isWhite: true,
      imagePath: 'assets/white/bishop.png',
    );

    board[0][3] = ChessPiece(
      pieceName: 'queen',
      isWhite: false,
      imagePath: 'assets/black/queen.png',
    );

    board[7][3] = ChessPiece(
      pieceName: 'queen',
      isWhite: true,
      imagePath: 'assets/white/queen.png',
    );

    board[0][4] = ChessPiece(
      pieceName: 'king',
      isWhite: false,
      imagePath: 'assets/black/king.png',
    );

    board[7][4] = ChessPiece(
      pieceName: 'king',
      isWhite: true,
      imagePath: 'assets/white/king.png',
    );
  }

  @override
  void initState() {
    super.initState();
    initializeBoard();
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
