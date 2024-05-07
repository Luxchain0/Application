import 'package:flutter/material.dart';
import 'package:lux_chain/utilities/api_calls.dart';
import 'package:lux_chain/utilities/frame.dart';
import 'package:lux_chain/utilities/models.dart';
import 'package:lux_chain/utilities/size_config.dart';
import 'package:lux_chain/utilities/utils.dart';

class ModifyOnSaleShareScreen extends StatefulWidget {
  static const String id = 'ModifyOnSaleShareScreen';
  final ModifySharesOnSale modifySharesOnSale;
  const ModifyOnSaleShareScreen({required this.modifySharesOnSale, super.key});

  @override
  State<ModifyOnSaleShareScreen> createState() =>
      _ModifyOnSaleShareScreenState();
}

class _ModifyOnSaleShareScreenState extends State<ModifyOnSaleShareScreen> {
  late ModifySharesOnSale modifySharesOnSale;

  @override
  void initState() {
    super.initState();
    modifySharesOnSale = widget.modifySharesOnSale;
  }

  Future<void> _saveChanges() async {
    try {
      await updateSharesOnSale(
        modifySharesOnSale.watchid, // watchId
        1, // TODO: get this
        modifySharesOnSale.proposalPrice, // oldPrice
        modifySharesOnSale.proposalPrice, // newPrice
        modifySharesOnSale.onSaleAtPrice, // numberOfShares
      );

      setState(() {});

    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Errore'),
              content: const Text(
                  'Si è verificato un errore durante il salvataggio delle modifiche.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Chiudi'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double heigh = SizeConfig.screenH!;
    double width = SizeConfig.screenW!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(width),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.05, vertical: heigh * 0.025),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                'Modifica',
                style: TextStyle(
                    color: Colors.black87,
                    height: 1,
                    fontSize: width * 0.1,
                    fontFamily: 'Bebas'),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: heigh * 0.02),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black26,
                      width: 1,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(7))),
                alignment: Alignment.center, // This is needed
                child: FutureBuilder<String>(
                  future: modifySharesOnSale.image,
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
                modifySharesOnSale.brandName,
                style: TextStyle(
                    color: Colors.black38,
                    height: 1,
                    fontSize: width * 0.07,
                    fontFamily: 'Bebas'),
              ),
              Text(
                modifySharesOnSale.modelName,
                style: TextStyle(
                    color: Colors.black87,
                    height: 1,
                    fontSize: width * 0.08,
                    fontFamily: 'Bebas'),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                    color: Colors.lightGreen),
                child: const Text('+ 2.3%'),
              ),
              SizedBox(
                height: heigh * 0.02,
              ),
              Text('Quote possedute: ${modifySharesOnSale.sharesOwned}'),
              Text(
                  'Quote possedute in vendita: ${modifySharesOnSale.sharesOnSale}'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Quote in vendita:"),
                  CircleAvatar(
                    radius: width * 0.05,
                    backgroundColor: const Color.fromARGB(228, 118, 196, 241),
                    child: IconButton(
                      icon: const Icon(
                        Icons.remove,
                        color: Colors.black,
                      ),
                      onPressed: modifySharesOnSale.sharesOnSale > 0 ? () {
                        modifySharesOnSale.decreaseShareOnSale();
                        _saveChanges();
                      } : null,
                    ),
                  ),
                  Text("${modifySharesOnSale.onSaleAtPrice}"),
                  CircleAvatar(
                    radius: width * 0.05,
                    backgroundColor: const Color.fromARGB(226, 102, 176, 255),
                    child: IconButton(
                      icon: const Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                      onPressed: modifySharesOnSale.sharesOnSale < modifySharesOnSale.sharesOwned ? () {
                        modifySharesOnSale.increaseShareOnSale();
                        _saveChanges();
                      } : null,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      'Prezzo di vendita: ' +
                    formatAmountFromDouble(modifySharesOnSale.proposalPrice) +
                    '€'),
                  OutlinedButton(
                    //TODO: migliorare look and feel
                    //TODO: quando viene cliccato il tasto edit, dove si inserisce la cifra?¯
                    onPressed: () => {},
                    style: ButtonStyle(
                        backgroundColor: const MaterialStatePropertyAll(
                          Color.fromARGB(226, 102, 176, 255),
                        ),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        minimumSize: MaterialStateProperty.all<Size>(
                            Size(width * 0.25, width * 0.08))),
                    child: const Text(
                      'Edit',
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: heigh * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => {},
                    style: ButtonStyle(
                        backgroundColor:
                            const MaterialStatePropertyAll(Colors.blueAccent),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        minimumSize: MaterialStateProperty.all<Size>(
                            Size(width * 0.25, width * 0.08))),
                    child: const Text(
                      'Salva',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
