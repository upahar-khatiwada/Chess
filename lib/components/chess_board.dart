import 'package:chess/constants/project_constants.dart';
import 'package:chess/helper_methods/chess_piece_class.dart';
import 'package:flutter/material.dart';

class ChessBoard extends StatefulWidget {
  final int index;
  final ChessPiece? piece;
  final bool isPieceSelected;
  final VoidCallback onTap;
  const ChessBoard({
    super.key,
    required this.index,
    required this.piece,
    required this.isPieceSelected,
    required this.onTap,
  });

  @override
  State<ChessBoard> createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        // if tapped on a piece, color green else default color
        color: widget.isPieceSelected
            ? pieceSelectedColor
            : (widget.index % 8 + (widget.index / 8).toInt()) % 2 == 0
            ? whiteSquare
            : blackSquare,

        child: widget.piece != null
            ? Image.asset(widget.piece!.imagePath)
            : null,
      ),
    );
  }
}