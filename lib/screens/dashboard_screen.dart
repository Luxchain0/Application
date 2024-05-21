import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lux_chain/utilities/size_config.dart';

class DashboardScreen extends StatefulWidget {
  static const String id = 'DashboardScreen';
  const DashboardScreen({super.key});

  @override
  // ignore: no_logic_in_create_state
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

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
                'Dashboard',
                style: TextStyle(
                    color: Colors.black87,
                    height: 1,
                    fontSize: width * 0.1,
                    fontFamily: 'Bebas'),
              ),
              Container(
                margin: EdgeInsets.only(top: heigh * 0.02), // This is needed
                child: Text('Da questa schermata puoi aggiungere nuovi orologi nell\'applicazione.'),
              ),
              SizedBox(height: heigh*0.01,),
              Text('Lo puoi fare in due modi'),
              SizedBox(height: heigh*0.05,),
              Padding(
                padding: EdgeInsets.symmetric(vertical: heigh*0.02),
                child: Row(
                  children: [
                    Expanded(child: Center(child: Container(
                      color: const Color.fromARGB(255, 180, 212, 238),
                      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
                      child: Text('1'),
                    ))),
                    Expanded(child: Center(child: Container(
                      color: const Color.fromARGB(255, 180, 212, 238),
                      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
                      child: Text('2'),
                    ))),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: heigh*0.02),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: width*0.05),
                        child: Text(
                          'Aggiungere più orologi',
                          textAlign: TextAlign.center,
                        )
                      )
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: width*0.05),
                        child: Text(
                          'Aggiungere un orologio',
                          textAlign: TextAlign.center,
                        )
                      )
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: heigh*0.02),
                child: Row(
                  children: [
                    Expanded(child: Center(child: Icon(Icons.arrow_downward_outlined))),
                    Expanded(child: Center(child: Icon(Icons.arrow_downward_outlined))),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: width*0.1),
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
                          'Excel',
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: width*0.1),
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
                          'Vai',
                        ),
                      ),
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
