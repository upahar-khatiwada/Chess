import 'package:chess/components/chess_board.dart';
import 'package:chess/constants/project_constants.dart';
import 'package:chess/helper_methods/board_initializer.dart';
import 'package:chess/helper_methods/chess_piece_class.dart';
import 'package:chess/helper_methods/elevated_buttons.dart';
import 'package:chess/helper_methods/valid_moves_calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

List<ChessPiece?> capturedWhitePiece = <ChessPiece?>[];
List<ChessPiece?> capturedBlackPiece = <ChessPiece?>[];
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

  // for En Passant
  List<int>? enPassantSquare;

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
            // actually moving the king
            if (board[row][col] != null) {
              if (board[row][col]!.isWhite) {
                capturedWhitePiece.add(board[row][col]);
              } else {
                capturedBlackPiece.add(board[row][col]);
              }
            }
            board[row][col] = selectedPiece;
            board[sRow][sCol] = null;

            whiteKingPos = <int>[row, col];

            isShortCastlePossibleForWhite = isLongCastlePossibleForWhite =
                false;
          } // for checking if white right rook moved
          else if (selectedPiece != null &&
              selectedPiece!.isWhite &&
              selectedPiece!.pieceName == 'rook' &&
              sRow == 7 &&
              sCol == 7 &&
              (row != 7 || col != 7)) {
            if (board[row][col] != null) {
              if (board[row][col]!.isWhite) {
                capturedWhitePiece.add(board[row][col]);
              } else {
                capturedBlackPiece.add(board[row][col]);
              }
            }
            board[row][col] = selectedPiece;
            board[sRow][sCol] = null;

            isShortCastlePossibleForWhite = false;
          } // for checking if white left rook moved
          else if (selectedPiece != null &&
              selectedPiece!.isWhite &&
              selectedPiece!.pieceName == 'rook' &&
              sRow == 7 &&
              sCol == 0 &&
              (row != 7 || col != 0)) {
            if (board[row][col] != null) {
              if (board[row][col]!.isWhite) {
                capturedWhitePiece.add(board[row][col]);
              } else {
                capturedBlackPiece.add(board[row][col]);
              }
            }
            board[row][col] = selectedPiece;
            board[sRow][sCol] = null;

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
            if (board[row][col] != null) {
              if (board[row][col]!.isWhite) {
                capturedWhitePiece.add(board[row][col]);
              } else {
                capturedBlackPiece.add(board[row][col]);
              }
            }
            board[row][col] = selectedPiece;
            board[sRow][sCol] = null;

            blackKingPos = <int>[row, col];
            isShortCastlePossibleForBlack = isLongCastlePossibleForBlack =
                false;
          } // for checking if black left rook moved
          else if (selectedPiece != null &&
              !selectedPiece!.isWhite &&
              selectedPiece!.pieceName == 'rook' &&
              sRow == 0 &&
              sCol == 0 &&
              (row != 0 || col != 0)) {
            if (board[row][col] != null) {
              if (board[row][col]!.isWhite) {
                capturedWhitePiece.add(board[row][col]);
              } else {
                capturedBlackPiece.add(board[row][col]);
              }
            }
            board[row][col] = selectedPiece;
            board[sRow][sCol] = null;

            isLongCastlePossibleForBlack = false;
          } // for checking if black right rook moved
          else if (selectedPiece != null &&
              !selectedPiece!.isWhite &&
              selectedPiece!.pieceName == 'rook' &&
              sRow == 0 &&
              sCol == 7 &&
              (row != 0 || col != 7)) {
            if (board[row][col] != null) {
              if (board[row][col]!.isWhite) {
                capturedWhitePiece.add(board[row][col]);
              } else {
                capturedBlackPiece.add(board[row][col]);
              }
            }
            board[row][col] = selectedPiece;
            board[sRow][sCol] = null;

            isShortCastlePossibleForBlack = false;
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
          } else if (selectedPiece != null &&
              selectedPiece!.pieceName == 'pawn' &&
              ((sRow == 1 && row == 0) || (sRow == 6 && row == 7))) {
            final int promoRow = sRow;
            final int promoCol = sCol;

            // pawn promotion block
            if (selectedPiece!.isWhite) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                final BuildContext? ctx = navigatorKey.currentState?.context;
                if (ctx != null) {
                  showDialog<void>(
                    context: ctx,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Pick a piece for promotion!'),
                        actionsAlignment: MainAxisAlignment.spaceEvenly,
                        actions: <Widget>[
                          // button for rook
                          MyElevatedButton(
                            onPressed: () {
                              setState(() {
                                board[promoRow][promoCol] = null;
                                board[row][col] = ChessPiece(
                                  pieceName: 'rook',
                                  isWhite: true,
                                  imagePath: 'assets/white/rook.png',
                                );
                                selectedPiece = null;
                                sRow = sCol = -1;
                                validMoves.clear();
                                isWhiteTurn = !isWhiteTurn;
                              });
                              Navigator.of(context).pop();
                            },
                            pieceName: 'Rook',
                          ),
                          // button for queen
                          MyElevatedButton(
                            onPressed: () {
                              setState(() {
                                board[promoRow][promoCol] = null;
                                board[row][col] = ChessPiece(
                                  pieceName: 'queen',
                                  isWhite: true,
                                  imagePath: 'assets/white/queen.png',
                                );
                                selectedPiece = null;
                                sRow = sCol = -1;
                                validMoves.clear();
                                isWhiteTurn = !isWhiteTurn;
                              });
                              Navigator.of(context).pop();
                            },
                            pieceName: 'Queen',
                          ),
                          // button for knight
                          MyElevatedButton(
                            onPressed: () {
                              setState(() {
                                board[promoRow][promoCol] = null;
                                board[row][col] = ChessPiece(
                                  pieceName: 'knight',
                                  isWhite: true,
                                  imagePath: 'assets/white/knight.png',
                                );
                                selectedPiece = null;
                                sRow = sCol = -1;
                                validMoves.clear();
                                isWhiteTurn = !isWhiteTurn;
                              });
                              Navigator.of(context).pop();
                            },
                            pieceName: 'Knight',
                          ),
                          // button for bishop
                          MyElevatedButton(
                            onPressed: () {
                              setState(() {
                                board[promoRow][promoCol] = null;
                                board[row][col] = ChessPiece(
                                  pieceName: 'bishop',
                                  isWhite: true,
                                  imagePath: 'assets/white/bishop.png',
                                );
                                selectedPiece = null;
                                sRow = sCol = -1;
                                validMoves.clear();
                                isWhiteTurn = !isWhiteTurn;
                              });
                              Navigator.of(context).pop();
                            },
                            pieceName: 'Bishop',
                          ),
                        ],
                      );
                    },
                  );
                }
              });
            } else if (!selectedPiece!.isWhite) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                final BuildContext? ctx = navigatorKey.currentState?.context;
                if (ctx != null) {
                  showDialog<void>(
                    context: ctx,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Pick a piece for promotion!'),
                        actionsAlignment: MainAxisAlignment.spaceEvenly,
                        actions: <Widget>[
                          // button for rook
                          MyElevatedButton(
                            onPressed: () {
                              setState(() {
                                board[promoRow][promoCol] = null;
                                board[row][col] = ChessPiece(
                                  pieceName: 'rook',
                                  isWhite: false,
                                  imagePath: 'assets/black/rook.png',
                                );

                                selectedPiece = null;
                                sRow = sCol = -1;
                                validMoves.clear();
                                isWhiteTurn = !isWhiteTurn;
                              });
                              Navigator.of(context).pop();
                            },
                            pieceName: 'Rook',
                          ),
                          // button for queen
                          MyElevatedButton(
                            onPressed: () {
                              setState(() {
                                board[promoRow][promoCol] = null;
                                board[row][col] = ChessPiece(
                                  pieceName: 'queen',
                                  isWhite: false,
                                  imagePath: 'assets/black/queen.png',
                                );

                                selectedPiece = null;
                                sRow = sCol = -1;
                                validMoves.clear();
                                isWhiteTurn = !isWhiteTurn;
                              });
                              Navigator.of(context).pop();
                            },
                            pieceName: 'Queen',
                          ),
                          // button for knight
                          MyElevatedButton(
                            onPressed: () {
                              setState(() {
                                board[promoRow][promoCol] = null;
                                board[row][col] = ChessPiece(
                                  pieceName: 'knight',
                                  isWhite: false,
                                  imagePath: 'assets/black/knight.png',
                                );

                                selectedPiece = null;
                                sRow = sCol = -1;
                                validMoves.clear();
                                isWhiteTurn = !isWhiteTurn;
                              });
                              Navigator.of(context).pop();
                            },
                            pieceName: 'Knight',
                          ),
                          // button for bishop
                          MyElevatedButton(
                            onPressed: () {
                              setState(() {
                                board[promoRow][promoCol] = null;
                                board[row][col] = ChessPiece(
                                  pieceName: 'bishop',
                                  isWhite: false,
                                  imagePath: 'assets/black/bishop.png',
                                );

                                selectedPiece = null;
                                sRow = sCol = -1;
                                validMoves.clear();
                                isWhiteTurn = !isWhiteTurn;
                              });
                              Navigator.of(context).pop();
                            },
                            pieceName: 'Bishop',
                          ),
                        ],
                      );
                    },
                  );
                }
              });
            }

            return;
          } // handling En Passant Logic
          else if (selectedPiece!.pieceName == 'pawn' &&
              enPassantSquare != null &&
              row == enPassantSquare![0] &&
              col == enPassantSquare![1] &&
              board[row][col] == null) {
            // if white killed black pawn by en passant,
            // captured black pawn is at row - 1
            int capturedRow = selectedPiece!.isWhite ? row + 1 : row - 1;
            print('Captured row: $capturedRow');
            ChessPiece? capturedPawn = board[capturedRow][col];

            board[capturedRow][col] = null;

            board[row][col] = selectedPiece;
            board[sRow][sCol] = null;

            if (capturedPawn != null) {
              if (capturedPawn.isWhite) {
                capturedWhitePiece.add(capturedPawn);
              } else {
                capturedBlackPiece.add(capturedPawn);
              }
            }
          } else {
            // piece moving block
            print('in the else block!');
            if (board[row][col] != null) {
              if (board[row][col]!.isWhite) {
                capturedWhitePiece.add(board[row][col]);
              } else {
                capturedBlackPiece.add(board[row][col]);
              }
            }
            board[row][col] = selectedPiece;
            board[sRow][sCol] = null;

            // absolute difference of sRow and row should always be 2 as it moves
            // 2 squares forward at this condition only
            if (selectedPiece!.pieceName == 'pawn' && (sRow - row).abs() == 2) {
              enPassantSquare = <int>[
                (sRow + row) ~/ 2,
                col,
              ]; // adding the row between sRow and row
            } else {
              enPassantSquare = null;
            }

            if (selectedPiece!.pieceName == 'king') {
              if (selectedPiece!.isWhite) {
                whiteKingPos = <int>[row, col];
              } else {
                blackKingPos = <int>[row, col];
              }
            }
            // isWhiteKingChecked = kingInCheck(true, whiteKingPos);
            // isBlackKingChecked = kingInCheck(false, blackKingPos);
          }

          selectedPiece = null;
          sRow = sCol = -1;
          validMoves.clear();

          isWhiteKingChecked = kingInCheck(true, whiteKingPos);
          isBlackKingChecked = kingInCheck(false, blackKingPos);

          // switch turn
          isWhiteTurn = !isWhiteTurn;

          if (checkMate(isWhiteTurn)) {
            setState(() {
              isGameOver = true;
            });

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
          enPassantSquare,
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
    }); // end of setState
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
            enPassantSquare,
            forCheck: true,
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
      ChessPiece? capturedPiece =
          board[endRow][endCol]; // piece to capture if there is any
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
    print('checking checkmate for ${isWhiteTurn ? 'white' : 'black'}');
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
            enPassantSquare,
          );

          List<List<int>> legalMoves = filterLegalMoves(
            rawMoves,
            i,
            j,
            currentPiece,
            isWhiteTurn,
          );

          if (legalMoves.isNotEmpty) {
            print('$legalMoves for ${currentPiece.pieceName}');
            return false; // at least one legal move exists
          }
        }
      }
    }

    // no legal moves
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
      enPassantSquare = null;
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
            Expanded(
              flex: 1,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                ),
                itemCount: capturedWhitePiece.length,
                itemBuilder: (BuildContext context, int index) {
                  return Image.asset(capturedWhitePiece[index]!.imagePath);
                },
              ),
            ),
            Expanded(
              flex: 3,
              child: AspectRatio(
                aspectRatio: 1,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
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
            Expanded(
              flex: 1,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                ),
                itemCount: capturedBlackPiece.length,
                itemBuilder: (BuildContext context, int index) {
                  return Image.asset(capturedBlackPiece[index]!.imagePath);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
