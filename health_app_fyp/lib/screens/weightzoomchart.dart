///Dart import
import 'dart:math';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

///Package imports
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:intl/intl.dart' hide TextDirection;

///Chart import
import 'package:syncfusion_flutter_charts/charts.dart' hide LabelPlacement;

///Core import
import 'package:syncfusion_flutter_core/core.dart';

///Core theme import
import 'package:syncfusion_flutter_core/theme.dart';

///Slider import
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../BMR+BMR/colors&fonts.dart';
import '../SyncFusion/sample_view.dart';
import '../model/user_model.dart';
import '../widgets/customnavbar.dart';
import 'daily_check_in.dart';

/// Renders the range selector with line chart zooming option
class RangeSelectorZoomingPage extends SampleView {
  /// Renders the range selector with line chart zooming option

  @override
  _RangeSelectorZoomingPageState createState() =>
      _RangeSelectorZoomingPageState();
}

class _RangeSelectorZoomingPageState extends SampleViewState
    with SingleTickerProviderStateMixin {
  _RangeSelectorZoomingPageState();

  List<_ChartData> chartData = <_ChartData>[];

  late List<num> _xValues;
  late List<num> _yValues;
  List<double> _xPointValues = <double>[];
  List<double> _yPointValues = <double>[];

  TooltipBehavior? _tooltipBehavior;

  Future<void> getDataFromFireStore() async {
    var snapShotsValue = await FirebaseFirestore.instance
        // .collection("BMI")
        // .orderBy("bmiTime")
        .collection("DailyCheckIn")
        .orderBy("DateTime")
        .where('userID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();
    List<_ChartData> list = snapShotsValue.docs
        .map((e) => _ChartData(
            // x: DateTime.fromMillisecondsSinceEpoch(
            //     e.data()['bmiTime'].millisecondsSinceEpoch),
            // y: e.data()['bmiScore']))

            x: DateTime.fromMillisecondsSinceEpoch(
                e.data()['DateTime'].millisecondsSinceEpoch),
            y: e.data()['Weight']))
        .toList();
    setState(() {
      chartData = list;
    });
  }

  final DateTime min = DateTime.now().subtract(Duration(days: 30)),
      max = DateTime.now();

  late RangeController rangeController;
  late SfCartesianChart columnChart, splineChart;
  late List<_ChartData> columnData, splineSeriesData;
  bool enableDeferredUpdate = true;

  @override
  void initState() {
    super.initState();
    rangeController = RangeController(
      // start: DateTime.fromMillisecondsSinceEpoch(1498608000000),
      // end: DateTime.fromMillisecondsSinceEpoch(1508112000000),

      start: min,
      end: max,
    );

    _tooltipBehavior = TooltipBehavior(
      enable: true,
      header: '',
      canShowMarker: false,
    );

    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());

      if (mounted) {
        // check whether the state object is in tree
        getDataFromFireStore().then((results) {
          SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
            setState(() {});
          });
        });
        //setPage();
      }
    });
    for (int i = 0; i < 366; i++) {
      chartData.add(_ChartData(
          x: DateTime(2000, 01, 01).add(Duration(days: i)),
          y: Random().nextInt(190) + 50));
    }

    columnChart = SfCartesianChart(
      margin: EdgeInsets.zero,
      primaryXAxis:
          DateTimeAxis(isVisible: false, maximum: DateTime(2029, 1, 1)),
      primaryYAxis: NumericAxis(isVisible: false),
      plotAreaBorderWidth: 0,
      series: <SplineAreaSeries<_ChartData, DateTime>>[
        SplineAreaSeries<_ChartData, DateTime>(
            dataSource: chartData,
            borderColor: const Color.fromRGBO(0, 193, 187, 1),
            color: RoyalBlue,
            borderDrawMode: BorderDrawMode.excludeBottom,
            borderWidth: 1,
            xValueMapper: (_ChartData data, _) => data.x,
            yValueMapper: (_ChartData data, _) => data.y),
      ],
    );
  }

  @override
  void dispose() {
    chartData.clear();
    rangeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final bool isLightTheme =
        themeData.colorScheme.brightness == Brightness.light;
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    Scaffold(
        appBar: AppBar(
          title: const Text('Pie Charts'),
          elevation: 0,
          backgroundColor: Colors.black,
        ),
        bottomNavigationBar: CustomisedNavigationBar(),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
              Colors.black,
              Colors.grey,
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            child: splineChart = SfCartesianChart(
              title: ChartTitle(text: 'Your weight fluctuations'),
              plotAreaBorderWidth: 0,
              tooltipBehavior: TooltipBehavior(
                  animationDuration: 0,
                  shadowColor: Colors.transparent,
                  enable: true),
              primaryXAxis: DateTimeAxis(
                  labelStyle: const TextStyle(),
                  isVisible: false,
                  minimum: DateTime.fromMillisecondsSinceEpoch(1483315200000),
                  maximum: DateTime.fromMillisecondsSinceEpoch(1514678400000),
                  visibleMinimum: rangeController.start,
                  visibleMaximum: rangeController.end,
                  rangeController: rangeController),
              primaryYAxis: NumericAxis(
                labelPosition: ChartDataLabelPosition.inside,
                labelAlignment: LabelAlignment.end,
                majorTickLines: const MajorTickLines(size: 0),
                axisLine: const AxisLine(color: Colors.transparent),
                anchorRangeToVisiblePoints: false,
                maximum: 100,
                minimum: 0,
              ),
              series: <SplineSeries<_ChartData, DateTime>>[
                SplineSeries<_ChartData, DateTime>(
                    dataSource: chartData,
                    splineType: SplineType.cardinal,
                    cardinalSplineTension: 0.5,
                    name: 'BMI',
                    color: Colors.red,
                    animationDuration: 0,
                    xValueMapper: (_ChartData data, _) => data.x,
                    yValueMapper: (_ChartData data, _) => data.y),
              ],
            )));
    final Widget page = Container(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        color:
            model.isWebFullView ? model.cardThemeColor : model.cardThemeColor,
        child: Center(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                    width: mediaQueryData.orientation == Orientation.landscape
                        ? model.isWebFullView
                            ? mediaQueryData.size.width * 0.7
                            : mediaQueryData.size.width
                        : mediaQueryData.size.width,
                    padding: const EdgeInsets.fromLTRB(5, 20, 15, 25),
                    child: splineChart),
              ),
              SfRangeSelectorTheme(
                  data: SfRangeSelectorThemeData(
                      activeLabelStyle: TextStyle(
                          fontSize: 10,
                          color: isLightTheme ? Colors.black : Colors.white),
                      inactiveLabelStyle: TextStyle(
                          fontSize: 10,
                          color: isLightTheme
                              ? Colors.black
                              : const Color.fromRGBO(170, 170, 170, 1)),
                      activeTrackColor: const Color.fromRGBO(255, 125, 30, 1),
                      inactiveRegionColor: isLightTheme
                          ? Colors.white.withOpacity(0.75)
                          : const Color.fromRGBO(33, 33, 33, 0.75),
                      thumbColor: Colors.white,
                      thumbStrokeColor: const Color.fromRGBO(255, 125, 30, 1),
                      thumbStrokeWidth: 2.0,
                      overlayRadius: 1,
                      overlayColor: Colors.transparent),
                  child: Container(
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
                    width: mediaQueryData.orientation == Orientation.landscape
                        ? model.isWebFullView
                            ? mediaQueryData.size.width * 0.7
                            : mediaQueryData.size.width
                        : mediaQueryData.size.width,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(14, 0, 15, 15),
                        child: SfRangeSelector(
                          min: min,
                          max: max,
                          interval: .25,
                          enableDeferredUpdate: enableDeferredUpdate,
                          deferredUpdateDelay: 1000,
                          labelPlacement: LabelPlacement.betweenTicks,
                          dateIntervalType: DateIntervalType.months,
                          controller: rangeController,
                          showTicks: true,
                          showLabels: true,
                          dragMode: SliderDragMode.both,
                          labelFormatterCallback:
                              (dynamic actualLabel, String formattedText) {
                            String label = DateFormat.MMM().format(actualLabel);
                            label = (model.isWebFullView &&
                                    mediaQueryData.size.width <= 1000)
                                ? label[0]
                                : label;
                            return label;
                          },
                          onChanged: (SfRangeValues values) {},
                          child: Container(
                            height: 75,
                            padding: EdgeInsets.zero,
                            margin: EdgeInsets.zero,
                            child: columnChart,
                          ),
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ));
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: SizedBox(height: 400, child: page),
        ),
      ),
    );
  }

  @override
  Widget buildSettings(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter stateSetter) {
        return CheckboxListTile(
          value: enableDeferredUpdate,
          title: const Text(
            'Enable deferred update',
            softWrap: false,
          ),
          activeColor: Colors.grey,
          contentPadding: EdgeInsets.zero,
          onChanged: (bool? value) {
            setState(
              () {
                enableDeferredUpdate = value!;
                stateSetter(() {});
              },
            );
          },
        );
      },
    );
  }
}

// Class for chart data source, this can be modified based on the data in Firestore
class _ChartData {
  _ChartData({this.x, this.y});
  final DateTime? x;
  final double? y;
}

class bmiData {
  bmiData(this.bmiTime, this.bmiScore);
  final DateTime bmiTime;
  final double bmiScore;
}
