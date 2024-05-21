import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:lux_chain/utilities/size_config.dart';

class DashboardExcelScreen extends StatefulWidget {
  static const String id = 'DashboardExcelScreen';
  const DashboardExcelScreen({super.key});

  @override
  // ignore: no_logic_in_create_state
  State<DashboardExcelScreen> createState() => _DashboardExcelScreenState();
}

class _DashboardExcelScreenState extends State<DashboardExcelScreen> {

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double heigh = SizeConfig.screenH!;
    double width = SizeConfig.screenW!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.05, vertical: heigh * 0.025),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                'Aggiungi orologi',
                style: TextStyle(
                    color: Colors.black87,
                    height: 1,
                    fontSize: width * 0.1,
                    fontFamily: 'Bebas'),
              ),
              Container(
                margin: EdgeInsets.only(top: heigh * 0.015), // This is needed
                child: Text('Per eseguire questa operazione correttamente l\'applicazione deve ricevere un foglio excel contenente dati in un formato ben preciso.'),
              ),
              SizedBox(height: heigh*0.035,),
              Text(
                '1. Scarica il modello',
                style: TextStyle(
                    color: Colors.black87,
                    height: 1,
                    fontSize: width * 0.06,
                    fontFamily: 'Bebas'),
              ),
              Text('Di seguito trovi il modello excel nel quale inserire i vari orologi e relativi dati.'),
              SizedBox(height: heigh*0.01,),
              OutlinedButton(
                onPressed: () => {},
                style: ButtonStyle(
                    backgroundColor:
                        const MaterialStatePropertyAll(Color.fromARGB(255, 23, 77, 169)),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    minimumSize: MaterialStateProperty.all<Size>(
                        Size(width * 0.25, width * 0.08))),
                child: const Text(
                  'Scarica foglio excel',
                ),
              ),
              SizedBox(height: heigh*0.035,),
              Text(
                '2. Carica il file excel',
                style: TextStyle(
                    color: Colors.black87,
                    height: 1,
                    fontSize: width * 0.06,
                    fontFamily: 'Bebas'),
              ),
              Text('Una volta riempito il file scaricato con i dati corretti caricalo qua sotto:'),
              SizedBox(height: heigh*0.03,),
              Container(
                margin: EdgeInsets.symmetric(horizontal: width*0.15),
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: Radius.circular(20),
                  dashPattern: [10, 10],
                  color: Colors.grey,
                  strokeWidth: 2,
                  child: Card(
                      color: Color.fromARGB(255, 203, 228, 253),
                      shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: heigh*0.05, bottom: heigh*0.01),
                            child: Icon(
                              Icons.upload_file_outlined,
                              size: heigh*0.08,
                            )
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: width*0.1, vertical: heigh*0.03),
                            child: OutlinedButton(
                              onPressed: () => {},
                              style: ButtonStyle(
                                  backgroundColor:
                                      const MaterialStatePropertyAll(Color.fromARGB(255, 23, 77, 169)),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(Colors.white),
                                  minimumSize: MaterialStateProperty.all<Size>(
                                      Size(width * 0.25, width * 0.08))),
                              child: const Text(
                                'Seleziona il file',
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
