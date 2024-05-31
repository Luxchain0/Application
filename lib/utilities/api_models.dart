import 'package:lux_chain/utilities/utils.dart';

enum APIStatus {
  success,
  error,
}

class Model {
  final int modelid;
  final String modelname;
  final String brandname;

  const Model({
    required this.modelid,
    required this.modelname,
    required this.brandname,
  });

  factory Model.fromJson(Map<String, dynamic> json) {
    return Model(
      modelid: json['modelid'] as int,
      modelname: json['modelname'] as String,
      brandname: json['brandname'] as String,
    );
  }
}

class ModelType {
  final int modeltypeid;
  final String reference;
  final String braceletmaterial;
  final String casematerial;
  final String diameter;

  final int modelid;
  final Model model;

  const ModelType({
    required this.modeltypeid,
    required this.reference,
    required this.braceletmaterial,
    required this.casematerial,
    required this.diameter,
    required this.modelid,
    required this.model,
  });

  factory ModelType.fromJson(Map<String, dynamic> json) {
    return ModelType(
      modeltypeid: json['modeltypeid'] as int,
      reference: json['reference'] as String,
      braceletmaterial: json['braceletmaterial'] as String,
      casematerial: json['casematerial'] as String,
      diameter: json['diameter'] as String,
      modelid: json['modelid'] as int,
      model: Model.fromJson(json['model'] as Map<String, dynamic>),
    );
  }
}

class ShareOnSale {
  final double price;
  final int shareCount;

  const ShareOnSale({
    required this.price,
    required this.shareCount,
  });

  factory ShareOnSale.fromJson(Map<String, dynamic> json) {
    return ShareOnSale(
      price: customDoubleParser(json['price']),
      shareCount: json['shareCount'] as int,
    );
  }
}

class WalletWatch extends Watch {
  final int owned;
  final double increaseRate;

  const WalletWatch({
    required watchId,
    required condition,
    required numberOfShares,
    required retailPrice,
    required initialPrice,
    required actualPrice,
    required dialcolor,
    required year,
    required imageuri,
    required description,
    required modelTypeId,
    required modelType,
    required this.owned,
    required this.increaseRate,
  }) : super(
          watchId: watchId,
          condition: condition,
          numberOfShares: numberOfShares,
          retailPrice: retailPrice,
          initialPrice: initialPrice,
          actualPrice: actualPrice,
          dialcolor: dialcolor,
          year: year,
          imageuri: imageuri,
          description: description,
          modelTypeId: modelTypeId,
          modelType: modelType,
        );

  factory WalletWatch.fromJson(Map<String, dynamic> json) {
    return WalletWatch(
      watchId: json['watchid'] as int,
      condition: json['condition'] as String,
      numberOfShares: json['numberofshares'] as int,
      retailPrice: double.parse(json['retailprice'] as String),
      initialPrice: double.parse(json['initialprice'] as String),
      actualPrice: double.parse(json['actualprice'] as String),
      dialcolor: json['dialcolor'] as String,
      year: json['year'] as int,
      imageuri: json['imageuri'] as String,
      description: json['description'] as String,
      modelTypeId: json['modeltypeid'] as int,
      modelType: ModelType.fromJson(json['modeltype'] as Map<String, dynamic>),
      owned: json['owned'] as int,
      increaseRate: customDoubleParser(json['increaseRate']),
    );
  }
}

class Watch {
  final int watchId;
  final String condition;
  final int numberOfShares;
  final double retailPrice;
  final double initialPrice;
  final double actualPrice;
  final String dialcolor;
  final int year;
  final String imageuri;
  final String description;
  final int modelTypeId;
  final ModelType modelType;

  const Watch({
    required this.watchId,
    required this.condition,
    required this.numberOfShares,
    required this.retailPrice,
    required this.initialPrice,
    required this.actualPrice,
    required this.dialcolor,
    required this.year,
    required this.imageuri,
    required this.description,
    required this.modelTypeId,
    required this.modelType,
  });

  factory Watch.fromJson(Map<String, dynamic> json) {
    return Watch(
      watchId: json['watchid'] as int,
      condition: json['condition'] as String,
      numberOfShares: json['numberofshares'] as int,
      retailPrice: double.parse(json['retailprice'] as String),
      initialPrice: double.parse(json['initialprice'] as String),
      actualPrice: double.parse(json['actualprice'] as String),
      dialcolor: json['dialcolor'] as String,
      year: json['year'] as int,
      imageuri: json['imageuri'] as String,
      description: json['description'] as String,
      modelTypeId: json['modeltypeid'] as int,
      modelType: ModelType.fromJson(json['modeltype'] as Map<String, dynamic>),
    );
  }
}

class WatchAdditionalData {
  final int sharesOwned;
  final double increaseRate;

  const WatchAdditionalData({
    required this.sharesOwned,
    required this.increaseRate,
  });

  factory WatchAdditionalData.fromJson(Map<String, dynamic> json) {
    return WatchAdditionalData(
      sharesOwned: json['owned'] as int,
      increaseRate: customDoubleParser(json['increaseRate'] as num),
    );
  }
}

class WalletData {
  final double liquidity;
  final double inShares;
  final double rate;

  const WalletData({
    required this.liquidity,
    required this.inShares,
    required this.rate,
  });

  factory WalletData.fromJson(Map<String, dynamic> json) {
    return WalletData(
      liquidity: customDoubleParser(json['liquidity'] as num),
      inShares: customDoubleParser(json['inShares'] as num),
      rate: customDoubleParser(json['rate'] as num),
    );
  }
}

class MarketPlaceWatch extends Watch {
  final int sharesOnSale;
  final double rateOnPlatform;

  const MarketPlaceWatch({
    required int watchId,
    required String condition,
    required int numberOfShares,
    required double retailPrice,
    required double initialPrice,
    required double actualPrice,
    required String dialcolor,
    required int year,
    required String imageuri,
    required String description,
    required int modelTypeId,
    required ModelType modelType,
    required this.sharesOnSale,
    required this.rateOnPlatform,
  }) : super(
          watchId: watchId,
          condition: condition,
          numberOfShares: numberOfShares,
          retailPrice: retailPrice,
          initialPrice: initialPrice,
          actualPrice: actualPrice,
          dialcolor: dialcolor,
          year: year,
          imageuri: imageuri,
          description: description,
          modelTypeId: modelTypeId,
          modelType: modelType,
        );

  factory MarketPlaceWatch.fromJson(Map<String, dynamic> json) {
    return MarketPlaceWatch(
      watchId: json['watchid'] as int,
      condition: json['condition'] as String,
      numberOfShares: json['numberofshares'] as int,
      retailPrice: double.parse(json['retailprice'] as String),
      initialPrice: double.parse(json['initialprice'] as String),
      actualPrice: double.parse(json['actualprice'] as String),
      dialcolor: json['dialcolor'] as String,
      year: json['year'] as int,
      imageuri: json['imageuri'] as String,
      description: json['description'] as String,
      modelTypeId: json['modeltypeid'] as int,
      modelType: ModelType.fromJson(json['modeltype'] as Map<String, dynamic>),
      sharesOnSale: json['sharesOnSale'] as int,
      rateOnPlatform: customDoubleParser(json['increaseRate'] as num),
    );
  }
}

class Trade extends Watch {
  final double price;
  final int sharesTraded;
  final int yearOfTrade;
  final int dayOfTrade;
  final String type;

  Trade({
    required watchId,
    required condition,
    required numberOfShares,
    required retailPrice,
    required initialPrice,
    required actualPrice,
    required dialColor,
    required year,
    required imageuri,
    required description,
    required modelTypeId,
    required reference,
    required braceletMaterial,
    required caseMaterial,
    required diameter,
    required modelId,
    required modelName,
    required brandName,
    required this.price,
    required this.sharesTraded,
    required this.yearOfTrade,
    required this.dayOfTrade,
    required this.type,
  }) : super(
          watchId: watchId,
          condition: condition,
          numberOfShares: numberOfShares,
          retailPrice: retailPrice,
          initialPrice: initialPrice,
          actualPrice: actualPrice,
          dialcolor: dialColor,
          year: year,
          imageuri: imageuri,
          description: description,
          modelTypeId: modelTypeId,
          modelType: ModelType(
            modeltypeid: modelTypeId,
            reference: reference,
            braceletmaterial: braceletMaterial,
            casematerial: caseMaterial,
            diameter: diameter,
            modelid: modelId,
            model: Model(
              modelid: modelId,
              modelname: modelName,
              brandname: brandName,
            ),
          ),
        );

  factory Trade.fromJson(Map<String, dynamic> json) {
    return Trade(
      watchId: json['watchid'] as int,
      condition: json['condition'] as String,
      numberOfShares: json['numberofshares'] as int,
      retailPrice: customDoubleParser(json['retailprice'] as num),
      initialPrice: double.parse(json['initialprice'] as String),
      actualPrice: double.parse(json['actualprice'] as String),
      dialColor: json['dialcolor'] as String,
      year: json['year'] as int,
      imageuri: json['imageuri'] as String,
      description: json['description'] as String,
      modelTypeId: json['modeltypeid'] as int,
      reference: json['reference'] as String,
      braceletMaterial: json['braceletmaterial'] as String,
      caseMaterial: json['casematerial'] as String,
      diameter: json['diameter'] as String,
      modelId: json['modelid'] as int,
      modelName: json['modelname'] as String,
      brandName: json['brandname'] as String,
      price: double.parse(json['price'] as String),
      sharesTraded: json['sharestraded'] as int,
      yearOfTrade: json['yearoftrade'] as int,
      dayOfTrade: json['dayoftrade'] as int,
      type: json['type'] as String,
    );
  }
}

class MySharesOnSale extends Watch {
  final double price;
  final int onSaleAtPrice;
  final int sharesOwned;
  final int sharesOnSale;

  MySharesOnSale({
    required watchId,
    required condition,
    required numberOfShares,
    required retailPrice,
    required initialPrice,
    required actualPrice,
    required dialColor,
    required year,
    required imageuri,
    required description,
    required modelTypeId,
    required reference,
    required braceletMaterial,
    required caseMaterial,
    required diameter,
    required modelId,
    required modelName,
    required brandName,
    required this.price,
    required this.onSaleAtPrice,
    required this.sharesOwned,
    required this.sharesOnSale,
  }) : super (
    watchId: watchId,
    condition: condition,
    numberOfShares: numberOfShares,
    retailPrice: retailPrice,
    initialPrice: initialPrice,
    actualPrice: actualPrice,
    dialcolor: dialColor,
    year: year,
    imageuri: imageuri,
    description: description,
    modelTypeId: modelTypeId,
    modelType: ModelType(
      modeltypeid: modelTypeId,
      reference: reference,
      braceletmaterial: braceletMaterial,
      casematerial: caseMaterial,
      diameter: diameter,
      modelid: modelId,
      model: Model(
        modelid: modelId,
        modelname: modelName,
        brandname: brandName,
      ),
    ),

  );

  factory MySharesOnSale.fromJson(Map<String, dynamic> json) {
    return MySharesOnSale(
      watchId: json['watchid'] as int,
      condition: json['condition'] as String,
      numberOfShares: json['numberofshares'] as int,
      retailPrice: double.parse(json['retailprice'] as String),
      initialPrice: double.parse(json['initialprice'] as String),
      actualPrice: double.parse(json['actualprice'] as String),
      dialColor: json['dialcolor'] as String,
      year: json['year'] as int,
      imageuri: json['imageuri'] as String,
      description: json['description'] as String,
      modelTypeId: json['modeltypeid'] as int,
      reference: json['reference'] as String,
      braceletMaterial: json['braceletmaterial'] as String,
      caseMaterial: json['casematerial'] as String,
      diameter: json['diameter'] as String,
      modelId: json['modelid'] as int,
      modelName: json['modelname'] as String,
      brandName: json['brandname'] as String,
      price: double.parse(json['price'] as String),
      onSaleAtPrice: json['onsaleatprice'] as int,
      sharesOwned: json['sharesowned'] as int,
      sharesOnSale: json['sharesonsale'] as int,
    );
  }
}

class Favorite {
  final int favoriteid;
  final int watchid;
  final int accountid;
  final Watch watch;

  const Favorite({
    required this.favoriteid,
    required this.watchid,
    required this.accountid,
    required this.watch,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      favoriteid: json['favoriteid'] as int,
      watchid: json['watchid'] as int,
      accountid: json['accountid'] as int,
      watch: Watch.fromJson(json['watch'] as Map<String, dynamic>),
    );
  }
}
