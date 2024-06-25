import 'package:flutter/material.dart';
import 'package:lux_chain/utilities/api_models.dart';
import 'package:lux_chain/utilities/frame.dart';
import 'package:lux_chain/utilities/size_config.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lux_chain/utilities/utils.dart';

class WalletSpecsScreen extends StatelessWidget {
  static const String id = 'WalletSpecsScreen';
  final WalletData walletData;
  const WalletSpecsScreen({super.key, required this.walletData});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double height = SizeConfig.screenH!;
    double width = SizeConfig.screenW!;

    // List<FlSpot> chartData = [
    //   const FlSpot(0, 1),
    //   const FlSpot(1, 3),
    //   const FlSpot(2, 10),
    //   const FlSpot(3, 7),
    //   const FlSpot(4, 12),
    //   const FlSpot(5, 13),
    //   const FlSpot(6, 17),
    //   const FlSpot(7, 15),
    //   const FlSpot(8, 20),
    // ];

    return Scaffold(
      appBar: appBar(width),
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(
              right: width * 0.05, left: width * 0.05, top: height * 0.01),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Text(
                    'Wallet value',
                    style: TextStyle(fontSize: width * 0.05),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      formatAmountFromDouble(
                          walletData.inShares + walletData.liquidity),
                      style: TextStyle(
                          color: Colors.black87,
                          height: 1,
                          fontSize: width * 0.1,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: width * 0.01,
                    ),
                    Text(
                      '€',
                      style: TextStyle(
                        fontSize: width * 0.06,
                        height: 1,
                      ),
                    ),
                    Expanded(
                        child: SizedBox(
                      width: width * 0.01,
                    )),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(3)),
                        color: walletData.rate >= 0
                            ? Colors.lightGreen
                            : Colors.red,
                      ),
                      child: Text('${walletData.rate}%'),
                    ),
                  ],
                ),
              ),
              Text(
                'In shares: ${formatAmountFromDouble(walletData.inShares)}',
                style: TextStyle(fontSize: width * 0.04),
              ),
              Text(
                'Liquidity: ${formatAmountFromDouble(walletData.liquidity)}',
                style: TextStyle(fontSize: width * 0.04),
              ),
              SizedBox(
                height: height * 0.04,
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: <Widget>[
                      // Container(
                      //   padding: const EdgeInsets.all(10),
                      //   width: double.infinity,
                      //   height: 300,
                      //   child: LineChart(
                      //     LineChartData(
                      //         borderData: FlBorderData(show: false),
                      //         lineBarsData: [
                      //           LineChartBarData(spots: chartData),
                      //         ]),
                      //   ),
                      // ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        width: double.infinity,
                        height: 300,
                        child: PieChart(
                          PieChartData(
                            sections: [
                              PieChartSectionData(
                                value: walletData.liquidity,
                                color: Colors.blue,
                                title: 'liquidity',
                                radius: 125,
                              ),
                              PieChartSectionData(
                                value: walletData.inShares,
                                color: const Color(0xFF18314F),
                                title: 'shares',
                                radius: 125,
                                titleStyle: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                            centerSpaceRadius: 0,
                            sectionsSpace: 0,
                          ),
                        ),
                      ),
                    ],
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
