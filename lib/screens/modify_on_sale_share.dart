import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'package:lux_chain/utilities/api_calls.dart';
import 'package:lux_chain/utilities/api_models.dart';
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
  final myController = TextEditingController();
  late int onSaleAtPrice;

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    modifySharesOnSale = widget.modifySharesOnSale;
    onSaleAtPrice = modifySharesOnSale.onSaleAtPrice;
  }

  Future<void> _saveChanges() async {
    // ignore: avoid_print
    print("SAVING");
    var result = await updateSharesOnSale(
      modifySharesOnSale.watchid, // watchId
      1, // TODO: get this
      modifySharesOnSale.proposalPrice, // oldPrice
      modifySharesOnSale.proposalPrice, // newPrice
      modifySharesOnSale.onSaleAtPrice, // numberOfShares
    );
    if (APIStatus.success == result) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, FrameScreen.id);
                    },
                    child: const Text('Close'),
                  ),
                ],
                contentPadding: const EdgeInsets.all(20.0),
                content: Text(
                    'La modifica delle quote in vendita è andata a buon fine'),
              ));
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Close'),
                  ),
                ],
                title: const Text('Messaggio di info'),
                contentPadding: const EdgeInsets.all(20.0),
                content: Text('OOps. Qualcosa è andato storto'),
              ));
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Modifica',
                    style: TextStyle(
                        color: Colors.black87,
                        height: 1,
                        fontSize: width * 0.1,
                        fontFamily: 'Bebas'),
                  ),
                  OutlinedButton(
                    onPressed: () => {
                      if (myController.text != '')
                        {
                          modifySharesOnSale
                              .setProposalPrice(myController.text),
                        },
                      _saveChanges(),
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            const MaterialStatePropertyAll(Colors.blueAccent),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        minimumSize: MaterialStateProperty.all<ui.Size>(
                            ui.Size(width * 0.25, width * 0.08))),
                    child: const Text(
                      'Salva',
                    ),
                  ),
                ],
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
              SizedBox(
                height: heigh * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text("Quote in vendita:"),
                  SizedBox(
                    width: width * 0.03,
                  ),
                  GestureDetector(
                    onTap: () => {
                      if (modifySharesOnSale.sharesOnSale > 0)
                        {
                          if (modifySharesOnSale.decreaseShareOnSale())
                            {
                              setState(() {
                                onSaleAtPrice--;
                              }),
                            }
                        }
                      else
                        {null}
                    },
                    child: CircleAvatar(
                      radius: width * 0.04,
                      backgroundColor: const Color.fromARGB(228, 118, 196, 241),
                      child: Text('-'),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.03,
                  ),
                  Text("${modifySharesOnSale.onSaleAtPrice}"),
                  SizedBox(
                    width: width * 0.03,
                  ),
                  GestureDetector(
                    onTap: () => {
                      if (modifySharesOnSale.sharesOnSale <
                          modifySharesOnSale.sharesOwned)
                        {
                          if (modifySharesOnSale.increaseShareOnSale())
                            {
                              setState(() {
                                onSaleAtPrice++;
                              }),
                            }
                        }
                      else
                        {null}
                    },
                    child: CircleAvatar(
                      radius: width * 0.04,
                      backgroundColor: const Color.fromARGB(226, 102, 176, 255),
                      child: Text('+'),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: heigh * 0.02,
              ),
              Row(
                children: [
                  Text('Prezzo di vendita:'),
                  SizedBox(
                    width: width * 0.02,
                  ),
                  Container(
                    width: width * 0.3,
                    child: TextField(
                      controller: myController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+([.,]\d+)?')), //TODO
                      ],
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 1, horizontal: 15),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(226, 102, 176, 255)),
                          borderRadius: BorderRadius.circular(5.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white10,
                          ),
                        ),
                        filled: true,
                        fillColor: Color.fromARGB(31, 102, 176, 255),
                        labelText: formatAmountFromDouble(
                            modifySharesOnSale.proposalPrice),
                        labelStyle: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.02,
                  ),
                  Text('€'),
                ],
              ),
              SizedBox(
                height: heigh * 0.02,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
