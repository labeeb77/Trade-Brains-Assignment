import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:trade_brains/model/company_model.dart';

Future<List<Company>> fetchSearchResults(String keywords) async {
  const apiKey = '4O7RPT8JJXQ4I5UO';
  final apiUrl =
      'https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=$keywords&apikey=$apiKey';

  final response = await http.get(Uri.parse(apiUrl));
  if (response.statusCode == 200) {
    final jsonBody = json.decode(response.body);
    final searchResults = jsonBody['bestMatches'] as List<dynamic>;

    final List<Company> companies = searchResults.map((result) {
      return Company.fromJson(result);
    }).toList();

    return companies;
  } else {
    throw Exception('Failed to search for companies');
  }
}

Future<double?> fetchLatestPrice(String symbol) async {
  log('entered to LatestPrice');
  const apiKey = '4O7RPT8JJXQ4I5UO';
  final apiUrl =
      'https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=$symbol&apikey=$apiKey';

  final response = await http.get(Uri.parse(apiUrl));
  if (response.statusCode == 200) {
    final jsonBody = json.decode(response.body);
    final companyData = jsonBody['Global Quote'];

     if (companyData != null && companyData.containsKey('05. price')) {
      return double.tryParse(companyData['05. price']) ;
    } else {
      // Return null for missing price or invalid company data
      return null;
    }
  } else {
    throw Exception(
        'Error occurred in API call, Failed to fetch latest price for $symbol');
  }
}
