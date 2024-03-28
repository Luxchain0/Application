import 'package:flutter/material.dart';
import 'package:lux_chain/utilities/size_config.dart';

class WatchTinderScreen extends StatefulWidget {
  static const String id = 'WatchTinderScreen';
  const WatchTinderScreen({super.key});

  @override
  State<WatchTinderScreen> createState() => _WatchTinderScreenState();
}

class _WatchTinderScreenState extends State<WatchTinderScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double heigh = SizeConfig.screenH!;
    double width = SizeConfig.screenW!;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width*0.05, vertical: heigh*0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Watches evaluation',
                  style: TextStyle(
                      color: Colors.black87,
                      height: 1,
                      fontSize: width * 0.1,
                      fontFamily: 'Bebas'
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: heigh*0.02),
                  decoration: BoxDecoration(
            color: Colors.white,
              border: Border.all(
                color: Colors.black26,
                width: 1,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(7))),
                  alignment: Alignment.center, // This is needed
                  child: Padding(
                    padding: EdgeInsets.all(heigh*0.02),
                    child: Image.asset(
                      'assets/images/o1.jpg',
                      fit: BoxFit.contain,
                      height: heigh * 0.3,
                    ),
                  ),
                ),
                Text(
                  'Nome corto'.toUpperCase(),
                  style: TextStyle(
                    color: Colors.black38,
                    height: 1,
                    fontSize: width * 0.07,
                    fontFamily: 'Bebas'
                  ),
                ),
                Text(
                  'Nome lungo con descrizione'.toUpperCase(),
                  style: TextStyle(
                    color: Colors.black87,
                    height: 1,
                    fontSize: width * 0.08,
                    fontFamily: 'Bebas'
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: heigh*0.03),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        onPressed: () => {}, 
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 17, 45, 68)),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          minimumSize: MaterialStateProperty.all<Size>(Size(width*0.25, width*0.1))
                        ),
                        child: const Text(
                          'Nahh',
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () => {},
                        style: ButtonStyle(
                          backgroundColor: const MaterialStatePropertyAll(Colors.blueAccent),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          minimumSize: MaterialStateProperty.all<Size>(Size(width*0.25, width*0.1))
                        ),
                        child: const Text(
                          'I like it!',
                        ),
                      )
                    ],
                  ),
                ),
                Text(
                  'Recommended',
                  style: TextStyle(
                      color: Colors.black87,
                      height: 1,
                      fontSize: width * 0.1,
                      fontFamily: 'Bebas'
                  ),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    alignLabelWithHint: true,
                    labelText: 'Insert the name of the watch'
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}