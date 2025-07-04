import 'package:chess/helper_methods/piece_in_board.dart';
import 'package:chess/helper_methods/chess_piece_class.dart';

List<List<int>> validMovesCalculator(
  int row,
  int col,
  ChessPiece? selectedPiece,
  List<List<ChessPiece?>> board,
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

      // diagonal capture for col + 1
      if (isInBoard(row + direction, col + 1) &&
          board[row + direction][col + 1] != null) {
        pieceMoves.add(<int>[row + direction, col + 1]);
      }

      // diagonal capture for col - 1
      if (isInBoard(row + direction, col - 1) &&
          board[row + direction][col - 1] != null) {
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
              pieceMoves.add(<int>[r, c]); // adding the opponent's piece's coordinates
            }
            break; // bishop cant move further the enemy's piece
          }
          r += dir[0]; // checking for each direction again and again
          c += dir[1];
        }
      }
      break;
  }
  return pieceMoves;
}
