import 'package:flutter/material.dart';

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({super.key});

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  String _selectedBase = 'EUR';
  

  final List<Map<String, dynamic>> _mockRates = [
    {'code': 'USD', 'name': 'Доллар США', 'rate': 1.05, 'flag': '🇺🇸'},
    {'code': 'GBP', 'name': 'Фунт стерлингов', 'rate': 0.85, 'flag': '🇬🇧'},
    {'code': 'JPY', 'name': 'Японская иена', 'rate': 160.50, 'flag': '🇯🇵'},
    {'code': 'CHF', 'name': 'Швейцарский франк', 'rate': 0.98, 'flag': '🇨🇭'},
    {'code': 'CAD', 'name': 'Канадский доллар', 'rate': 1.42, 'flag': '🇨🇦'},
    {'code': 'AUD', 'name': 'Австралийский доллар', 'rate': 1.58, 'flag': '🇦🇺'},
    {'code': 'CNY', 'name': 'Китайский юань', 'rate': 7.65, 'flag': '🇨🇳'},
    {'code': 'RUB', 'name': 'Российский рубль', 'rate': 95.50, 'flag': '🇷🇺'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Курсы валют'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.teal.shade50,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Text(
                  'Базовая валюта:',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedBase,
                        isExpanded: true,
                        items: const [
                          DropdownMenuItem(value: 'EUR', child: Text('EUR (Евро)')),
                          DropdownMenuItem(value: 'USD', child: Text('USD (Доллар США)')),
                          DropdownMenuItem(value: 'GBP', child: Text('GBP (Фунт)')),
                          DropdownMenuItem(value: 'JPY', child: Text('JPY (Иена)')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedBase = value;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            alignment: Alignment.centerRight,
            child: Text(
              'Обновлено: 14:30, 19 марта',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _mockRates.length,
              itemBuilder: (ctx, index) {
                final rate = _mockRates[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.teal.shade50,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Text(
                          rate['flag'],
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                    title: Text(
                      rate['code'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(rate['name']),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        rate['rate'].toStringAsFixed(4),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.teal.shade900,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}