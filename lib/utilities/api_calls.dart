import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:lux_chain/utilities/api_models.dart';

Future<List<WalletWatch>> getUserWalletWatches(int userID) async {
  try {
    // The call for retrieving all the watches whose some shares are owned by the user
    final response = await http.get(
      Uri.parse('https://luxchain-flame.vercel.app/api/wallet/watches/$userID'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);     
      return data.map((e) => WalletWatch.fromJson(e)).toList();
    } else {
      throw Exception('[FLUTTER] Failed to load user watches');
    }
  } catch (e) {
    
    throw Exception('[FLUTTER] Error retrieving user watches: $e');
  }
}

Future<Watch> getWatchByWatchId(int watchID) async {
  try {
    // Retrieving all the information about the watch
    final response = await http.get(
      Uri.parse('https://luxchain-flame.vercel.app/api/watch/$watchID'),
    );

    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);     
      return Watch.fromJson(data);
    } else {
      throw Exception('[FLUTTER] Failed to load watch\'s data');
    }
  } catch (e) {
    
    throw Exception('[FLUTTER] Error retrieving watch\'s data: $e');
  }
}

Future<List<WalletWatch>> getSharesByUser(int userID) async {
  try {
    //Retrieving all the shares owned by the user
    final response = await http.get(
      Uri.parse('https://luxchain-flame.vercel.app/api/shares/$userID'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);     
      return data.map((e) => WalletWatch.fromJson(e)).toList();
    } else {
      throw Exception('[FLUTTER] Failed to load user shares');
    }
  } catch (e) {
    
    throw Exception('[FLUTTER] Error retrieving user shares: $e');
  }
}

Future<List<WalletWatch>> getSharesByWatch(int watchID) async {
  try {
    //Retreieving watch's shares
    final response = await http.get(
      Uri.parse('https://luxchain-flame.vercel.app/api/watches/shares/$watchID'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);     
      return data.map((e) => WalletWatch.fromJson(e)).toList();
    } else {
      throw Exception('[FLUTTER] Failed to load watch\'s shares');
    }
  } catch (e) {
    
    throw Exception('[FLUTTER] Error retrieving watche\'s shares: $e');
  }
}

// Future<List<WalletWatch>> getTradedShares(int userID) async {
//   try {
//     // Effettua la chiamata per ottenere le azioni associate all'utente
//     final response = await http.get(
//       Uri.parse('https://luxchain-flame.vercel.app/api/shares/traded/$userID'),
//     );

//     if (response.statusCode == 200) {
//       final List<dynamic> data = jsonDecode(response.body);     
//       return data.map((e) => WalletWatch.fromJson(e)).toList();
//     } else {
//       throw Exception('[FLUTTER] Failed to load user shares');
//     }
//   } catch (e) {
    
//     throw Exception('[FLUTTER] Error retrieving user watches: $e');
//   }
// }

Future<List<WalletWatch>> getSharesOfUserOnSale(int userID) async {
  try {
    // Retreieving user's on sale shares
    final response = await http.get(
      Uri.parse('https://luxchain-flame.vercel.app/api/shares/onSale/$userID'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);     
      return data.map((e) => WalletWatch.fromJson(e)).toList();
    } else {
      throw Exception('[FLUTTER] Failed to load user shares');
    }
  } catch (e) {
    
    throw Exception('[FLUTTER] Error retrieving user shares: $e');
  }
}

// Future<List<WalletWatch>> getFavouritesShared(int userID) async {
//   try {
//     // Effettua la chiamata per ottenere le azioni associate all'utente
//     final response = await http.get(
//       Uri.parse('https://luxchain-flame.vercel.app/api/shares/favourites/$userID'),
//     );

//     if (response.statusCode == 200) {
//       final List<dynamic> data = jsonDecode(response.body);     
//       return data.map((e) => WalletWatch.fromJson(e)).toList();
//     } else {
//       throw Exception('[FLUTTER] Failed to load user shares');
//     }
//   } catch (e) {
    
//     throw Exception('[FLUTTER] Error retrieving user watches: $e');
//   }
// }

Future<List<ShareOnSale>> getSharesOfTheWatchOnSell(int watchID) async {
  try {
    // Retrieving all the on sale shares of a watch
    final response = await http.get(
      Uri.parse('https://luxchain-flame.vercel.app/api/marketplace/watch/$watchID'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);     
      return data.map((e) => ShareOnSale.fromJson(e)).toList();
    } else {
      throw Exception('[FLUTTER] Failed to load shares');
    }
  } catch (e) {
    throw Exception('[FLUTTER] Error retrieving on sale shares: $e');
  }
}

Future<WalletData> getWalletData(int userID) async {
  try {
    // Retrieiving wallet data
    final response = await http.get(
      Uri.parse('https://luxchain-flame.vercel.app/api/wallet/data/$userID'),
    );

    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);     
      return WalletData.fromJson(data);
    } else {
      throw Exception('[FLUTTER] Failed to load wallet data');
    }
  } catch (e) {
    
    throw Exception('[FLUTTER] Error retrieving wallet data: $e');
  }
}