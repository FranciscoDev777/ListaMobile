import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

// ============================================================
// APLICATIVO
// ============================================================

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Listinha do Chico',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00BFA5),
          brightness: Brightness.light,
        ),

        scaffoldBackgroundColor: const Color(0xFFF6F8F8),

        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: false,
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF172121),
        ),

        cardTheme: CardThemeData(
          elevation: 0,
          color: Colors.white,
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 6,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      home: const TarefaScreen(),
    );
  }
}

// ============================================================
// MODELO DA TAREFA
// ============================================================

class Tarefa {
  final String id;
  String titulo;
  bool concluida;

  Tarefa({
    required this.id,
    required this.titulo,
    this.concluida = false,
  });
}

// ============================================================
// TELA PRINCIPAL
// ============================================================

class TarefaScreen extends StatefulWidget {
  const TarefaScreen({super.key});

  @override
  State<TarefaScreen> createState() => _TarefaScreenState();
}

class _TarefaScreenState extends State<TarefaScreen> {
  final List<Tarefa> _tarefas = [
    Tarefa(
      id: '1',
      titulo: 'Comprar pão, leite e ovo',
    ),
    Tarefa(
      id: '2',
      titulo: 'Responder e-mails do trabalho',
      concluida: true,
    ),
    Tarefa(
      id: '3',
      titulo: 'Academia às 18h',
    ),
  ];

  final TextEditingController _controller = TextEditingController();

  // ==========================================================
  // CONTADORES
  // ==========================================================

  int get _pendentes =>
      _tarefas.where((tarefa) => !tarefa.concluida).length;

  int get _concluidas =>
      _tarefas.where((tarefa) => tarefa.concluida).length;

  // ==========================================================
  // ADICIONAR TAREFA
  // ==========================================================

  void _abrirBottomSheet() {
    _controller.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 12,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Barrinha superior
              Center(
                child: Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Nova tarefa',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF172121),
                ),
              ),

              const SizedBox(height: 6),

              Text(
                'Adicione algo que você precisa fazer.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: _controller,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'Ex.: Estudar para a prova',
                  prefixIcon: const Icon(
                    Icons.edit_outlined,
                    color: Color(0xFF00BFA5),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF4F7F7),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Color(0xFF00BFA5),
                      width: 2,
                    ),
                  ),
                ),
                onSubmitted: (_) => _adicionarTarefa(),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: _adicionarTarefa,
                  icon: const Icon(Icons.add),
                  label: const Text(
                    'Adicionar tarefa',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00BFA5),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _adicionarTarefa() {
    final texto = _controller.text.trim();

    if (texto.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Digite uma tarefa antes de adicionar.',
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red.shade400,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    setState(() {
      _tarefas.add(
        Tarefa(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          titulo: texto,
        ),
      );
    });

    _controller.clear();
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Tarefa adicionada!'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF00BFA5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // ==========================================================
  // ALTERAR STATUS
  // ==========================================================

  void _alternarStatus(String id) {
    setState(() {
      final tarefa = _tarefas.firstWhere(
        (tarefa) => tarefa.id == id,
      );

      tarefa.concluida = !tarefa.concluida;
    });
  }

  // ==========================================================
  // DELETAR TAREFA
  // ==========================================================

  void _deletarTarefa(String id) {
    final index = _tarefas.indexWhere(
      (tarefa) => tarefa.id == id,
    );

    if (index == -1) return;

    final tarefaRemovida = _tarefas[index];

    setState(() {
      _tarefas.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '"${tarefaRemovida.titulo}" removida.',
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF172121),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }

  // ==========================================================
  // CARD DA TAREFA
  // ==========================================================

  Widget _buildTarefaCard(Tarefa tarefa) {
    return Dismissible(
      key: ValueKey(tarefa.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(18),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
          size: 28,
        ),
      ),
      onDismissed: (_) => _deletarTarefa(tarefa.id),
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => _alternarStatus(tarefa.id),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            child: Row(
              children: [
                // Checkbox personalizada
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: tarefa.concluida
                        ? const Color(0xFF00BFA5)
                        : Colors.transparent,
                    border: Border.all(
                      color: tarefa.concluida
                          ? const Color(0xFF00BFA5)
                          : Colors.grey.shade400,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: tarefa.concluida
                      ? const Icon(
                          Icons.check,
                          size: 18,
                          color: Colors.white,
                        )
                      : null,
                ),

                const SizedBox(width: 14),

                // Texto
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        tarefa.titulo,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: tarefa.concluida
                              ? Colors.grey.shade500
                              : const Color(0xFF172121),
                          decoration: tarefa.concluida
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          decorationThickness: 2,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Row(
                        children: [
                          Icon(
                            tarefa.concluida
                                ? Icons.check_circle_outline
                                : Icons.access_time,
                            size: 14,
                            color: tarefa.concluida
                                ? const Color(0xFF00BFA5)
                                : Colors.orange.shade600,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            tarefa.concluida
                                ? 'Concluída'
                                : 'Pendente',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: tarefa.concluida
                                  ? const Color(0xFF00A990)
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Icon(
                  Icons.chevron_right,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // TELA PRINCIPAL
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F8),

      appBar: AppBar(
        toolbarHeight: 75,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '2Do',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              'MinimaList',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF00BFA5),
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFE5F8F5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.pending_actions,
                  size: 17,
                  color: Color(0xFF00A990),
                ),
                const SizedBox(width: 5),
                Text(
                  '$_pendentes pendentes',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF008F7A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      body: _tarefas.isEmpty
          ? _buildListaVazia()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==================================================
                // RESUMO
                // ==================================================

                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    22,
                    20,
                    8,
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Minhas tarefas',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF172121),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Organize seu dia de forma simples.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(14),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '$_concluidas',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF00BFA5),
                              ),
                            ),
                            const Text(
                              'feitas',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ==================================================
                // LISTA
                // ==================================================

                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 110,
                    ),
                    itemCount: _tarefas.length,
                    itemBuilder: (context, index) {
                      return _buildTarefaCard(
                        _tarefas[index],
                      );
                    },
                  ),
                ),
              ],
            ),

      // ========================================================
      // BOTÃO FLUTUANTE
      // ========================================================

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirBottomSheet,
        backgroundColor: const Color(0xFF00BFA5),
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.add),
        label: const Text(
          'Nova tarefa',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // LISTA VAZIA
  // ==========================================================

  Widget _buildListaVazia() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: const Color(0xFFE5F8F5),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.task_alt,
                size: 48,
                color: Color(0xFF00BFA5),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Tudo certo por aqui!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF172121),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Você não possui tarefas no momento.\n'
              'Adicione uma nova tarefa para começar.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: _abrirBottomSheet,
              icon: const Icon(Icons.add),
              label: const Text('Criar tarefa'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00BFA5),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}