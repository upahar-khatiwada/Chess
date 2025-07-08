import 'package:chess/components/chess_board.dart';
import 'package:chess/constants/project_constants.dart';
import 'package:chess/helper_methods/board_initializer.dart';
import 'package:chess/helper_methods/chess_piece_class.dart';
import 'package:chess/helper_methods/show_dialog.dart';
import 'package:chess/helper_methods/valid_moves_calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const ChessGame());
}

class ChessGame extends StatefulWidget {
  const ChessGame({super.key});

  @override
  State<ChessGame> createState() => _ChessGameState();
}

class _ChessGameState extends State<ChessGame> {
  // boolean to check if check mate occured
  bool isGameOver = false;

  // variable to store the board
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
  bool isWhiteKingChecked = false;
  bool isBlackKingChecked = false;

  void selectChessPiece(int row, int col) {
    if (isGameOver) return;
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
          else if (selectedPiece != null &&
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
          else if (selectedPiece != null &&
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
          }
          //  else if (selectedPiece != null &&
          //     selectedPiece!.pieceName == 'pawn' &&
          //     selectedPiece!.isWhite &&
          //     sRow == 1 &&
          //     row == 0) {
          // }
          else {
            board[row][col] = selectedPiece;
            board[sRow][sCol] = null;

            if (selectedPiece != null && selectedPiece!.pieceName == 'king') {
              if (selectedPiece!.isWhite) {
                whiteKingPos = <int>[row, col];
              } else {
                blackKingPos = <int>[row, col];
              }
            }

            isWhiteKingChecked = kingInCheck(true, whiteKingPos);
            isBlackKingChecked = kingInCheck(false, blackKingPos);
          }

          selectedPiece = null;
          sRow = sCol = -1;
          validMoves.clear();

          // switch turn
          isWhiteTurn = !isWhiteTurn;

          if (checkMate(isWhiteTurn)) {
            setState(() {
              isGameOver = true;
            });

            // Delay dialog until after the current frame
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final BuildContext? ctx = navigatorKey.currentState?.context;
              // print('Navigator context: $ctx');
              if (ctx != null) {
                showDialog<void>(
                  context: ctx,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Game Over!'),
                      content: Text(
                        isWhiteTurn ? 'Black Wins!' : 'White Wins!',
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            SystemNavigator.pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                          ),
                          child: const Text('Exit!'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            resetGame();
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent,
                          ),
                          child: const Text('Play Again'),
                        ),
                      ],
                    );
                  },
                );
              } else {
                print('Context not available');
              }
            });
          }

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

  bool kingInCheck(bool whiteTurn, List<int> kingPos) {
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (board[i][j] != null && board[i][j]!.isWhite != whiteTurn) {
          List<List<int>> enemyMoves = validMovesCalculator(
            i,
            j,
            board[i][j],
            board,
            isShortCastlePossibleForWhite,
            isLongCastlePossibleForWhite,
            isShortCastlePossibleForBlack,
            isLongCastlePossibleForBlack,
          );

          // for (List<int> move in enemyMoves) {
          //   if (move[0] == kingPos[0] && move[1] == kingPos[1]) {
          //     return true;
          //   }
          // }

          if (enemyMoves.any(
            (List<int> move) => move[0] == kingPos[0] && move[1] == kingPos[1],
          )) {
            return true;
          }
        }
      }
    }
    return false;
  }

  List<List<int>> filterLegalMoves(
    List<List<int>> rawMovess,
    int row,
    int col,
    ChessPiece? selectedPiece,
    bool whiteTurn,
  ) {
    List<List<int>> legalMoves = <List<int>>[];

    for (List<int> move in rawMovess) {
      int endRow = move[0];
      int endCol = move[1];

      // saving current board state
      ChessPiece? capturedPiece = board[endRow][endCol];
      ChessPiece? pieceToMove = selectedPiece;

      // simulating the move
      board[endRow][endCol] = pieceToMove;
      board[row][col] = null;

      // saving current king's position
      List<int> originalKingPos = whiteTurn ? whiteKingPos : blackKingPos;
      bool movedKing = pieceToMove?.pieceName == 'king';

      if (movedKing) {
        if (whiteTurn) {
          whiteKingPos = <int>[endRow, endCol];
        } else {
          blackKingPos = <int>[endRow, endCol];
        }
      }

      // checking if king is in check after the move
      bool isStillInCheck = kingInCheck(
        whiteTurn,
        whiteTurn ? whiteKingPos : blackKingPos,
      );

      // if move is safe add it to the list
      if (!isStillInCheck) {
        legalMoves.add(<int>[endRow, endCol]);
      }

      // restore board and king position
      board[row][col] = pieceToMove;
      board[endRow][endCol] = capturedPiece;

      if (movedKing) {
        if (whiteTurn) {
          whiteKingPos = originalKingPos;
        } else {
          blackKingPos = originalKingPos;
        }
      }
    }

    return legalMoves;
  }

  bool checkMate(bool isWhiteTurn) {
    // print('checking checkmate for ${isWhiteTurn ? 'white' : 'black'}');
    // king not in check so false
    if (!kingInCheck(isWhiteTurn, isWhiteTurn ? whiteKingPos : blackKingPos)) {
      return false;
    }

    // at least one legal move
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        ChessPiece? currentPiece = board[i][j];

        if (currentPiece != null && currentPiece.isWhite == isWhiteTurn) {
          List<List<int>> rawMoves = validMovesCalculator(
            i,
            j,
            currentPiece,
            board,
            isShortCastlePossibleForWhite,
            isLongCastlePossibleForWhite,
            isShortCastlePossibleForBlack,
            isLongCastlePossibleForBlack,
          );

          List<List<int>> legalMoves = filterLegalMoves(
            rawMoves,
            i,
            j,
            currentPiece,
            isWhiteTurn,
          );

          if (legalMoves.isNotEmpty) {
            print('Legal moves exist for ${currentPiece.pieceName} at ($i,$j)');
            return false; // at least one legal move exists
          }
        }
      }
    }

    // no legal moves
    print('CHECKMATE CONFIRMED FOR ${isWhiteTurn ? 'WHITE' : 'BLACK'}');
    return true;
  }

  void resetGame() {
    setState(() {
      board = initializeBoard(board);
      sRow = -1;
      sCol = -1;
      validMoves = <List<int>>[];
      isWhiteTurn = true;
      isShortCastlePossibleForWhite = true;
      isLongCastlePossibleForWhite = true;
      isShortCastlePossibleForBlack = true;
      isLongCastlePossibleForBlack = true;
      whiteKingPos = <int>[7, 4];
      blackKingPos = <int>[0, 4];
      isWhiteKingChecked = false;
      isBlackKingChecked = false;
      isGameOver = false;
    });
  }

  @override
  void initState() {
    super.initState();
    board = initializeBoard(board);

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (checkMate(isWhiteTurn)) {
    //     setState(() {
    //       isGameOver = true;
    //     });
    //     print('mate from init state');
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
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
