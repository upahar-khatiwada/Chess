import 'package:chess/helper_methods/piece_in_board.dart';
import 'package:chess/helper_methods/chess_piece_class.dart';

List<List<int>> validMovesCalculator(
  int row,
  int col,
  ChessPiece? selectedPiece,
  List<List<ChessPiece?>> board,
  bool isShortCastlePossibleForWhite,
  bool isLongCastlePossibleForWhite,
  bool isShortCastlePossibleForBlack,
  bool isLongCastlePossibleForBlack,
) {
  int direction = selectedPiece!.isWhite ? -1 : 1;
  List<List<int>> pieceMoves = <List<int>>[];

  switch (selectedPiece.pieceName) {
    case 'pawn':
      // forward 1
      if (isInBoard(row + direction, col) &&
          board[row + direction][col] == null) {
        pieceMoves.add(<int>[row + direction, col]);
      }

      // 2 squares forward
      if ((row == 1 && !selectedPiece.isWhite) ||
          (row == 6 && selectedPiece.isWhite)) {
        if (isInBoard(row + 2 * direction, col) &&
            board[row + direction][col] == null &&
            board[row + 2 * direction][col] == null) {
          pieceMoves.add(<int>[row + 2 * direction, col]);
        }
      }

      // variable to store current piece's color to fix the bug
      // where a same color pawn could diagonally capture other same color pawn
      bool isWhite = board[row][col]!.isWhite;

      // diagonal capture for col + 1
      if (isInBoard(row + direction, col + 1) &&
          board[row + direction][col + 1] != null &&
          board[row + direction][col + 1]!.isWhite != isWhite) {
        pieceMoves.add(<int>[row + direction, col + 1]);
      }

      // diagonal capture for col - 1
      if (isInBoard(row + direction, col - 1) &&
          board[row + direction][col - 1] != null &&
          board[row + direction][col - 1]!.isWhite != isWhite) {
        pieceMoves.add(<int>[row + direction, col - 1]);
      }

      break;

    case 'bishop':
      List<List<int>> directions = <List<int>>[
        <int>[-1, -1], // up and left
        <int>[-1, 1], // up and right
        <int>[1, -1], // down and left
        <int>[1, 1], // down and right
      ];

      for (List<int> dir in directions) {
        int r = row + dir[0];
        int c = col + dir[1];

        while (isInBoard(r, c)) {
          if (board[r][c] == null) {
            pieceMoves.add(<int>[r, c]);
          } else {
            if (board[r][c]!.isWhite != selectedPiece.isWhite) {
              pieceMoves.add(<int>[
                r,
                c,
              ]); // adding the opponent's piece's coordinates
            }
            break; // bishop cant move further the enemy's piece
          }
          r += dir[0]; // checking for each direction again and again
          c += dir[1];
        }
      }
      break;

    case 'rook':
      List<List<int>> directions = <List<int>>[
        <int>[1, 0], // down
        <int>[-1, 0], // up
        <int>[0, 1], // right
        <int>[0, -1], // left
      ];

      for (List<int> dir in directions) {
        int r = row + dir[0];
        int c = col + dir[1];

        while (isInBoard(r, c)) {
          if (board[r][c] == null) {
            pieceMoves.add(<int>[r, c]);
          } else {
            if (board[r][c]!.isWhite != selectedPiece.isWhite) {
              pieceMoves.add(<int>[
                r,
                c,
              ]); // adding the opponent's piece's coordinates
            }
            break; // rook cant move further the enemy's piece
          }
          r += dir[0]; // checking for each direction again and again
          c += dir[1];
        }
      }
      break;

    case 'knight':
      List<List<int>> directions = <List<int>>[
        <int>[2, -1], // down and left
        <int>[2, 1], // down and right
        <int>[-2, 1], // up and right
        <int>[-2, -1], // up and left
        <int>[1, 2], // down and right
        <int>[-1, 2], // up and right
        <int>[1, -2], // down and left
        <int>[-1, -2], // down and left
      ];

      // no while loop here as knight doesnt move continuously
      for (List<int> dir in directions) {
        int r = row + dir[0];
        int c = col + dir[1];

        if (isInBoard(r, c)) {
          if (board[r][c] == null) {
            pieceMoves.add(<int>[r, c]);
          } else {
            if (board[r][c]!.isWhite != selectedPiece.isWhite) {
              pieceMoves.add(<int>[r, c]);
            }
          }
        }
      }
      break;

    case 'queen':
      // copying directions of all pieces except knight for queen
      List<List<int>> directions = <List<int>>[
        <int>[-1, -1], // up and left
        <int>[-1, 1], // up and right
        <int>[1, -1], // down and left
        <int>[1, 1], // down and right
        <int>[1, 0], // down
        <int>[-1, 0], // up
        <int>[0, 1], // right
        <int>[0, -1], // left
      ];

      for (List<int> dir in directions) {
        int r = row + dir[0];
        int c = col + dir[1];

        while (isInBoard(r, c)) {
          if (board[r][c] == null) {
            pieceMoves.add(<int>[r, c]);
          } else {
            if (board[r][c]!.isWhite != selectedPiece.isWhite) {
              pieceMoves.add(<int>[
                r,
                c,
              ]); // adding the opponent's piece's coordinates
            }
            break; // queen cant move further the enemy's piece
          }
          r += dir[0]; // checking for each direction again and again
          c += dir[1];
        }
      }
      break;

    case 'king':
      List<List<int>> directions = <List<int>>[
        <int>[1, 0],
        <int>[0, 1],
        <int>[-1, 0],
        <int>[0, -1],
        <int>[1, 1],
        <int>[1, -1],
        <int>[-1, 1],
        <int>[-1, -1],
      ];

      for (List<int> dir in directions) {
        int r = row + dir[0];
        int c = col + dir[1];

        if (isInBoard(r, c)) {
          if (board[r][c] == null) {
            pieceMoves.add(<int>[r, c]);
          } else {
            if (board[r][c]!.isWhite != selectedPiece.isWhite) {
              pieceMoves.add(<int>[r, c]);
            }
          }
        }

        // for white short castle
        if (isInBoard(r, c) &&
            board[7][5] == null &&
            board[7][6] == null &&
            isShortCastlePossibleForWhite &&
            selectedPiece.isWhite) {
          pieceMoves.add(<int>[7, 6]);
          pieceMoves.add(<int>[7, 5]);
        } // for white long castle
        else if (isInBoard(r, c) &&
            board[7][1] == null &&
            board[7][2] == null &&
            board[7][3] == null &&
            isLongCastlePossibleForWhite &&
            selectedPiece.isWhite) {
          pieceMoves.add(<int>[7, 2]);
          pieceMoves.add(<int>[7, 3]);
        } // for black long castle
        else if (isInBoard(r, c) &&
            board[0][1] == null &&
            board[0][2] == null &&
            board[0][3] == null &&
            isLongCastlePossibleForBlack &&
            !selectedPiece.isWhite) {
          pieceMoves.add(<int>[0, 2]);
          pieceMoves.add(<int>[0, 3]);
        } // for black short castle
        else if (isInBoard(r, c) &&
            board[0][5] == null &&
            board[0][6] == null &&
            isShortCastlePossibleForBlack &&
            !selectedPiece.isWhite) {
          pieceMoves.add(<int>[0, 6]);
          pieceMoves.add(<int>[0, 5]);
        }
      }
      break;
  }
  return pieceMoves;
}
