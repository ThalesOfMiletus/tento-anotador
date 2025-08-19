import 'package:flutter/material.dart';

class MarcadorController extends ChangeNotifier {
  int pontosNos = 0;
  int pontosEles = 0;

  String nomeNos = "Nós";
  String nomeEles = "Eles";

  void alterarNome(bool isNos, String novoNome) {
    if (novoNome.isEmpty) return;
    if (isNos) {
      nomeNos = novoNome;
    } else {
      nomeEles = novoNome;
    }
    notifyListeners();
  }

  void alterarPontos(bool isNos, int delta) {
    if (isNos) {
      pontosNos = (pontosNos + delta).clamp(0, 30);
    } else {
      pontosEles = (pontosEles + delta).clamp(0, 30);
    }
    notifyListeners();
  }

  void novaPartida() {
    pontosNos = 0;
    pontosEles = 0;
    notifyListeners();
  }
}
