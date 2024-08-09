// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:lux_chain/utilities/frame.dart';
import 'package:lux_chain/utilities/size_config.dart';

class FAQScreen extends StatefulWidget {
  static const String id = 'FAQScreen';

  const FAQScreen({super.key});

  @override
  FAQScreenState createState() => FAQScreenState();
}

class FAQScreenState extends State<FAQScreen> {
  final List<Item> _data = generateItems();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double width = SizeConfig.screenW!;

    return Scaffold(
      appBar: appBar(width),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: 40.0,
          vertical: 40.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            const Text(
              'FAQ',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildPanel(),
          ],
        ),
      ),
    );
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(item.headerValue),
            );
          },
          body: ListTile(
            title: Text(item.expandedValue),
          ),
          isExpanded: item.isExpanded,
          canTapOnHeader: true,
        );
      }).toList(),
    );
  }
}

class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  final String expandedValue;
  final String headerValue;
  bool isExpanded;
}

List<Item> generateItems() {
  return [
    Item(
      headerValue: 'What is the serial number?',
      expandedValue:
          'The serial number of a watch is a unique identifier of the individual watch on our platform. It was assigned by us and is necessary to distinguish two watches, instance of the same model and with the same characteristics.',
    ),
    Item(
      headerValue: 'How is the actual value of a watch calculated?',
      expandedValue:
          'The actual value of a watch is calculated by multiplying the actual value of the shares of that watch by the number of shares in the watch. The actual value of the shares of a watch is the value of the last share bought of that watch',
    ),
    Item(
      headerValue: 'Why when I sell shares do I not see them in the market?',
      expandedValue:
          'The shares that you put up for sale are hidden from you so that you cannot make a mistake and buy them. If you want to keep track of the shares you have for sale check the "my shares for sale" page.',
    ),
    Item(
      headerValue: 'Am I really buying shares of a watch?',
      expandedValue:
          'No, as it says on the first screen of the app, these transactions are all fictitious and do not involve any real assets, neither money nor watches. ',
    ),
    Item(
      headerValue: 'Why is the increase rate of watches in the wallet screen and the individual watch screen different?',
      expandedValue:
          'The increase rate that can be seen on the wallet screen refers to the change that the watch has undergone since your last buy a share of it. The rate that can be found on the individual watch page refers to the change that the watch has undergone since it was added to the platform. The first rate has the wallet icon, the second has the world icon',
    ),
    Item(
      headerValue: 'Why do I see only the line of the minimum and not also the line of the maximum in the graphs of the share price of a watch?',
      expandedValue:
          'In these cases the reason is that the two lines coincide and one hides the other.',
    ),
  ];
}
