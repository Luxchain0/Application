class BuyInfo {
  final int watchid;
  final String brandName;
  final String modelName;
  final double actualPrice;
  final double proposalPrice;
  final int sharesOnSale;
  final int numberOfShares;
  final Future<String> image;

  const BuyInfo({
    required this.watchid,
    required this.brandName,
    required this.modelName,
    required this.actualPrice,
    required this.proposalPrice,
    required this.sharesOnSale,
    required this.numberOfShares,
    required this.image,
  });
}

class SellInfo {
  final int watchid;
  final String brandName;
  final String modelName;
  final double actualPrice;
  final double proposalPrice;
  final int sharesOwned;
  final int numberOfShares;
  final Future<String> image;

  const SellInfo({
    required this.watchid,
    required this.brandName,
    required this.modelName,
    required this.actualPrice,
    required this.proposalPrice,
    required this.sharesOwned,
    required this.numberOfShares,
    required this.image,
  });
}

class ModifySharesOnSale {
  final int watchid;
  final String brandName;
  final String modelName;
  double proposalPrice;
  int onSaleAtPrice;
  final int sharesOwned;
  int sharesOnSale;
  final Future<String> image;

  ModifySharesOnSale({
    required this.watchid,
    required this.brandName,
    required this.modelName,
    required this.proposalPrice,
    required this.onSaleAtPrice,
    required this.sharesOwned,
    required this.sharesOnSale,
    required this.image,
  });

  increaseShareOnSale() {
    if (sharesOnSale < sharesOwned) {
      onSaleAtPrice++;
      sharesOnSale++;
      return true;
    } else {
      throw ArgumentError(
          'Non puoi mettere in vendita più azioni di quante ne possiedi.');
    }
  }

  decreaseShareOnSale() {
    if (sharesOnSale > 0) {
      onSaleAtPrice--;
      sharesOnSale--;
      return true;
    } else {
      throw ArgumentError('Non puoi mettere in vendita meno di 0 azioni.');
    }
  }

  setProposalPrice(String controller) {
    if (controller.contains(',')) {
      var splitted = controller.split(',');
      String corretto = ('${splitted[0]}.${splitted[1][0]}${splitted[1][1]}');
      double number = double.parse(corretto);
      proposalPrice = number;
    } else {
      double number = double.parse(controller);
      proposalPrice = number;
    }
  }
}

class WatchScreenArguments {
  final int watchID;
  final int ownedShares;
  final double rate;

  WatchScreenArguments(this.watchID, this.ownedShares, this.rate);
}
