import 'package:flutter/material.dart';
import 'package:lux_chain/utilities/frame.dart';
import 'package:lux_chain/utilities/size_config.dart';

class ModifyOnSaleShareScreen extends StatefulWidget {
  static const String id = 'ModifyOnSaleShareScreen';
  const ModifyOnSaleShareScreen({super.key});

  @override
  // ignore: no_logic_in_create_state
  State<ModifyOnSaleShareScreen> createState() => _ModifyOnSaleShareScreenState();
}

class _ModifyOnSaleShareScreenState extends State<ModifyOnSaleShareScreen> {

  @override
  void initState() {
    super.initState();
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
                child: Padding(
                  padding: EdgeInsets.all(heigh * 0.02),
                  child: Image.asset(
                    'assets/images/o1.jpg',
                    fit: BoxFit.contain,
                    height: heigh * 0.3,
                  ),
                ),
              ),
              Text(
                "BrandName",
                style: TextStyle(
                    color: Colors.black38,
                    height: 1,
                    fontSize: width * 0.07,
                    fontFamily: 'Bebas'),
              ),
              Text(
                "ModelName",
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
              const Text('Quote possedute: 5'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Quote in vendita:"),
                  CircleAvatar(
              radius: width*0.05,
              backgroundColor: Color.fromARGB(228, 118, 196, 241),
              child: IconButton(
                icon: Icon(
                  Icons.remove,
                  color: Colors.black,
                ),
                onPressed: () {
                  //TODO: controllo che il minimo raggiungibile sia 0
                },
              ),
            ),
            Text("4"),
            CircleAvatar(
              radius: width * 0.05,
              backgroundColor: Color.fromARGB(226, 102, 176, 255),
              child: IconButton(
                icon: Icon(
                  Icons.add,
                  color: Colors.black,
                ),
                onPressed: () {
                  //TODO: inserire controllo che il massimo non superi le quote possedute
                  //TODO: come gestire i diversi prezzi sullo stesso orologio? Bisogna trovare un modo per controllare tutte le quote
                },
              ),
            ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Prezzo di vendita: 12 344,54 €"),
                  OutlinedButton(
                    //TODO: migliorare look and feel
                    //TODO: quando viene cliccato il tasto edit, dove si inserisce la cifra?¯
                    onPressed: () => {},
                    style: ButtonStyle(
                        backgroundColor:
                            const MaterialStatePropertyAll(Color.fromARGB(226, 102, 176, 255),),
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
