import 'package:chess/constants/project_constants.dart';
import 'package:chess/helper_methods/chess_piece_class.dart';
import 'package:flutter/material.dart';

class ChessBoard extends StatelessWidget {
  final int index;
  final ChessPiece? piece;
  final bool isPieceSelected;
  final VoidCallback onTap;
  final bool isMoveValid;
  final List<List<ChessPiece?>> board;
  final int row;
  final int col;
  final ChessPiece? currentlySelectedPiece;
  final bool isShortCastlePossibleForWhite;
  final bool isLongCastlePossibleForWhite;
  final bool isShortCastlePossibleForBlack;
  final bool isLongCastlePossibleForBlack;
  final bool isWhiteKingChecked;
  final bool isBlackKingChecked;
  final List<int> whiteKingPosition;
  final List<int> blackKingPosition;

  ChessBoard({
    super.key,
    required this.index,
    required this.piece,
    required this.isPieceSelected,
    required this.onTap,
    required this.isMoveValid,
    required this.board,
    required this.row,
    required this.col,
    required this.currentlySelectedPiece,
    required this.isShortCastlePossibleForWhite,
    required this.isLongCastlePossibleForWhite,
    required this.isShortCastlePossibleForBlack,
    required this.isLongCastlePossibleForBlack,
    required this.isWhiteKingChecked,
    required this.isBlackKingChecked,
    required this.whiteKingPosition,
    required this.blackKingPosition,
  });

  @override
  Widget build(BuildContext context) {
    Color? squareColor;
    ChessPiece? enemyPiece = board[row][col];
    if (isPieceSelected) {
      squareColor = pieceSelectedColor;
    } else if (isMoveValid) {
      if (enemyPiece != null &&
          currentlySelectedPiece != null &&
          enemyPiece.isWhite != currentlySelectedPiece!.isWhite) {
        squareColor = Colors.red;
      } else {
        squareColor = possibleMovesColor;
      }
    } else if ((isWhiteKingChecked &&
            piece != null &&
            piece!.pieceName == 'king' &&
            piece!.isWhite &&
            row == whiteKingPosition[0] &&
            col == whiteKingPosition[1]) ||
        (isBlackKingChecked &&
            piece != null &&
            piece!.pieceName == 'king' &&
            !piece!.isWhite &&
            row == blackKingPosition[0] &&
            col == blackKingPosition[1])) {
      squareColor = Colors.redAccent;
    } else {
      squareColor = (index % 8 + (index / 8).toInt()) % 2 == 0
          ? whiteSquare
          : blackSquare;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: squareColor,
          border: Border.all(color: getBorderColor(), width: getBorderWidth()),
        ),
        // if tapped on a piece, color green else default color
        child: piece != null ? Image.asset(piece!.imagePath) : null,
      ),
    );
  }

  Color getBorderColor() {
    if (isPieceSelected) {
      return Colors.black45;
    } else if (isMoveValid) {
      ChessPiece? targetPiece = board[row][col];
      if (targetPiece != null &&
          currentlySelectedPiece != null &&
          targetPiece.isWhite != currentlySelectedPiece!.isWhite) {
        return Colors.red;
      } else {
        return Colors.black;
      }
    }
    return Colors.transparent;
  }

  double getBorderWidth() {
    if (isPieceSelected || isMoveValid) {
      return 2;
    }
    return 0;
  }
}
