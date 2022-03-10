import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineChartSample2 extends StatefulWidget {
  const LineChartSample2({Key? key}) : super(key: key);

  @override
  _LineChartSample2State createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData(2010, 35),
      ChartData(2011, 28),
      ChartData(2012, 34),
      ChartData(2013, 32),
      ChartData(2014, 40)
    ];

    return Scaffold(
        body: Center(
            child: Container(
                child: SfCartesianChart(series: <ChartSeries>[
      // Renders line chart
      LineSeries<ChartData, int>(
          dataSource: chartData,
          xValueMapper: (ChartData sales, _) => sales.year,
          yValueMapper: (ChartData sales, _) => sales.sales)
    ]))));
  }
}

class ChartData {
  ChartData(this.year, this.sales);
  final int year;
  final double sales;
}
