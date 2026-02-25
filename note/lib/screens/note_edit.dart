import 'package:flutter/material.dart';
import '../models/note.dart';

class NoteEditScreen extends StatefulWidget {
  const NoteEditScreen({super.key});

  @override
  State<NoteEditScreen> createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  
  String? _selectedCurrency;
  
  final List<String> _currencies = [
    'USD', 'EUR', 'GBP', 'JPY', 'CHF', 'CAD', 'AUD', 'CNY', 'RUB'
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _createNote() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Введите заголовок заметки'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final newNote = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      content: _contentController.text,
      createdAt: DateTime.now(),
      lastModified: DateTime.now(),
      currencyCode: _selectedCurrency,
      currencyAmount: _amountController.text.isNotEmpty
          ? double.tryParse(_amountController.text.replaceAll(',', '.'))
          : null,
    );

    Navigator.pop(context, newNote);
  }

  String _getFlagForCurrency(String currency) {
    const flags = {
      'USD': '🇺🇸', 'EUR': '🇪🇺', 'GBP': '🇬🇧', 'JPY': '🇯🇵',
      'CHF': '🇨🇭', 'CAD': '🇨🇦', 'AUD': '🇦🇺', 'CNY': '🇨🇳',
      'RUB': '🇷🇺',
    };
    return flags[currency] ?? '🏳️';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Новая заметка'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _createNote,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Заголовок',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Введите заголовок...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              autofocus: true,
            ),
            
            const SizedBox(height: 20),
            
            const Text(
              'Содержание',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                hintText: 'Введите текст заметки...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              maxLines: 5,
              minLines: 3,
            ),
            
            const SizedBox(height: 30),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.teal.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Привязать валюту (опционально)',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  const Text(
                    'Валюта',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedCurrency,
                        isExpanded: true,
                        hint: const Text('Выберите валюту'),
                        items: [
                          ..._currencies.map((currency) {
                            return DropdownMenuItem(
                              value: currency,
                              child: Row(
                                children: [
                                  Text(
                                    _getFlagForCurrency(currency),
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(currency),
                                ],
                              ),
                            );
                          }),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedCurrency = value;
                          });
                        },
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  const Text(
                    'Сумма',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      hintText: '0.00',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      suffixText: _selectedCurrency ?? '',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    enabled: _selectedCurrency != null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}