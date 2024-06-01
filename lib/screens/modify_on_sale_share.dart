import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lux_chain/utilities/api_calls.dart';
import 'package:lux_chain/utilities/api_models.dart';
import 'package:lux_chain/utilities/frame.dart';
import 'package:lux_chain/utilities/models.dart';
import 'package:lux_chain/utilities/size_config.dart';
import 'package:lux_chain/utilities/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModifyOnSaleShareScreen extends StatefulWidget {
  static const String id = 'ModifyOnSaleShareScreen';
  final ModifySharesOnSale modifySharesOnSale;

  const ModifyOnSaleShareScreen({required this.modifySharesOnSale, Key? key})
      : super(key: key);

  @override
  State<ModifyOnSaleShareScreen> createState() =>
      _ModifyOnSaleShareScreenState();
}

class _ModifyOnSaleShareScreenState extends State<ModifyOnSaleShareScreen> {
  late ModifySharesOnSale modifySharesOnSale;
  final TextEditingController myController = TextEditingController();
  late int onSaleAtPrice;

  @override
  void initState() {
    super.initState();
    modifySharesOnSale = widget.modifySharesOnSale;
    onSaleAtPrice = modifySharesOnSale.onSaleAtPrice;
    myController.text = modifySharesOnSale.proposalPrice.toString();
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    print("SAVING");

    try {
      SharedPreferences user = await getUserData();
      int userId = user.getInt('accountid') ?? 0;

      var result = await updateSharesOnSale(
        modifySharesOnSale.watchid, // watchId
        userId,
        modifySharesOnSale.proposalPrice, // oldPrice
        double.parse(myController.text), // newPrice
        onSaleAtPrice, // numberOfShares
      );

      if (result == APIStatus.success) {
        _showDialog(
          'Successo',
          'The change of shares for sale was successful',
          onClose: () {
            Navigator.pushNamed(context, FrameScreen.id);
          },
        );
      } else {
        _showDialog('Errore', 'Something went wrong. Try again in a while');
      }
    } catch (error) {
      print('Errore: $error');
      _showDialog('Errore', 'An unexpected error occurred. Please try again.');
    }
  }

  void _showDialog(String title, String message, {VoidCallback? onClose}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (onClose != null) onClose();
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double height = SizeConfig.screenH!;
    double width = SizeConfig.screenW!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(width),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.05, vertical: height * 0.025),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildHeader(width),
            _buildImageContainer(height),
            _buildTextFields(width, height),
            _buildSharesForSaleRow(width),
            SizedBox(height: height * 0.02),
            _buildPriceInput(width),
            _buildSaveButton(width),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Edit',
          style: TextStyle(
            color: Colors.black87,
            fontSize: width * 0.1,
            fontFamily: 'Bebas',
          ),
        ),
      ],
    );
  }

  Widget _buildImageContainer(double height) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: height * 0.02),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black26, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(7)),
      ),
      alignment: Alignment.center,
      child: FutureBuilder<String>(
        future: modifySharesOnSale.image,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasData) {
            return ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(7)),
              child: Image.network(
                snapshot.data!,
                fit: BoxFit.cover,
              ),
            );
          } else {
            return const Icon(Icons.error);
          }
        },
      ),
    );
  }

  Widget _buildTextFields(double width, double height) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          modifySharesOnSale.brandName,
          style: TextStyle(
            color: Colors.black38,
            fontSize: width * 0.07,
            fontFamily: 'Bebas',
          ),
        ),
        Text(
          modifySharesOnSale.modelName,
          style: TextStyle(
            color: Colors.black87,
            fontSize: width * 0.08,
            fontFamily: 'Bebas',
          ),
        ),
        SizedBox(height: height * 0.02),
        Text('Owned shares: ${modifySharesOnSale.sharesOwned}'),
        Text('Owned shares for sale: ${modifySharesOnSale.sharesOnSale}'),
        SizedBox(height: height * 0.02),
      ],
    );
  }

  Widget _buildSharesForSaleRow(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text("Shares for sale:"),
        SizedBox(width: width * 0.03),
        _buildDecreaseButton(width),
        SizedBox(width: width * 0.03),
        Text("$onSaleAtPrice"),
        SizedBox(width: width * 0.03),
        _buildIncreaseButton(width),
      ],
    );
  }

  Widget _buildDecreaseButton(double width) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (modifySharesOnSale.sharesOnSale > 0) {
            modifySharesOnSale.decreaseShareOnSale();
            onSaleAtPrice--;
          }
        });
      },
      child: CircleAvatar(
        radius: width * 0.04,
        backgroundColor: const Color.fromARGB(228, 118, 196, 241),
        child: const Text('-'),
      ),
    );
  }

  Widget _buildIncreaseButton(double width) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (modifySharesOnSale.sharesOnSale <
              modifySharesOnSale.sharesOwned) {
            modifySharesOnSale.increaseShareOnSale();
            onSaleAtPrice++;
          }
        });
      },
      child: CircleAvatar(
        radius: width * 0.04,
        backgroundColor: const Color.fromARGB(226, 102, 176, 255),
        child: const Text('+'),
      ),
    );
  }

  Widget _buildPriceInput(double width) {
    return Row(
      children: [
        const Text('Sale price:'),
        SizedBox(width: width * 0.02),
        SizedBox(
          width: width * 0.3,
          child: TextField(
            controller: myController,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+([.,]\d+)?')),
            ],
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 1, horizontal: 15),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color.fromARGB(226, 102, 176, 255)),
                borderRadius: BorderRadius.circular(5.5),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white10),
              ),
              filled: true,
              fillColor: const Color.fromARGB(31, 102, 176, 255),
              hintText:
                  formatAmountFromDouble(modifySharesOnSale.proposalPrice),
              hintStyle: const TextStyle(color: Colors.black),
            ),
          ),
        ),
        SizedBox(width: width * 0.02),
        const Text('€'),
      ],
    );
  }

  Widget _buildSaveButton(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: () {
            if (myController.text.isNotEmpty) {
              setState(() {
                modifySharesOnSale.setProposalPrice(myController.text);
              });
              _saveChanges();
            }
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
            foregroundColor: MaterialStateProperty.all(Colors.white),
            minimumSize:
                MaterialStateProperty.all(Size(width * 0.25, width * 0.08)),
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
