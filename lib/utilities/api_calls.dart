import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lux_chain/utilities/api_models.dart';
import 'package:lux_chain/utilities/frame.dart';
import 'package:lux_chain/utilities/utils.dart';

Future<List<WalletWatch>> getUserWalletWatches(
    int userID, int pageNumber, int watchPerPage) async {
  try {
    // Costruisce l'URL con i parametri di query
    final url =
        Uri.parse('$baseUrl/wallet/watches/$userID').replace(queryParameters: {
      'pageNumber': pageNumber.toString(),
      'watchPerPage': watchPerPage.toString(),
    });

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
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

Future<WatchAdditionalData> getWatchAdditionalData(
    int userID, int watchID) async {
  try {
    // Retrieving all the additional information about the watch
    final response = await http.get(
      Uri.parse('$baseUrl/wallet/watch/$userID/$watchID'),
      headers: {
        'Authorization': 'Bearer $token',
      },
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
      Uri.parse('$baseUrl/shares/$userID'),
      headers: {
        'Authorization': 'Bearer $token',
      },
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
      Uri.parse('$baseUrl/watches/shares/$watchID'),
      headers: {
        'Authorization': 'Bearer $token',
      },
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
      Uri.parse('$baseUrl/shares/onSale/$userID'),
      headers: {
        'Authorization': 'Bearer $token',
      },
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

Future<List<ShareOnSale>> getSharesOfTheWatchOnSell(
    int watchID, int userID) async {
  try {
    // Retrieving all the on sale shares of a watch
    final response = await http.get(
      Uri.parse('$baseUrl/marketplace/watch/$watchID')
          .replace(queryParameters: {'userId': userID.toString()}),
      headers: {
        'Authorization': 'Bearer $token',
      },
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
      Uri.parse('$baseUrl/wallet/data/$userID'),
      headers: {
        'Authorization': 'Bearer $token',
      },
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
      Uri.parse('$baseUrl/trade/sell/$watchID/$userID'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
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
      Uri.parse('$baseUrl/trade/buy/$watchID/$userID'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      return APIStatus.success;
    } else {
      throw Exception(
          '[FLUTTER] Failed to buy $numberOfShares shares of watch $watchID');
    }
  } catch (e) {
    return APIStatus.error;
  }
}

Future<List<MarketPlaceWatch>> getMarketPlaceWatches(
    int pageNumber, int watchPerPage, String query, int userId) async {
  try {
    final Map<String, String> queryParams = {
      'pageNumber': pageNumber.toString(),
      'watchPerPage': watchPerPage.toString(),
      'userId': userId.toString(),
    };

    if (query.isNotEmpty) {
      queryParams['query'] = query;
    }

    final Uri url = Uri.parse('$baseUrl/marketplace/watches')
        .replace(queryParameters: queryParams);

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      List<MarketPlaceWatch> watches =
          data.map((e) => MarketPlaceWatch.fromJson(e)).toList();
      return watches;
    } else {
      throw Exception(
          '[FLUTTER] Failed to load market place watches: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('[FLUTTER] Error retrieving market place watches: $e');
  }
}

Future<List<Trade>> getTradeHistory(int userID) async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/trade/history/$userID'),
      headers: {
        'Authorization': 'Bearer $token',
      },
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

Future<List<MySharesOnSale>> getMySharesOnSale(
    int userID, int pageNumber, int watchPerPage) async {
  try {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/trade/onsale/$userID?pageNumber=$pageNumber&watchPerPage=$watchPerPage'),
      headers: {
        'Authorization': 'Bearer $token',
      },
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
      Uri.parse('$baseUrl/wallet/favorites/$userID'),
      headers: {
        'Authorization': 'Bearer $token',
      },
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
      'oldPrice': oldPrice,
      'newPrice': newPrice,
      'numberOfShares': numberOfShares,
    };

    final response = await http.put(
      Uri.parse('$baseUrl/trade/onsale/$watchId/$userId'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
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
      Uri.parse('$baseUrl/wallet/favorite/$userID/$watchID'),
      headers: {
        'Authorization': 'Bearer $token',
      },
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
      Uri.parse('$baseUrl/wallet/favorite/$userID/$watchID'),
      headers: {
        'Authorization': 'Bearer $token',
      },
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
      Uri.parse('$baseUrl/wallet/favorite/$userID/$watchID'),
      headers: {
        'Authorization': 'Bearer $token',
      },
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

Future<List<Candle>> getCandles(String timeFrame, int watchID, DateTime startDate, DateTime endDate) async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/graph/$timeFrame/$watchID'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Candle.fromJson(e)).toList();
    } else {
      throw Exception('[FLUTTER] Failed to load candles');
    }
  } catch (e) {
    throw Exception('[FLUTTER] Error retrieving candles: $e');
  }
}

Future<APIStatus> accessLog() async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/access'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return APIStatus.success;
    } else {
      return APIStatus.error;
    }
  } catch (e) {
    return APIStatus.error;
  }
}