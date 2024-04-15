import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:lux_chain/utilities/api_models.dart';

Future<List<WalletWatch>> getUserWalletWatches(int userID) async {
  try {
    // Effettua la chiamata per ottenere le azioni associate all'utente
    final response = await http.get(
      Uri.parse('https://luxchain-flame.vercel.app/api/wallet/watches/$userID'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);      
      return data.map((e) => WalletWatch.fromJson(e)).toList();
    } else {
      throw Exception('[FLUTTER] Failed to load user shares');
    }
  } catch (e) {
    
    throw Exception('[FLUTTER] Error retrieving user watches: $e');
  }
}
