import 'package:chess/constants/project_constants.dart';
import 'package:chess/helper_methods/chess_piece_class.dart';
import 'package:flutter/material.dart';

class ChessBoard extends StatefulWidget {
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
  const ChessBoard({
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
  });

  @override
  State<ChessBoard> createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard> {
  Color? squareColor;

  @override
  Widget build(BuildContext context) {
    ChessPiece? enemyPiece = widget.board[widget.row][widget.col];
    if (widget.isPieceSelected) {
      squareColor = pieceSelectedColor;
    } else if (widget.isMoveValid) {
      if (enemyPiece != null &&
          widget.currentlySelectedPiece != null &&
          enemyPiece.isWhite != widget.currentlySelectedPiece!.isWhite) {
        squareColor = Colors.red;
      } else {
        squareColor = possibleMovesColor;
      }
    } else {
      squareColor = (widget.index % 8 + (widget.index / 8).toInt()) % 2 == 0
          ? whiteSquare
          : blackSquare;
    }

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: squareColor,
          border: Border.all(color: getBorderColor(), width: getBorderWidth()),
        ),
        // if tapped on a piece, color green else default color
        child: widget.piece != null
            ? Image.asset(widget.piece!.imagePath)
            : null,
      ),
    );
  }

  Color getBorderColor() {
    if (widget.isPieceSelected) {
      return Colors.black45;
    } else if (widget.isMoveValid) {
      ChessPiece? targetPiece = widget.board[widget.row][widget.col];
      if (targetPiece != null &&
          widget.currentlySelectedPiece != null &&
          targetPiece.isWhite != widget.currentlySelectedPiece!.isWhite) {
        return Colors.red;
      } else {
        return Colors.black;
      }
    }
    return Colors.transparent;
  }

  double getBorderWidth() {
    if (widget.isPieceSelected || widget.isMoveValid) {
      return 2;
    }
    return 0;
  }
}
