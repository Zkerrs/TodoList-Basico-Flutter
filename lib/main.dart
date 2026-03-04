import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// NOME MANTIDO EXATAMENTE COMO PEDIDO
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Modern Todo List',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          primary: const Color(0xFF6366F1),
        ),
      ),
      home: const TodoScreen(),
    );
  }
}

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController _taskController = TextEditingController();

  // A lista agora suporta um campo 'date' que pode ser nulo (opcional)
  final List<Map<String, dynamic>> tasks = [
    {
      'title': 'Review server logs',
      'isDone': false,
      'time': '10:00 AM',
      'date': null // Tarefa sem data (dia a dia)
    },
    {
      'title': 'Database Exam',
      'isDone': false,
      'time': '07:00 PM',
      'date': '24/10/2026' // Tarefa com data específica
    },
  ];

  // Função modificada para receber a data escolhida
  void _addTask(DateTime? selectedDate) {
    if (_taskController.text.isNotEmpty) {
      // Formata a data para texto se ela existir, ou deixa null
      String? formattedDate;
      if (selectedDate != null) {
        // Formato simples: DD/MM/AAAA
        formattedDate = '${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}';
      }

      setState(() {
        tasks.add({
          'title': _taskController.text,
          'isDone': false,
          'time': 'Now',
          'date': formattedDate, // Salva a data opcional
        });
      });
      _taskController.clear();
      Navigator.pop(context); // Fecha a janelinha
    }
  }

  void _toggleTask(int index) {
    setState(() {
      tasks[index]['isDone'] = !tasks[index]['isDone'];
    });
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  void _showAddTaskDialog() {
    // Usamos StatefulBuilder aqui dentro para que a janelinha possa se atualizar
    // quando selecionarmos a data, sem precisar fechar e abrir de novo.
    showDialog(
      context: context,
      builder: (context) {
        DateTime? pickedDate; // Variável para guardar a data enquanto a janela está aberta

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              title: const Text(
                'Nova nota',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min, // Faz a coluna usar apenas o espaço necessário
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _taskController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Qual o motivo da nota??',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Botão para escolher a data (Opcional)
                  InkWell(
                    onTap: () async {
                      // Abre o calendário do celular
                      final DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(), // Não deixa escolher datas no passado
                        lastDate: DateTime(2030), // Limite até 2030
                      );

                      if (date != null) {
                        // Atualiza a janelinha com a data escolhida
                        setDialogState(() {
                          pickedDate = date;
                        });
                      }
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_month_outlined,
                            size: 20,
                            color: pickedDate == null ? Colors.grey : Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            pickedDate == null 
                                ? 'Adicione uma Data (Opicional)' 
                                : '${pickedDate!.day.toString().padLeft(2, '0')}/${pickedDate!.month.toString().padLeft(2, '0')}/${pickedDate!.year}',
                            style: TextStyle(
                              color: pickedDate == null ? Colors.grey : Theme.of(context).colorScheme.primary,
                              fontWeight: pickedDate == null ? FontWeight.normal : FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _taskController.clear();
                    Navigator.pop(context);
                  },
                  child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: () => _addTask(pickedDate), // Envia a data escolhida para a função
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Adicionar nota'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Anotações e Trabalhos',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Você teve  ${tasks.where((t) => !t['isDone']).length} tarefas completas hoje.',
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 32),

              Expanded(
                child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return TaskCard(
                      title: task['title'],
                      time: task['time'],
                      date: task['date'], // Passa a data (pode ser nula) para o cartão
                      isDone: task['isDone'],
                      onToggle: () => _toggleTask(index),
                      onDelete: () => _deleteTask(index),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final String title;
  final String time;
  final String? date; // Variável opcional (?) para receber a data
  final bool isDone;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.title,
    required this.time,
    this.date, // Opcional
    required this.isDone,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDone ? Theme.of(context).colorScheme.primary : Colors.transparent,
                border: Border.all(
                  color: isDone ? Theme.of(context).colorScheme.primary : const Color(0xFFCBD5E1),
                  width: 2,
                ),
              ),
              child: isDone
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      decoration: isDone ? TextDecoration.lineThrough : TextDecoration.none,
                      color: isDone ? const Color(0xFF94A3B8) : const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: isDone ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDone ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                      ),
                      
                      // Só mostra a data e o ícone de calendário SE a data existir (não for nula)
                      if (date != null) ...[
                        const SizedBox(width: 12),
                        Icon(
                          Icons.calendar_today,
                          size: 13,
                          color: isDone ? const Color(0xFF94A3B8) : Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          date!,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: isDone ? const Color(0xFF94A3B8) : Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}