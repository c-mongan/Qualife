import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Chart extends StatefulWidget {
  const Chart({Key? key}) : super(key: key);

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  late List<HealthScore> chartChart;
  @override
  void initState() {
    chartChart = getChartChart(); //Chart Chart Initialised
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
            dataSource: chartChart,
            xValueMapper: (HealthScore data, _) => data.type,
            yValueMapper: (HealthScore data, _) => data.score,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            enableTooltip: true,
            maximumValue: 100)
      ],
    )));
  }
}

List<HealthScore> getChartChart() {
  final List<HealthScore> chartChart = [
    HealthScore('Body', 44),
    HealthScore('Mind', 56),
    HealthScore('Lifestyle', 10),
  ];
  return chartChart;
}

class HealthScore {
  String type;
  int score;

  HealthScore(this.type, this.score);
}
