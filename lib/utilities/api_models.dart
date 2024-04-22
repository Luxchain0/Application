class Favorite {
  final int favoriteid;
  final int watchid;
  final int userid;

  const Favorite({
    required this.favoriteid,
    required this.watchid,
    required this.userid,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      favoriteid: json['favoriteid'] as int,
      watchid: json['watchid'] as int,
      userid: json['userid'] as int,
    );
  }
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
  final String braceletmaterial;
  final String casematerial;
  final String dialcolor;
  final int diameter;
  final int year;
  final String imageuri;
  final int modelid;
  final Model model;

  const ModelType({
    required this.modeltypeid,
    required this.braceletmaterial,
    required this.casematerial,
    required this.dialcolor,
    required this.diameter,
    required this.year,
    required this.imageuri,
    required this.modelid,
    required this.model,
  });

  factory ModelType.fromJson(Map<String, dynamic> json) {
    return ModelType(
      modeltypeid: json['modeltypeid'] as int,
      braceletmaterial: json['braceletmaterial'] as String,
      casematerial: json['casematerial'] as String,
      dialcolor: json['dialcolor'] as String,
      diameter: json['diameter'] as int,
      year: json['year'] as int,
      imageuri: json['imageuri'] as String,
      modelid: json['modelid'] as int,
      model: Model.fromJson(json['model'] as Map<String, dynamic>),
    );
  }
}

class OnSale {
  final int onsaleid;
  final int price;
  final int shareid;
  final int userid;

  const OnSale({
    required this.onsaleid,
    required this.price,
    required this.shareid,
    required this.userid,
  });

  factory OnSale.fromJson(Map<String, dynamic> json) {
    return OnSale(
      onsaleid: json['onsaleid'] as int,
      price: json['price'] as int,
      shareid: json['shareid'] as int,
      userid: json['userid'] as int,
    );
  }
}

class Share {
  final int shareid;
  final int watchid;
  final int userid;

  const Share({
    required this.shareid,
    required this.watchid,
    required this.userid,
  });

  factory Share.fromJson(Map<String, dynamic> json) {
    return Share(
      shareid: json['shareid'] as int,
      watchid: json['watchid'] as int,
      userid: json['userid'] as int,
    );
  }
}

class Trade {
  final int tradeid;
  final int price;
  final DateTime tradetime;
  final int shareid;
  final int buyerid;
  final int sellerid;

  const Trade({
    required this.tradeid,
    required this.price,
    required this.tradetime,
    required this.shareid,
    required this.buyerid,
    required this.sellerid,
  });

  factory Trade.fromJson(Map<String, dynamic> json) {
    return Trade(
      tradeid: json['tradeid'] as int,
      price: json['price'] as int,
      tradetime: DateTime.parse(json['tradetime'] as String),
      shareid: json['shareid'] as int,
      buyerid: json['buyerid'] as int,
      sellerid: json['sellerid'] as int,
    );
  }
}

class UserProfile {
  final int userid;
  final String username;
  final String firstname;
  final String lastname;
  final DateTime birthdate;
  final String birthcountry;
  final String nationality;
  final String address;
  final String phonenr;
  final String email;
  final DateTime registrationtime;
  final String govid;

  const UserProfile({
    required this.userid,
    required this.username,
    required this.firstname,
    required this.lastname,
    required this.birthdate,
    required this.birthcountry,
    required this.nationality,
    required this.address,
    required this.phonenr,
    required this.email,
    required this.registrationtime,
    required this.govid,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userid: json['userid'] as int,
      username: json['username'] as String,
      firstname: json['firstname'] as String,
      lastname: json['lastname'] as String,
      birthdate: DateTime.parse(json['birthdate'] as String),
      birthcountry: json['birthcountry'] as String,
      nationality: json['nationality'] as String,
      address: json['address'] as String,
      phonenr: json['phonenr'] as String,
      email: json['email'] as String,
      registrationtime: DateTime.parse(json['registrationtime'] as String),
      govid: json['govid'] as String,
    );
  }
}

class WalletHistory {
  final int wallethistoryid;
  final DateTime wallettime;
  final int amount;
  final int userid;

  const WalletHistory({
    required this.wallethistoryid,
    required this.wallettime,
    required this.amount,
    required this.userid,
  });

  factory WalletHistory.fromJson(Map<String, dynamic> json) {
    return WalletHistory(
      wallethistoryid: json['wallethistoryid'] as int,
      wallettime: DateTime.parse(json['wallettime'] as String),
      amount: json['amount'] as int,
      userid: json['userid'] as int,
    );
  }
}

class WantToBuy {
  final int wanttobuyid;
  final int price;
  final int shareid;
  final int userid;

  const WantToBuy({
    required this.wanttobuyid,
    required this.price,
    required this.shareid,
    required this.userid,
  });

  factory WantToBuy.fromJson(Map<String, dynamic> json) {
    return WantToBuy(
      wanttobuyid: json['wanttobuyid'] as int,
      price: json['price'] as int,
      shareid: json['shareid'] as int,
      userid: json['userid'] as int,
    );
  }
}

class WalletWatch {
  final int watchid;
  final String condition;
  final int numberofshares;
  final double initialprice;
  final double actualprice;
  final int modeltypeid;
  final ModelType modeltype;
  final int owned;

  const WalletWatch({
    required this.watchid,
    required this.condition,
    required this.numberofshares,
    required this.initialprice,
    required this.actualprice,
    required this.modeltypeid,
    required this.modeltype,
    required this.owned,
  });

  factory WalletWatch.fromJson(Map<String, dynamic> json) {
    return WalletWatch(
      watchid: json['watchid'] as int,
      condition: json['condition'] as String,
      numberofshares: json['numberofshares'] as int,
      initialprice: double.parse(json['initialprice'] as String),
      actualprice: double.parse(json['actualprice'] as String),
      modeltypeid: json['modeltypeid'] as int,
      modeltype: ModelType.fromJson(json['modeltype'] as Map<String, dynamic>),
      owned: json['owned'] as int,
    );
  }
}

class Watch {
  final int watchId;
  final String condition;
  final int numberOfShares;
  final double initialPrice;
  final double actualPrice;
  final int modelTypeId;
  final ModelType modelType;

  const Watch({
    required this.watchId,
    required this.condition,
    required this.numberOfShares,
    required this.initialPrice,
    required this.actualPrice,
    required this.modelTypeId,
    required this.modelType,
  });

  factory Watch.fromJson(Map<String, dynamic> json) {
    return Watch(
      watchId: json['watchid'] as int,
      condition: json['condition'] as String,
      numberOfShares: json['numberofshares'] as int,
      initialPrice: double.parse(json['initialprice'] as String),
      actualPrice: double.parse(json['actualprice'] as String),
      modelTypeId: json['modeltypeid'] as int,
      modelType: ModelType.fromJson(json['modeltype'] as Map<String, dynamic>),
    );
  }
}

class WalletData {
  final double liquidity;
  final int inShares; // TODO: modify this to be a double
  final int rate;

  const WalletData({
    required this.liquidity,
    required this.inShares,
    required this.rate,
  });

  factory WalletData.fromJson(Map<String, dynamic> json) {
    return WalletData(
      liquidity: json['liquidity'] as double,
      inShares: json['inShares'] as int,
      rate: json['rate'] as int,
    );
  }
}
