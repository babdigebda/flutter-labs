import 'package:flutter/material.dart';
import 'note_edit.dart';
import 'currency_screen.dart';

class NotesListScreen extends StatefulWidget {
  const NotesListScreen({super.key});

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  // Список заметок (будет пополняться)
  List<Map<String, dynamic>> _notes = [
    {
      'id': '1',
      'title': 'Купить продукты',
      'content': 'Молоко, яйца, хлеб, сыр, овощи',
      'date': DateTime.now().subtract(const Duration(hours: 2)),
    },
    {
      'id': '2',
      'title': 'Встреча с командой',
      'content': 'Обсудить новый проект в 15:00',
      'date': DateTime.now().subtract(const Duration(days: 1)),
    },
  ];

  // Добавление новой заметки
  void _addNote(Map<String, dynamic> newNote) {
    setState(() {
      _notes.add(newNote);
    });
  }

  // Удаление заметки
  void _deleteNote(String id) {
    setState(() {
      _notes.removeWhere((note) => note['id'] == id);
    });
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Сегодня в ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Вчера';
    } else {
      return '${date.day}.${date.month}.${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои заметки'),
        centerTitle: true,
        // Кнопка для открытия Drawer
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.currency_exchange),
            onPressed: () {
              // Навигация через push
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CurrencyScreen(),
                ),
              );
            },
          ),
        ],
      ),
      // Drawer (боковое меню)
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CurrencyNotes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Ваши заметки и курсы валют',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.note_alt),
              title: const Text('Все заметки'),
              onTap: () {
                Navigator.pop(context); // Закрываем Drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.currency_exchange),
              title: const Text('Курсы валют'),
              onTap: () {
                Navigator.pop(context); // Закрываем Drawer
                // Открываем экран валют
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CurrencyScreen(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('О приложении'),
              onTap: () {
                Navigator.pop(context);
                showAboutDialog(
                  context: context,
                  applicationName: 'CurrencyNotes',
                  applicationVersion: '1.0.0',
                  applicationLegalese: '© 2026',
                );
              },
            ),
          ],
        ),
      ),
      body: _notes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.note_alt_outlined,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'У вас пока нет заметок',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () async {
                      // Открываем экран создания и ждём результат
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NoteEditScreen(),
                        ),
                      );
                      
                      // Если вернули заметку - добавляем
                      if (result != null) {
                        _addNote(result);
                      }
                    },
                    child: const Text('Создать заметку'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _notes.length,
              itemBuilder: (ctx, index) {
                final note = _notes[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      note['title'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          note['content'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: Colors.grey.shade500,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatDate(note['date']),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => _deleteNote(note['id']),
                    ),
                    onTap: () {
                      // Здесь можно будет добавить просмотр заметки
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Открываем экран создания и ждём результат
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NoteEditScreen(),
            ),
          );
          
          // Если вернули заметку - добавляем
          if (result != null) {
            _addNote(result);
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Новая заметка'),
      ),
    );
  }
}