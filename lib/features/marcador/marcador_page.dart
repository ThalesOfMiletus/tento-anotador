import 'package:flutter/material.dart';
import 'marcador_controller.dart';
import 'widgets/palito_score.dart';

class MarcadorPage extends StatefulWidget {
  const MarcadorPage({super.key});

  @override
  State<MarcadorPage> createState() => _MarcadorPageState();
}

class _MarcadorPageState extends State<MarcadorPage> {
  final controller = MarcadorController();

  // ===== AÇÕES =====
  void _alterarNome(bool isNos) async {
    final text = TextEditingController(
      text: isNos ? controller.nomeNos : controller.nomeEles,
    );

    final novoNome = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Alterar nome do time"),
        content: TextField(
          controller: text,
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(labelText: "Novo nome"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, text.text.trim()),
            child: const Text("Salvar"),
          ),
        ],
      ),
    );

    if (novoNome != null && novoNome.isNotEmpty) {
      setState(() => controller.alterarNome(isNos, novoNome));
    }
  }

  void _novaPartida() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Nova partida"),
        content: const Text("Deseja realmente iniciar uma nova partida?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Sim"),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      setState(() => controller.novaPartida());
    }
  }

  // ===== UI =====
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Contagem de pontos")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Área principal com dois lados
            Expanded(
              child: Stack(
                children: [
                  Row(
                    children: [
                      Expanded(child: _lado(isNos: true)),
                      const VerticalDivider(thickness: 2, color: Colors.black26),
                      Expanded(child: _lado(isNos: false)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // --- Botão no rodapé, seguro contra barras/gestos do Android ---
      bottomNavigationBar: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: FilledButton.icon(
          onPressed: _novaPartida,
          icon: const Icon(Icons.flag_outlined),
          label: const Text("Nova partida"),
        ),
      ),
    );
  }

  /// Constrói um dos lados (Nós/Eles)
  Widget _lado({required bool isNos}) {
    final nome = isNos ? controller.nomeNos : controller.nomeEles;
    final pontos = isNos ? controller.pontosNos : controller.pontosEles;

    // Divide os pontos em 0..15 (topo) e 0..15 (base)
    final topPoints = pontos.clamp(0, 15);
    final bottomPoints = (pontos - 15).clamp(0, 15);

    return Column(
      children: [
        // Cabeçalho com nome e pontuação (toca para renomear)
        GestureDetector(
          onTap: () => _alterarNome(isNos),
          child: Text(
            "$nome: $pontos",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 12),

        // Área central clicável (apenas essa parte soma ponto)
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => setState(() => controller.alterarPontos(isNos, 1)),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black.withOpacity(0.08)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: Column(
                children: [
                  // Metade superior (0..15) -> 3 caixinhas verticais
                  Expanded(child: _tresCaixinhasVerticais(topPoints)),
                  // Linha separadora das metades (visual)
                  Container(
                    height: 1.4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                  // Metade inferior (16..30) -> 3 caixinhas verticais
                  Expanded(child: _tresCaixinhasVerticais(bottomPoints)),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 10),

        // Botões + e −
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton.filled(
              onPressed: () =>
                  setState(() => controller.alterarPontos(isNos, 1)),
              icon: const Icon(Icons.add),
              tooltip: "Somar ponto",
              style: IconButton.styleFrom(
                backgroundColor: Colors.brown.shade700,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            IconButton.filledTonal(
              onPressed: () =>
                  setState(() => controller.alterarPontos(isNos, -1)),
              icon: const Icon(Icons.remove),
              tooltip: "Remover ponto",
              style: IconButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Exibe exatamente 3 caixinhas verticais (slots) para 0..15 pontos.
  /// Cada slot mostra 0..5 fósforos.
  Widget _tresCaixinhasVerticais(int pontosDe0a15) {
    // Calcula os pontos por slot (5 por slot)
    int slot(int i) => (pontosDe0a15 - i * 5).clamp(0, 5);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _slotCaixinha(slot(0)),
        const SizedBox(height: 10),
        _slotCaixinha(slot(1)),
        const SizedBox(height: 10),
        _slotCaixinha(slot(2)),
      ],
    );
  }

  Widget _slotCaixinha(int pontosNoSlot) {
    return Center(
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.brown.withOpacity(0.20)),
          color: Colors.white.withOpacity(0.06),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          child: PalitoScore(
            pontos: pontosNoSlot,
          ),
        ),
      ),
    );
  }
}
