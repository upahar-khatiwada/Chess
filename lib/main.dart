import 'package:chess/components/chess_board.dart';
import 'package:chess/constants/project_constants.dart';
import 'package:chess/helper_methods/board_initializer.dart';
import 'package:chess/helper_methods/chess_piece_class.dart';
import 'package:chess/helper_methods/valid_moves_calculator.dart';
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

  // list to store valid moves
  List<List<int>> validMoves = <List<int>>[];

  // boolean to check whose turn it is
  bool isWhiteTurn = true;

  @override
  void initState() {
    super.initState();
    board = initializeBoard(board);
  }

  void selectChessPiece(int row, int col) {
    setState(() {
      // moves the piece
      for (List<int> validMove in validMoves) {
        if (validMove[0] == row && validMove[1] == col) {
          board[row][col] = selectedPiece;
          board[sRow][sCol] = null;

          selectedPiece = null;
          sRow = sCol = -1;
          validMoves.clear();

          // switch turn
          isWhiteTurn = !isWhiteTurn;
          return;
        }
      }

      if (board[row][col] != null && board[row][col]!.isWhite == isWhiteTurn) {
        selectedPiece = board[row][col];
        sRow = row;
        sCol = col;
        // only calculating valid moves for selected piece (row, col)
        validMoves = validMovesCalculator(row, col, selectedPiece, board);
      } else {
        selectedPiece = null;
        sRow = sCol = -1;
        validMoves.clear();
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
                  bool isMoveValid = false;

                  // highlights the current selected piece's valid move
                  for (List<int> validMove in validMoves) {
                    if (validMove[0] == row && validMove[1] == col) {
                      isMoveValid = true;
                    }
                  }

                  return ChessBoard(
                    index: index,
                    piece: piece,
                    isPieceSelected: sRow == row && sCol == col,
                    onTap: () {
                      return selectChessPiece(row, col);
                    },
                    isMoveValid: isMoveValid,
                    board: board,
                    row: row,
                    col: col,
                    currentlySelectedPiece: selectedPiece,
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
