import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:lux_chain/utilities/api_models.dart';

const String apiURL = 'https://luxchain-flame.vercel.app/api';

Future<List<WalletWatch>> getUserWalletWatches(int userID, int pageNumber, int watchPerPage) async {
  try {
    // Costruisce l'URL con i parametri di query
    final url = Uri.parse('$apiURL/wallet/watches/$userID')
        .replace(queryParameters: {
      'pageNumber': pageNumber.toString(),
      'watchPerPage': watchPerPage.toString(),
    });

    final response = await http.get(url);

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

Future<WatchAdditionalData> getWatchAdditionalData(
    int userID, int watchID) async {
  try {
    // Retrieving all the additional information about the watch
    final response = await http.get(
      Uri.parse('$apiURL/wallet/watch/$userID/$watchID'),
    );

    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);
      return WatchAdditionalData.fromJson(data);
    } else {
      throw Exception('[FLUTTER] Failed to load watch\'s additional data');
    }
  } catch (e) {
    throw Exception('[FLUTTER] Error retrieving watch\'s additional data: $e');
  }
}

Future<List<WalletWatch>> getSharesByUser(int userID) async {
  try {
    //Retrieving all the shares owned by the user
    final response = await http.get(
      Uri.parse('$apiURL/shares/$userID'),
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
      Uri.parse('$apiURL/watches/shares/$watchID'),
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

Future<List<WalletWatch>> getSharesOfUserOnSale(int userID) async {
  try {
    // Retreieving user's on sale shares
    final response = await http.get(
      Uri.parse('$apiURL/shares/onSale/$userID'),
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

Future<List<ShareOnSale>> getSharesOfTheWatchOnSell(int watchID) async {
  try {
    // Retrieving all the on sale shares of a watch
    final response = await http.get(
      Uri.parse('$apiURL/marketplace/watch/$watchID'),
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
      Uri.parse('$apiURL/wallet/data/$userID'),
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

Future<APIStatus> sellShares(
    int userID, int watchID, int numberOfShares, double priceOfOneShare) async {
  try {
    Map<String, dynamic> requestBody = {
      'price': priceOfOneShare.toString(),
      'numberOfSharesToSell': numberOfShares,
    };

    final response = await http.post(
      Uri.parse('$apiURL/trade/sell/$watchID/$userID'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      // ignore: avoid_print
      print("SUCCESS SELL");
      return APIStatus.success;
    } else {
      throw Exception(
          '[FLUTTER] Failed to sell $numberOfShares shares of watch $watchID');
    }
  } catch (e) {
    return APIStatus.error;
  }
}

Future<APIStatus> buyShares(
    int userID, int watchID, int numberOfShares, double priceOfOneShare) async {
  try {
    Map<String, dynamic> requestBody = {
      'price': priceOfOneShare.toString(),
      'numberOfShares': numberOfShares,
    };

    final response = await http.post(
      Uri.parse('$apiURL/trade/buy/$watchID/$userID'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      // ignore: avoid_print
      print("SUCCESS BUY");
      return APIStatus.success;
    } else {
      throw Exception(
          '[FLUTTER] Failed to buy $numberOfShares shares of watch $watchID');
    }
  } catch (e) {
    return APIStatus.error;
  }
}

Future<List<MarketPlaceWatch>> getMarketPlaceWatches(int pageNumber, int watchPerPage) async {
  try {
    final url = Uri.parse('$apiURL/marketplace/watches')
        .replace(queryParameters: {
      'pageNumber': pageNumber.toString(),
      'watchPerPage': watchPerPage.toString(),
    });

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => MarketPlaceWatch.fromJson(e)).toList();
    } else {
      throw Exception('[FLUTTER] Failed to load market place watches');
    }
  } catch (e) {
    throw Exception('[FLUTTER] Error retrieving market place watches: $e');
  }
}

Future<List<Trade>> getTradeHistory(int userID) async {
  try {
    final response = await http.get(
      Uri.parse('$apiURL/trade/history/$userID'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Trade.fromJson(e)).toList();
    } else {
      throw Exception('[FLUTTER] Failed to load trade history');
    }
  } catch (e) {
    throw Exception('[FLUTTER] Error retrieving trade history: $e');
  }
}

Future<List<MySharesOnSale>> getMySharesOnSale(int userID, int pageNumber, int watchPerPage) async {
  try {
    final response = await http.get(
      Uri.parse('$apiURL/trade/onsale/$userID?page=$pageNumber&perPage=$watchPerPage'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => MySharesOnSale.fromJson(e)).toList();
    } else {
      throw Exception('[FLUTTER] Failed to load trade history');
    }
  } catch (e) {
    throw Exception('[FLUTTER] Error retrieving trade history: $e');
  }
}

Future<List<Favorite>> getFavorites(int userID) async {
  try {
    final response = await http.get(
      Uri.parse('$apiURL/wallet/favorites/$userID'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Favorite.fromJson(e)).toList();
    } else {
      throw Exception('[FLUTTER] Failed to load favorites');
    }
  } catch (e) {
    throw Exception('[FLUTTER] Error retrieving favorites: $e');
  }
}

Future<APIStatus> updateSharesOnSale(int watchId, int userId, double oldPrice,
    double newPrice, int numberOfShares) async {
  try {
    Map<String, dynamic> requestBody = {
      'oldPrice': oldPrice.toString(),
      'newPrice': newPrice.toString(),
      'numberOfShares': numberOfShares,
    };

    final response = await http.put(
      Uri.parse('$apiURL/trade/onsale/$watchId/$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      return APIStatus.success;
    } else {
      return APIStatus.error;
    }
  } catch (e) {
    throw Exception('[FLUTTER] Error updating shares on sale: $e');
  }
}

Future<bool> getFavorite(int userID, int watchID) async {
  try {
    final response = await http.get(
      Uri.parse('$apiURL/wallet/favorite/$userID/$watchID'),
    );

    if (response.statusCode == 200) {
      final dynamic data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('[FLUTTER] Failed to load favorite');
    }
  } catch (e) {
    throw Exception('[FLUTTER] Error retrieving favorite: $e');
  }
}

Future<APIStatus> addToFavourite(int userID, int watchID) async {
  try {
    final response = await http.post(
      Uri.parse('$apiURL/wallet/favorite/$userID/$watchID'),
    );

    if (response.statusCode == 201) {
      // ignore: avoid_print
      print("SUCCESS ADDING WATCH TO FAVOURITE");
      return APIStatus.success;
    } else {
      throw Exception(
          '[FLUTTER] Failed to adding watch $watchID to favourites');
    }
  } catch (e) {
    throw Exception('[FLUTTER] Error adding to favourites');
  }
}

Future<APIStatus> removeFromFavourite(int userID, int watchID) async {
  try {
    final response = await http.delete(
      Uri.parse('$apiURL/wallet/favorite/$userID/$watchID'),
    );

    if (response.statusCode == 200) {
      // ignore: avoid_print
      print("SUCCESS REMOVING WATCH FROM FAVOURITE");
      return APIStatus.success;
    } else {
      throw Exception(
          '[FLUTTER] Failed removing watch $watchID from favourites');
    }
  } catch (e) {
    throw Exception('[FLUTTER] Error removing from favourites');
  }
}
