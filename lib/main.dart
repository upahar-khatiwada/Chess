import 'package:chess/components/chess_board.dart';
import 'package:chess/constants/project_constants.dart';
import 'package:chess/helper_methods/board_initializer.dart';
import 'package:chess/helper_methods/chess_piece_class.dart';
import 'package:chess/helper_methods/valid_moves_calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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

  // boolean to detect castle
  bool isShortCastlePossibleForWhite = true;
  bool isLongCastlePossibleForWhite = true;
  bool isShortCastlePossibleForBlack = true;
  bool isLongCastlePossibleForBlack = true;

  // variables to store king's position to track if its being checked
  List<int> whiteKingPos = <int>[7, 4];
  List<int> blackKingPos = <int>[0, 4];
  bool isKingChecked = false;
  bool isWhiteKingChecked = false;
  bool isBlackKingChecked = false;

  void selectChessPiece(int row, int col) {
    setState(() {
      // moves the piece
      for (List<int> validMove in validMoves) {
        if (validMove[0] == row && validMove[1] == col) {
          if (selectedPiece != null &&
              selectedPiece!.isWhite &&
              selectedPiece!.pieceName == 'king' &&
              sRow == 7 &&
              sCol == 4 &&
              !(row == 7 && (col == 6 || col == 2))) {
            isShortCastlePossibleForWhite = isLongCastlePossibleForWhite =
                false;
          } // for checking if white right rook moved
          else if (selectedPiece != null &&
              !selectedPiece!.isWhite &&
              selectedPiece!.pieceName == 'rook' &&
              sRow == 7 &&
              sCol == 7 &&
              (row != 7 || col != 7)) {
            isShortCastlePossibleForWhite = false;
          } // for checking if white left rook moved
          else if (selectedPiece != null &&
              selectedPiece!.isWhite &&
              selectedPiece!.pieceName == 'rook' &&
              sRow == 7 &&
              sCol == 0 &&
              (row != 7 || col != 0)) {
            isLongCastlePossibleForWhite = false;
          }

          // short white castle
          if (selectedPiece != null &&
              selectedPiece!.isWhite &&
              selectedPiece!.pieceName == 'king' &&
              sRow == 7 &&
              sCol == 4 &&
              row == 7 &&
              col == 6) {
            board[7][6] = selectedPiece;
            board[7][4] = null;
            board[7][5] = board[7][7];
            board[7][7] = null;

            isShortCastlePossibleForWhite = isLongCastlePossibleForWhite =
                false;
          }
          // long castle white
          else if (selectedPiece != null &&
              selectedPiece!.isWhite &&
              selectedPiece!.pieceName == 'king' &&
              sRow == 7 &&
              sCol == 4 &&
              row == 7 &&
              col == 2) {
            board[7][2] = selectedPiece;
            board[7][4] = null;
            board[7][3] = board[7][0];
            board[7][0] = null;

            isShortCastlePossibleForWhite = isLongCastlePossibleForWhite =
                false;
          }
          // black king movement detection for castle possibility
          else if (selectedPiece != null &&
              !selectedPiece!.isWhite &&
              selectedPiece!.pieceName == 'king' &&
              sRow == 0 &&
              sCol == 4 &&
              !(row == 7 && (col == 6 || col == 2))) {
            isShortCastlePossibleForBlack = isLongCastlePossibleForBlack =
                false;
          } // for checking if black left rook moved
          else if (selectedPiece != null &&
              selectedPiece!.isWhite &&
              selectedPiece!.pieceName == 'rook' &&
              sRow == 0 &&
              sCol == 0 &&
              (row != 0 || col != 0)) {
            isShortCastlePossibleForBlack = false;
          } // for checking if black right rook moved
          else if (selectedPiece != null &&
              selectedPiece!.isWhite &&
              selectedPiece!.pieceName == 'rook' &&
              sRow == 0 &&
              sCol == 7 &&
              (row != 0 || col != 7)) {
            isLongCastlePossibleForBlack = false;
          } // short black castle
          if (selectedPiece != null &&
              !selectedPiece!.isWhite &&
              selectedPiece!.pieceName == 'king' &&
              sRow == 0 &&
              sCol == 4 &&
              row == 0 &&
              col == 6) {
            board[0][6] = selectedPiece;
            board[0][4] = null;
            board[0][5] = board[0][7];
            board[0][7] = null;

            isShortCastlePossibleForBlack = isLongCastlePossibleForBlack =
                false;
          }
          // long castle black
          else if (selectedPiece != null &&
              selectedPiece!.pieceName == 'king' &&
              sRow == 0 &&
              sCol == 4 &&
              row == 0 &&
              col == 2) {
            board[0][2] = selectedPiece;
            board[0][4] = null;
            board[0][3] = board[0][0];
            board[0][0] = null;

            isShortCastlePossibleForBlack = isLongCastlePossibleForBlack =
                false;
          } else {
            board[row][col] = selectedPiece;
            board[sRow][sCol] = null;

            if (selectedPiece != null && selectedPiece!.pieceName == 'king') {
              if (selectedPiece!.isWhite) {
                whiteKingPos = <int>[row, col];
              } else {
                blackKingPos = <int>[row, col];
              }
            }

            isWhiteKingChecked = kingInCheck(true);
            isBlackKingChecked = kingInCheck(false);
          }

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
        List<List<int>> rawMoves = validMovesCalculator(
          row,
          col,
          selectedPiece,
          board,
          isShortCastlePossibleForWhite,
          isLongCastlePossibleForWhite,
          isShortCastlePossibleForBlack,
          isLongCastlePossibleForBlack,
        );

        validMoves = filterLegalMoves(
          rawMoves,
          row,
          col,
          selectedPiece,
          isWhiteTurn,
        );
      } else {
        selectedPiece = null;
        sRow = sCol = -1;
        validMoves.clear();
      }
    });
  }

  bool kingInCheck(bool whiteTurn) {
    // getting current king's position
    List<int> currentlyCheckedKingPosition = whiteTurn
        ? whiteKingPos
        : blackKingPos;

    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (board[i][j] != null && board[i][j]!.isWhite == !whiteTurn) {
          // list that stores every enemy pieces ko moves
          List<List<int>> enemeyPieceMoves = validMovesCalculator(
            i,
            j,
            board[i][j],
            board,
            isShortCastlePossibleForWhite,
            isLongCastlePossibleForWhite,
            isShortCastlePossibleForBlack,
            isLongCastlePossibleForBlack,
          );

          if (enemeyPieceMoves.any(
            (List<int> temp) =>
                temp[0] == currentlyCheckedKingPosition[0] &&
                temp[1] == currentlyCheckedKingPosition[1],
          )) {
            return true;
          }
        }
      }
    }
    return false;
  }

  // for real valid moves
  List<List<int>> filterLegalMoves(
    List<List<int>> rawMoves,
    int row,
    int col,
    ChessPiece? selectedPiece,
    bool whiteTurn,
  ) {
    List<List<int>> legalMoves = <List<int>>[];

    for (List<int> move in rawMoves) {
      int endRow = move[0];
      int endCol = move[1];

      // saving destination board's state for restoring later after simulation
      ChessPiece? boardState = board[endRow][endCol];

      // testing the new moves
      board[endRow][endCol] = selectedPiece; // places current selected piece at a position
      board[row][col] = null; // removes it from current position

      // if selected piece is king then store new position else use king's current position
      List<int> originalKingPos =
          (selectedPiece != null && selectedPiece.pieceName == 'king')
          ? <int>[endRow, endCol]
          : (whiteTurn ? whiteKingPos : blackKingPos);

      // updates the king's position if selected piece is king
      if (selectedPiece != null && selectedPiece.pieceName == 'king') {
        if (whiteTurn) {
          whiteKingPos = <int>[endRow, endCol];
        } else {
          blackKingPos = <int>[endRow, endCol];
        }
      }

      // checking if the simulated move puts king in check
      bool isKingInCheck = kingInCheck(whiteTurn);

      // restoring the original board
      board[row][col] = selectedPiece;
      board[endRow][endCol] = boardState;

      // moving king if the selected piece was king back to its original position
      if (selectedPiece != null && selectedPiece.pieceName == 'king') {
        if (whiteTurn) {
          whiteKingPos = originalKingPos;
        } else {
          blackKingPos = originalKingPos;
        }
      }

      if (!isKingInCheck) {
        legalMoves.add(<int>[endRow, endCol]);
      }
    }

    return legalMoves;
  }

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
        backgroundColor: bgColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                width: double.maxFinite,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: GridView.builder(
                    itemCount: 64,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                        onTap: () => selectChessPiece(row, col),

                        isMoveValid: isMoveValid,
                        board: board,
                        row: row,
                        col: col,
                        currentlySelectedPiece: selectedPiece,
                        isLongCastlePossibleForWhite:
                            isLongCastlePossibleForWhite,
                        isShortCastlePossibleForWhite:
                            isShortCastlePossibleForWhite,
                        isLongCastlePossibleForBlack:
                            isLongCastlePossibleForBlack,
                        isShortCastlePossibleForBlack:
                            isShortCastlePossibleForBlack,
                        isBlackKingChecked: isBlackKingChecked,
                        isWhiteKingChecked: isWhiteKingChecked,
                        whiteKingPosition: whiteKingPos,
                        blackKingPosition: blackKingPos,
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
