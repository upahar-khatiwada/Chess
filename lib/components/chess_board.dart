import 'package:chess/helper_methods/chess_piece_class.dart';
import 'package:flutter/material.dart';

class ChessBoard extends StatefulWidget {
  final int index;
  final ChessPiece? piece;
  const ChessBoard({super.key, required this.index, required this.piece});

  @override
  State<ChessBoard> createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: (widget.index % 8 + (widget.index / 8).toInt()) % 2 == 0
          ? Colors.grey[300]
          : Colors.grey[600],
      child: widget.piece != null ? Image.asset(widget.piece!.imagePath) : null,
    );
  }
}
