import 'package:flutter/material.dart';
import '../services/fixer_service.dart';
import '../models/currency_rate.dart';
import 'package:intl/intl.dart';  

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({super.key});

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  List<CurrencyRate> _rates = [];
  bool _isLoading = true;
  String? _error;
  DateTime? _lastUpdated;  

  @override
  void initState() {
    super.initState();
    _loadRates();
  }

  Future<void> _loadRates() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final rates = await FixerService.getLatestRates();
      setState(() {
        _rates = rates;
        _isLoading = false;
        _lastUpdated = DateTime.now();  
      });
      

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Курсы обновлены: ${DateFormat.Hm().format(DateTime.now())}'),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка обновления: $e'),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('HH:mm, d MMMM').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Курсы валют'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [

          _isLoading
              ? Container(
                  margin: const EdgeInsets.all(8),
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _loadRates,
                  tooltip: 'Обновить курсы',
                ),
        ],
      ),
      body: _isLoading && _rates.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : _error != null && _rates.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _error!,
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadRates,
                        child: const Text('Повторить'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [

                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.teal.shade50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Базовая валюта:',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.teal,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'EUR (Евро)',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (_lastUpdated != null)
                            Text(
                              'Обновлено: ${_formatDate(_lastUpdated!)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                        ],
                      ),
                    ),
                    

                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: _rates.length,
                        itemBuilder: (ctx, index) {
                          final rate = _rates[index];
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
                                    rate.flag,
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                ),
                              ),
                              title: Text(
                                rate.code,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: Text(rate.name),
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
                                  rate.rate.toStringAsFixed(4),
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