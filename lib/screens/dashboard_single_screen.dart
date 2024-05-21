import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:lux_chain/utilities/size_config.dart';

class DashboardSingleScreen extends StatefulWidget {
  static const String id = 'DashboardSingleScreen';
  const DashboardSingleScreen({super.key});

  @override
  // ignore: no_logic_in_create_state
  State<DashboardSingleScreen> createState() => _DashboardSingleScreenState();
}

class _DashboardSingleScreenState extends State<DashboardSingleScreen> {
  final _formKey = GlobalKey<FormState>();

  final FocusNode _modelFocusNode = FocusNode();
  final FocusNode _modelTypeFocusNode = FocusNode();

  

  _nextFocus(FocusNode focusNode) {
    FocusScope.of(context).requestFocus(focusNode);
  }

  _submitForm() {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Dati inviati')));
  }

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
                '... un solo orologio',
                style: TextStyle(
                    color: Colors.black87,
                    height: 1,
                    fontSize: width * 0.1,
                    fontFamily: 'Bebas'),
              ),
              Container(
                margin: EdgeInsets.only(top: heigh * 0.015), // This is needed
                child: Text(
                    'Per eseguire questa operazione correttamente compila i seguenti campi:'),
              ),
              SizedBox(
                height: heigh * 0.035,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        focusNode: _modelFocusNode,
                        onFieldSubmitted: (String value) {
                          //Do something with value
                          _nextFocus(_modelFocusNode);
                        },
                        decoration: InputDecoration(labelText: 'Modello'),
                      )
                    ],
                  )),
              Text(
                  'Una volta riempito il file scaricato con i dati corretti caricalo qua sotto:'),
              SizedBox(
                height: heigh * 0.03,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: width * 0.15),
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
                              margin: EdgeInsets.only(
                                  top: heigh * 0.05, bottom: heigh * 0.01),
                              child: Icon(
                                Icons.upload_file_outlined,
                                size: heigh * 0.08,
                              )),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: width * 0.1,
                                vertical: heigh * 0.03),
                            child: OutlinedButton(
                              onPressed: () => {},
                              style: ButtonStyle(
                                  backgroundColor:
                                      const MaterialStatePropertyAll(
                                          Color.fromARGB(255, 23, 77, 169)),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  minimumSize: MaterialStateProperty.all<Size>(
                                      Size(width * 0.25, width * 0.08))),
                              child: const Text(
                                'Seleziona il file',
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
