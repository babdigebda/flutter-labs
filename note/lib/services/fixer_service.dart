import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/currency_rate.dart';

class FixerService {

  static const String _apiKey = '161fb390d2b237d458ac9d649ced0961';
  static const String _baseUrl = 'http://data.fixer.io/api';  

  static Future<List<CurrencyRate>> getLatestRates() async {
    try {
      final url = Uri.parse('$_baseUrl/latest?access_key=$_apiKey');
      print('Запрос к API: $url'); 
      
      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
      );

      print('Статус ответа: ${response.statusCode}');
      print('Тело ответа: ${response.body}'); 

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['success'] == true) {

          final rates = Map<String, dynamic>.from(data['rates']);
          final List<CurrencyRate> currencyList = [];
          

          const popularCurrencies = [
            'USD', 'GBP', 'JPY', 'CHF', 'CAD', 'AUD', 'CNY', 'RUB'
          ];
          
          for (final code in popularCurrencies) {
            if (rates.containsKey(code)) {
              currencyList.add(CurrencyRate(
                code: code,
                name: _getCurrencyName(code),
                rate: rates[code].toDouble(),
                flag: _getFlagForCurrency(code),
              ));
            }
          }
          

          currencyList.insert(0, CurrencyRate(
            code: 'EUR',
            name: 'Евро',
            rate: 1.0,
            flag: '🇪🇺',
          ));
          
          return currencyList;
        } else {
          throw Exception('Ошибка API: ${data['error']['type']}');
        }
      } else {
        throw Exception('Ошибка HTTP: ${response.statusCode}');
      }
    } catch (e) {
      print('Ошибка загрузки: $e');

      return _getMockRates();
    }
  }

  static String _getCurrencyName(String code) {
    const names = {
      'USD': 'Доллар США',
      'EUR': 'Евро',
      'GBP': 'Фунт стерлингов',
      'JPY': 'Японская иена',
      'CHF': 'Швейцарский франк',
      'CAD': 'Канадский доллар',
      'AUD': 'Австралийский доллар',
      'CNY': 'Китайский юань',
      'RUB': 'Российский рубль',
    };
    return names[code] ?? code;
  }

  static String _getFlagForCurrency(String code) {
    const flags = {
      'USD': '🇺🇸',
      'EUR': '🇪🇺',
      'GBP': '🇬🇧',
      'JPY': '🇯🇵',
      'CHF': '🇨🇭',
      'CAD': '🇨🇦',
      'AUD': '🇦🇺',
      'CNY': '🇨🇳',
      'RUB': '🇷🇺',
    };
    return flags[code] ?? '🏳️';
  }


  static List<CurrencyRate> _getMockRates() {
    return [
      CurrencyRate(code: 'EUR', name: 'Евро', rate: 1.00, flag: '🇪🇺'),
      CurrencyRate(code: 'USD', name: 'Доллар США', rate: 1.18, flag: '🇺🇸'),
      CurrencyRate(code: 'GBP', name: 'Фунт стерлингов', rate: 0.85, flag: '🇬🇧'),
      CurrencyRate(code: 'JPY', name: 'Японская иена', rate: 130.50, flag: '🇯🇵'),
      CurrencyRate(code: 'CHF', name: 'Швейцарский франк', rate: 0.92, flag: '🇨🇭'),
      CurrencyRate(code: 'CAD', name: 'Канадский доллар', rate: 1.25, flag: '🇨🇦'),
      CurrencyRate(code: 'AUD', name: 'Австралийский доллар', rate: 1.35, flag: '🇦🇺'),
      CurrencyRate(code: 'CNY', name: 'Китайский юань', rate: 7.65, flag: '🇨🇳'),
      CurrencyRate(code: 'RUB', name: 'Российский рубль', rate: 90.23, flag: '🇷🇺'),
    ];
  }
}