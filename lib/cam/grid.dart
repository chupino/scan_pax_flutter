
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final width = size.width;
    final height = size.height;

    final cardWidth = width * 0.8;
    final cardHeight = cardWidth * 0.5;
    final cardX = (width - cardWidth) / 2;
    final cardY = (height - cardHeight) / 2;

    final borderRadius = BorderRadius.circular(12);
    final rect = Rect.fromLTWH(cardX, cardY, cardWidth, cardHeight);
    final rrect = borderRadius.toRRect(rect);

    canvas.drawRRect(rrect, paint);

    final text = 'Coloca el DNI aquí';
    final textStyle = ui.TextStyle(
      color: Colors.white,
      fontSize: 24,
    );
    final paragraphStyle = ui.ParagraphStyle(
      textAlign: TextAlign.center,
    );
    final paragraphBuilder = ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(textStyle)
      ..addText(text);
    final constraints = ui.ParagraphConstraints(width: width);
    final paragraph = paragraphBuilder.build();
    paragraph.layout(constraints);

    final textOffset =
        Offset((width - paragraph.width) / 2, cardY - paragraph.height - 16);
    canvas.drawParagraph(paragraph, textOffset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}




