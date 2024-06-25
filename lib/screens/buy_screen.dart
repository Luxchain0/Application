import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lux_chain/utilities/api_calls.dart';
import 'package:lux_chain/utilities/api_models.dart';
import 'package:lux_chain/utilities/frame.dart';
import 'package:lux_chain/utilities/models.dart';
import 'package:lux_chain/utilities/size_config.dart';
import 'package:lux_chain/utilities/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BuyScreen extends StatefulWidget {
  static const String id = 'BuyScreen';
  final BuyInfo buyInfo;

  const BuyScreen({required this.buyInfo, super.key});

  @override
  // ignore: no_logic_in_create_state
  State<BuyScreen> createState() => _BuyScreenState(buyInfo: buyInfo);
}

class _BuyScreenState extends State<BuyScreen> {
  final BuyInfo buyInfo;
  int _shareSelected = 0;
  double _moneyInTheWallet = 0.0;
  bool _isButtonBuyAbled = false;

  _BuyScreenState({required this.buyInfo});

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() async {
    Future<SharedPreferences> userFuture = getUserData();
    SharedPreferences user = await userFuture;

    int userId = user.getInt('accountid') ?? 0;

    getWalletData(userId).then((walletData) {
      setState(() {
        _moneyInTheWallet = walletData.liquidity;
      });
    });
  }

  doesTheUserHaveEnoughMoney() {
    return (_shareSelected <= buyInfo.numberOfShares &&
            _shareSelected > 0 && _shareSelected <= maxQuotes &&
            (_shareSelected * buyInfo.proposalPrice) <= _moneyInTheWallet)
        ? setState(() {
            _isButtonBuyAbled = true;
          })
        : _isButtonBuyAbled = false;
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
              margin: const EdgeInsets.only(left: 7),
              child: const Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  handleBuy() async {
    // ignore: avoid_print
    print("BUYING");

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text(
            'This action will irreversibly buy the selected shares.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Nope'),
          ),
          TextButton(
            onPressed: () async {
              showLoaderDialog(context);
              Future<SharedPreferences> userFuture = getUserData();
              SharedPreferences user = await userFuture;
              int userId = user.getInt('accountid') ?? 0;
              var result = await buyShares(userId, buyInfo.watchid,
                  _shareSelected, buyInfo.proposalPrice);
              if (APIStatus.success == result) {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamedAndRemoveUntil(
                                    context, FrameScreen.id, (_) => false);
                              },
                              child: const Text('Close'),
                            ),
                          ],
                          title: const Text('Successful payment'),
                          contentPadding: const EdgeInsets.all(20.0),
                          content: const Text(
                              'The shares have been correctly added to your wallet'),
                        ));
              } else {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamedAndRemoveUntil(
                                    context, FrameScreen.id, (_) => false);
                              },
                              child: const Text('Close'),
                            ),
                          ],
                          title: const Text('Warning'),
                          contentPadding: const EdgeInsets.all(20.0),
                          content: const Text(
                              'Something went wrong. Try to redo the operations. If the problem consist contuct us.'),
                        ));
              }
            },
            child: const Text('Yep'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double heigh = SizeConfig.screenH!;
    double width = SizeConfig.screenW!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(width),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.05, vertical: heigh * 0.025),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Buy',
                  style: TextStyle(
                      color: Colors.black87,
                      height: 1,
                      fontSize: width * 0.1,
                      fontFamily: 'Bebas'),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: heigh * 0.018),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black26,
                        width: 1,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(7))),
                  alignment: Alignment.center, // This is needed
                  child: FutureBuilder<String>(
                    future: buyInfo.image,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasData) {
                        return ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(7)),
                          child: Image.network(
                            snapshot.data!,
                            fit: BoxFit
                                .cover, // L'immagine si espanderà per riempire il contenitore
                          ),
                        );
                      } else {
                        return const Icon(Icons.error);
                      }
                    },
                  ),
                ),
                Text(
                  buyInfo.brandName,
                  style: TextStyle(
                      color: Colors.black38,
                      height: 1,
                      fontSize: width * 0.07,
                      fontFamily: 'Bebas'),
                ),
                Text(
                  buyInfo.modelName,
                  style: TextStyle(
                      color: Colors.black87,
                      height: 1,
                      fontSize: width * 0.08,
                      fontFamily: 'Bebas'),
                ),
                SizedBox(
                  height: heigh * 0.02,
                ),
                Text('Shares on sale at this price: ${buyInfo.numberOfShares}'),
                Text(
                    'Price for one share: ${formatAmountFromDouble(buyInfo.proposalPrice)}'),
                SizedBox(
                  height: heigh * 0.004,
                ),
                Text('Total shares on sale of this watch: ${buyInfo.sharesOnSale}'),
                Text(
                    'Actual Price of the watch: ${formatAmountFromDouble(buyInfo.actualPrice)}'),
                SizedBox(
                  height: heigh * 0.03,
                ),
                const Text('Buying more than 30 shares at once is not allowed. If you want to buy more than 30 shares please repeat the transaction more than once.'),
                SizedBox(
                  height: heigh * 0.03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: width * 0.4,
                      height: heigh * 0.04,
                      child: TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          autofocus: false,
                          style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black87),
                          decoration: InputDecoration(
                            hintText: 'N° of shares',
                            contentPadding: const EdgeInsets.fromLTRB(
                                20.0, 10.0, 20.0, 10.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0)),
                          ),
                          onChanged: (value) => {
                                setState(() {
                                  if (value.isEmpty) {
                                    _shareSelected = 0;
                                  } else {
                                    _shareSelected = int.parse(value);
                                  }
                                  doesTheUserHaveEnoughMoney();
                                })
                              }),
                    ),
                    Text(
                      'Total: ${formatAmountFromDouble(_shareSelected * buyInfo.proposalPrice)}',
                      style: TextStyle(
                          fontSize: heigh * 0.023, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _shareSelected > 30 ?
                    const Text(
                      '  Too many shares!',
                      style: TextStyle(
                        color: Color.fromARGB(255, 176, 55, 46),
                      ),
                    )
                    : const Text(''),
                    OutlinedButton(
                      onPressed: _isButtonBuyAbled ? () => handleBuy() : null,
                      style: _isButtonBuyAbled
                          ? ButtonStyle(
                              backgroundColor: const MaterialStatePropertyAll(
                                  Colors.blueAccent),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              minimumSize: MaterialStateProperty.all<Size>(
                                  Size(width * 0.25, width * 0.08)))
                          : ButtonStyle(
                              backgroundColor: const MaterialStatePropertyAll(
                                  Color.fromARGB(101, 68, 68, 68)),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              minimumSize: MaterialStateProperty.all<Size>(
                                  Size(width * 0.25, width * 0.08))),
                      child: const Text(
                        'Buy',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
