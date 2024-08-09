import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Per la formattazione delle date
import 'package:lux_chain/utilities/api_calls.dart';
import 'package:lux_chain/utilities/api_models.dart';
import 'package:lux_chain/utilities/size_config.dart';
import 'package:lux_chain/utilities/utils.dart';

class ChartCard extends StatefulWidget {
  final int watchId;
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
  String _selected = 'day';
  List<GraphData> futureData = [];
  final List<FlSpot> _listDotsMax = [];
  final List<FlSpot> _listDotsMin = [];
  final List<DateTime> _dates = [];
  
  DateTime selectedStartDate = DateTime.now().subtract(const Duration(days: 7));
  DateTime selectedEndDate = DateTime.now();

  double _delta = 0;
  double _min = 0;
  double _max = 0;
  double _contatore = 0;

  @override
  void initState() {
    super.initState();
    _initializeData(_selected, selectedStartDate, selectedEndDate);
  }

  void updateSelected(
      String newSelection, DateTime startDate, DateTime endDate) {
    setState(() {
      _selected = newSelection;
      _initializeData(_selected, startDate, endDate);
    });
  }

  Future<void> _initializeData(
      String temporal, DateTime startDate, DateTime endDate) async {
    futureData =
        await getGraphDatas(temporal, widget.watchId, startDate, endDate);

    double min = double.infinity;
    double max = double.negativeInfinity;

    _listDotsMax.clear();
    _listDotsMin.clear();
    _dates.clear();
    _contatore = 0;

    for (GraphData candle in futureData) {
      if (candle.max > max) max = candle.max;
      if (candle.min < min) min = candle.min;

      _listDotsMax.add(FlSpot(_contatore, candle.max));
      _listDotsMin.add(FlSpot(_contatore, candle.min));
      _dates.add(DateTime.parse(candle.date));
      _contatore += 1;
    }

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

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text(
              'End Date: ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
                "${selectedEndDate.day} - ${selectedEndDate.month} - ${selectedEndDate.year}"),
            TextButton(
                onPressed: () async {
                  final DateTime? dateTime = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2024),
                      lastDate: DateTime.now().add(const Duration(days: 1)));
                  if (dateTime != null) {
                    
                    if(_selected == "hour"){
                      final TimeOfDay? selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(selectedEndDate),
                      );

                      if (selectedTime != null) {
                        // Combina la data selezionata con l'ora selezionata
                        final DateTime dateTimeWithTime = DateTime(
                          dateTime.year,
                          dateTime.month,
                          dateTime.day,
                          selectedTime.hour,
                          selectedTime.minute,
                        );

                        setState(() {
                          selectedEndDate = dateTimeWithTime;
                          selectedStartDate = selectedEndDate.subtract(const Duration(hours: 12));
                        });
                      }
                      
                    } else if(_selected == "day"){
                      setState(() {
                        selectedEndDate = dateTime;
                        selectedStartDate = dateTime.subtract(const Duration(days: 7));
                      });
                    }

                    _initializeData(
                        _selected, selectedStartDate, selectedEndDate);
                  }
                },
                child: const Text('Change date')),
          ],
        ),
        Container(
            margin: const EdgeInsets.symmetric(vertical: 30),
            constraints:
                BoxConstraints(maxWidth: width * 0.9, maxHeight: height * 0.27),
            child: _listDotsMax.isNotEmpty
                ? LineChart(
                    sampleData,
                    duration: const Duration(milliseconds: 250),
                  )
                : const Text(
                    'There is no data to show in the selected period')),
        SegmentedButton(
          segments: const <ButtonSegment<String>>[
            ButtonSegment<String>(
              value: 'hour',
              label: Text('Hour'),
            ),
            ButtonSegment<String>(
              value: 'day',
              label: Text('Day'),
            ),
          ],
          selected: {_selected},
          onSelectionChanged: (newSelection) => updateSelected(
              newSelection.first, selectedStartDate, selectedStartDate),
        ),
        SizedBox(height: height * 0.03),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomBoxForMeasure(
              measure: 'Maximum sold price',
              screenWidth: width,
              color: Colors.green,
            ),
            CustomBoxForMeasure(
              measure: 'Minimum sold price',
              screenWidth: width,
              color: Colors.redAccent,
            ),
          ],
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                "This is the value of a share of this watch during the selected time window",
                textAlign: TextAlign.center,
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
            ),
          ],
        ),
      ],
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
        maxY: _max + (_max - _min) * 0.1,
        minY: _min - (_max - _min) * 0.1 > 0 ? _min - (_max - _min) * 0.1 : 0,
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
            reservedSize: 70,
            showTitles: true,
            interval: _delta / 3 > 0 ? _delta / 3 : 1,
            getTitlesWidget: (value, meta) {
              return SideTitleWidget(
                axisSide: meta.axisSide,
                space: 8.0,
                child: Text(
                  formatRawAmountFromDouble(value),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1, // Ensure text is kept in one line
                ),
              );
            },
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
        reservedSize: 20,
        interval: 1,
        getTitlesWidget: (value, meta) {
          String text = _getLabel(value);
          return SideTitleWidget(
            axisSide: meta.axisSide,
            space: 4.0,
            child: Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          );
        },
      );

  String _getLabel(double value) {
    if (value.toInt() >= _dates.length) {
      return '';
    }

    final DateTime date = _dates[value.toInt()];

    switch (_selected) {
      // Usato _selected come String
      case 'hour':
        return DateFormat('HH').format(date);
      case 'day':
        return DateFormat('dd/MM').format(date);
      default:
        return DateFormat('dd/MM/yyyy').format(date);
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
        horizontalInterval: _delta / 3 > 0 ? _delta / 3 : 1,
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
        isCurved: false,
        color: Colors.green,
        barWidth: 2,
        isStrokeCapRound: false,
        dotData: const FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
        spots: _listDotsMax,
      );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
        isCurved: false,
        color: Colors.pink,
        barWidth: 2,
        isStrokeCapRound: false,
        dotData: const FlDotData(show: true),
        belowBarData: BarAreaData(
          show: true,
          color: Colors.pink.withOpacity(0),
        ),
        spots: _listDotsMin,
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
              margin: EdgeInsets.only(
                  right: screenWidth * 0.02, left: screenWidth * 0.04),
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
