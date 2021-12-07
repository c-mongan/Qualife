import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:health_app_fyp/model/user_model.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePage createState() {
    return _ProfilePage();
  }
}

class _ProfilePage extends State<ProfilePage> {
  late List<charts.Series<UserModel, String>> _seriesBarData;
  late List<UserModel> mydata;
  _generateData(mydata) {
    //_seriesBarData = List<charts.Series<UserModel, String>>();
    _seriesBarData.add(
      charts.Series(
        domainFn: (UserModel users, _) => users.bmi.toString(),
        measureFn: (UserModel users, _) => users.height,
        //colorFn: (UserModel users, _) =>
        //   charts.ColorUtil.fromDartColor(Color(int.parse(users.colorVal))),
        id: 'UserModel',
        data: mydata,
        labelAccessorFn: (UserModel row, _) => "${row.bmi}",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('UserModel')),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          List<UserModel> users = snapshot.data!.docs
              .map((documentSnapshot) =>
                  UserModel.fromMap(documentSnapshot.data))
              .toList();
          return _buildChart(context, users);
        }
      },
    );
  }

  Widget _buildChart(BuildContext context, List<UserModel> saledata) {
    mydata = saledata;
    _generateData(mydata);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'UserModel by Year',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: charts.BarChart(
                  _seriesBarData,
                  animate: true,
                  animationDuration: Duration(seconds: 5),
                  behaviors: [
                    new charts.DatumLegend(
                      entryTextStyle: charts.TextStyleSpec(
                          color: charts.MaterialPalette.purple.shadeDefault,
                          fontFamily: 'Georgia',
                          fontSize: 18),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
