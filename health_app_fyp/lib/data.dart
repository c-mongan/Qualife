import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Data extends StatefulWidget {
  const Data({Key? key}) : super(key: key);

  @override
  _DataState createState() => _DataState();
}

class _DataState extends State<Data> {
  late List<HealthScore> chartData;
  @override
  void initState() {
    chartData = getChartData(); //Chart Data Initialised
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: SfCircularChart(
      title: ChartTitle(text: 'Your Health Scores (%)'),
      legend:
          Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
      series: <CircularSeries>[
        RadialBarSeries<HealthScore, String>(
            dataSource: chartData,
            xValueMapper: (HealthScore data, _) => data.type,
            yValueMapper: (HealthScore data, _) => data.score,
            dataLabelSettings: DataLabelSettings(isVisible: true),
            enableTooltip: true,
            maximumValue: 100)
      ],
    )));
  }
}

List<HealthScore> getChartData() {
  final List<HealthScore> chartData = [
    HealthScore('Body', 44),
    HealthScore('Mind', 56),
    HealthScore('Lifestyle', 10),
  ];
  return chartData;
}

class HealthScore {
  String type;
  int score;

  HealthScore(this.type, this.score);
}
