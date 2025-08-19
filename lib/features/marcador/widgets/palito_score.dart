import 'package:flutter/material.dart';

/// Cada caixinha representa até 5 tentos:
/// Ordem: 1 topo | 2 direita | 3 esquerda | 4 base | 5 diagonal (/)
class PalitoScore extends StatelessWidget {
  final int pontos; // 0..5

  const PalitoScore({super.key, required this.pontos});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: CustomPaint(
        painter: _CaixinhaPalitoPainter(pontos),
      ),
    );
  }
}

class _CaixinhaPalitoPainter extends CustomPainter {
  final int pontos;
  _CaixinhaPalitoPainter(this.pontos);

  @override
  void paint(Canvas canvas, Size size) {
    final stick = Paint()
      ..color = const Color(0xFFEAD7B0) // “madeira” clara
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    // Sombrinha discreta
    final shadow = Paint()
      ..color = Colors.black.withOpacity(0.18)
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final head = Paint()
      ..color = const Color(0xFFCC2B2B) // cabeça vermelha
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    const headR = 4.8;
    const shadowOffset = Offset(1.3, 1.3);

    final pad = 6.0;
    final w = size.width  - 2 * pad;
    final h = size.height - 2 * pad;

    // Desenha 1 fósforo com cabeça APENAS na origem (a)
    void drawMatch(Offset a, Offset b) {
      // sombra
      canvas.drawLine(a + shadowOffset, b + shadowOffset, shadow);
      canvas.drawCircle(a + shadowOffset, headR, shadow);
      // corpo
      canvas.drawLine(a, b, stick);
      // cabeça única
      canvas.drawCircle(a, headR, head);
    }

    // 1) topo (esquerda -> direita)
    if (pontos >= 1) {
      drawMatch(Offset(pad, pad), Offset(pad + w, pad));
    }
    // 2) direita (topo -> base)
    if (pontos >= 2) {
      drawMatch(Offset(pad + w, pad), Offset(pad + w, pad + h));
    }
    // 3) esquerda (topo -> base)
    if (pontos >= 3) {
      drawMatch(Offset(pad, pad), Offset(pad, pad + h));
    }
    // 4) base (direita -> esquerda)
    if (pontos >= 4) {
      drawMatch(Offset(pad + w, pad + h), Offset(pad, pad + h));
    }
    // 5) diagonal “/” (base-esquerda -> topo-direita)
    if (pontos >= 5) {
      drawMatch(Offset(pad, pad + h), Offset(pad + w, pad));
    }
  }

  @override
  bool shouldRepaint(covariant _CaixinhaPalitoPainter old) {
    return old.pontos != pontos;
  }
}
