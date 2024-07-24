import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Per la formattazione delle date
import 'package:lux_chain/utilities/api_calls.dart';
import 'package:lux_chain/utilities/api_models.dart';
import 'package:lux_chain/utilities/size_config.dart';

class ChartCard extends StatefulWidget {
  final int watchId; // Aggiungi qui l'ID dell'orologio
  final bool isShowingMainData;

  const ChartCard({
    Key? key,
    required this.watchId,
    required this.isShowingMainData,
  }) : super(key: key);

  @override
  State<ChartCard> createState() => _ChartCardState();
}

class _ChartCardState extends State<ChartCard> {
  Set<String> _selected = {'min'};
  List<Candle> futureData = [];
  final List<FlSpot> _listDots1 = [];
  final List<FlSpot> _listDots2 = [];
  List<DateTime> _dates = [];

  double _delta = 0;
  double _min = 0;
  double _max = 0;
  double _contatore = 0;

  @override
  void initState() {
    super.initState();
    _initializeData(_selected.first);
  }

  void updateSelected(Set<String> newSelection) {
    setState(() {
      _selected = newSelection;
      _initializeData(_selected.first);
    });
  }

  Future<void> _initializeData(String temporal) async {
    futureData = await getCandles(temporal, widget.watchId);

    double min = double.infinity;
    double max = double.negativeInfinity;

    _listDots1.clear();
    _listDots2.clear();
    _dates.clear();
    _contatore = 0;

    for (Candle candle in futureData) {
      if (candle.max > max) max = candle.max;
      if (candle.min < min) min = candle.min;

      _listDots1.add(FlSpot(_contatore, candle.max));
      _listDots2.add(FlSpot(_contatore, candle.min));
      _dates.add(DateTime.parse(candle.date)); // Parse the ISO 8601 date
      _contatore += 1;
    }

    double fractionMax = max % 100;
    max = max + (100 - fractionMax);

    double fractionMin = min % 100;
    min = min - fractionMin;

    double delta = max - min;

    setState(() {
      _delta = delta;
      _min = min;
      _max = max;
    });
  }

  @override
  Widget build(BuildContext context) {
    final SizeConfig sizeConfig = SizeConfig();
    sizeConfig.init(context);
    final double height = SizeConfig.screenH!;
    final double width = SizeConfig.screenW!;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: width * 0.07),
      child: Column(
        children: [
          SizedBox(height: height * 0.05),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 30),
            constraints: BoxConstraints(maxWidth: width * 0.9, maxHeight: height * 0.3),
            child: LineChart(
              sampleData,
              duration: const Duration(milliseconds: 250),
            ),
          ),
          SegmentedButton(
            segments: const <ButtonSegment<String>>[
              ButtonSegment<String>(
                value: 'min',
                label: Text('Min'),
              ),
              ButtonSegment<String>(
                value: 'hour',
                label: Text('Hour'),
              ),
              ButtonSegment<String>(
                value: 'day',
                label: Text('Day'),
              ),
            ],
            selected: _selected,
            onSelectionChanged: updateSelected,
          ),
          SizedBox(height: height * 0.03),
          Container(
            margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width * 0.02),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomBoxForMeasure(
                  measure: 'Maximum sold price',
                  screenWidth: width,
                  color: Colors.redAccent,
                ),
                SizedBox(width: width * 0.08),
                CustomBoxForMeasure(
                  measure: 'Minimum sold price',
                  screenWidth: width,
                  color: Colors.green,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  LineChartData get sampleData => LineChartData(
    lineTouchData: lineTouchData1,
    gridData: gridData,
    titlesData: titlesData1,
    borderData: borderData,
    lineBarsData: lineBarsData1,
    minX: 0,
    maxX: _contatore,
    maxY: _max,
    minY: _min,
  );

  LineTouchData get lineTouchData1 => LineTouchData(
    handleBuiltInTouches: true,
    touchTooltipData: LineTouchTooltipData(
      getTooltipColor: (touchedSpot) => Colors.black45.withOpacity(0.8),
      tooltipRoundedRadius: 1,
    ),
  );

  FlTitlesData get titlesData1 => FlTitlesData(
    bottomTitles: AxisTitles(
      sideTitles: bottomTitles,
    ),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(
        reservedSize: 40,
        showTitles: true,
        interval: _delta / 2 > 0 ? _delta / 2 : 1, // Intervallo minimo di 1
      ),
    ),
    rightTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
  );

  SideTitles get bottomTitles => SideTitles(
    showTitles: true,
    reservedSize: 32,
    interval: 1, // Imposta un intervallo minimo di 1
    getTitlesWidget: (value, meta) {
      String text = _getLabel(value);
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 8.0,
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
      );
    },
  );

  String _getLabel(double value) {
    if (value.toInt() >= _dates.length) {
      return '';
    }

    final DateTime date = _dates[value.toInt()];

    switch (_selected.first) {
      case 'hour':
        return DateFormat('HH:mm').format(date); // Mostra solo ore e minuti
      case 'day':
        return DateFormat('dd/MM').format(date); // Mostra giorno e mese
      case 'min':
      default:
        return DateFormat('dd/MM/yyyy').format(date); // Mostra la data completa nel formato 'dd/MM/yyyy'
    }
  }

  List<LineChartBarData> get lineBarsData1 => [
    lineChartBarData1_1,
    lineChartBarData1_2,
  ];

  FlGridData get gridData => FlGridData(
    show: true,
    drawHorizontalLine: true,
    drawVerticalLine: true,
    horizontalInterval: _delta / 2 > 0 ? _delta / 2 : 1, // Assegna 1 come default se _delta / 2 è 0
  );

  FlBorderData get borderData => FlBorderData(
    show: true,
    border: const Border(
      bottom: BorderSide(color: Colors.black, width: 0.8),
      left: BorderSide(color: Colors.transparent),
      right: BorderSide(color: Colors.transparent),
      top: BorderSide(color: Colors.transparent),
    ),
  );

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
    isCurved: true,
    color: Colors.green,
    barWidth: 2,
    isStrokeCapRound: true,
    dotData: const FlDotData(show: false),
    belowBarData: BarAreaData(show: false),
    spots: _listDots1,
  );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
    isCurved: true,
    color: Colors.pink,
    barWidth: 2,
    isStrokeCapRound: false,
    dotData: const FlDotData(show: false),
    belowBarData: BarAreaData(
      show: true,
      color: Colors.pink.withOpacity(0),
    ),
    spots: _listDots2,
  );
}

class CustomBoxForMeasure extends StatelessWidget {
  const CustomBoxForMeasure({
    Key? key,
    required this.measure,
    required this.screenWidth,
    required this.color,
  }) : super(key: key);

  final String measure;
  final double screenWidth;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: screenWidth * 0.02),
              color: color,
              constraints: BoxConstraints(
                maxHeight: screenWidth * 0.03,
                maxWidth: screenWidth * 0.03,
              ),
            ),
            Text(
              measure,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
