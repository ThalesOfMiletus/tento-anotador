import 'package:flutter/material.dart';
import 'features/marcador/marcador_page.dart';

void main() {
  runApp(const TentoApp());
}

class TentoApp extends StatelessWidget {
  const TentoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(
      seedColor: Colors.brown,
      brightness: Brightness.light,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tento - Truco Gaúcho',
      theme: ThemeData(
        colorScheme: scheme,
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.transparent, // deixa o fundo aparecer
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.brown.shade900,
          centerTitle: true,
          elevation: 0,
          titleTextStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      home: const _WoodBackground(child: MarcadorPage()),
    );
  }
}

/// Fundo com efeito de madeira (sem assets), usando CustomPainter
class _WoodBackground extends StatelessWidget {
  final Widget child;
  const _WoodBackground({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _WoodPainter(),
      child: child,
    );
  }
}

class _WoodPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Cores base da madeira
    final base = const Color(0xFF6D4C41);
    final light = const Color(0xFF8D6E63);
    final dark  = const Color(0xFF5D4037);

    // Placas horizontais
    final plankH = 80.0;
    for (double y = 0; y < size.height; y += plankH) {
      final rect = Rect.fromLTWH(0, y, size.width, plankH);
      final shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [light, base, dark],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(rect);

      final paint = Paint()..shader = shader;
      canvas.drawRect(rect, paint);

      // “Veios” sutis da madeira
      final grain = Paint()
        ..color = Colors.black.withOpacity(0.05)
        ..strokeWidth = 1.2
        ..style = PaintingStyle.stroke;

      // 3 linhas curvas por prancha
      for (int i = 0; i < 3; i++) {
        final path = Path();
        final offsetY = y + plankH * (0.2 + 0.25 * i);
        path.moveTo(0, offsetY);
        // ondulação leve
        for (double x = 0; x <= size.width; x += 40) {
          path.quadraticBezierTo(
            x + 10, offsetY + (i.isEven ? 4 : -4),
            x + 40, offsetY,
          );
        }
        canvas.drawPath(path, grain);
      }

      // linha divisória da prancha
      final edge = Paint()
        ..color = Colors.black.withOpacity(0.08)
        ..strokeWidth = 1;
      canvas.drawLine(Offset(0, y + plankH), Offset(size.width, y + plankH), edge);
    }
  }

  @override
  bool shouldRepaint(covariant _WoodPainter oldDelegate) => false;
}
