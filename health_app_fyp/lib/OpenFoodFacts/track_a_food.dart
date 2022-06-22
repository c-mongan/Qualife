import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datadog_flutter_plugin/datadog_flutter_plugin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_material_pickers/helpers/show_number_picker.dart';
import 'package:health_app_fyp/BMR+BMR/components/buttons.dart';
import 'package:health_app_fyp/initialregistrationscreens/initialdailycheckin.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

import '../BMR+BMR/colors&fonts.dart';
import '../widgets/customnavbar.dart';
import '../widgets/glassmorphic_bottomnavbar.dart';

class BarcodeScanSecond extends StatefulWidget {
  const BarcodeScanSecond({Key? key}) : super(key: key);

  @override
  _BarcodeScanSecondState createState() => _BarcodeScanSecondState();
}

class _BarcodeScanSecondState extends State<BarcodeScanSecond> {
  String _scannedBarcode = 'Unknown';

  final foodTrackerLogger = DatadogSdk.instance.createLogger(
    LoggingConfiguration(loggerName: 'Calorie Tracker Logger'),
  );
  // DatabaseManager helper = DatabaseManager();
  @override
  void initState() {
    super.initState();

    runBarcodeScanner();
    getFoodName();
  }

  Future<double> getTdeeVal() async {
    double Exc = 0;

    try {
      final tdeevals = await FirebaseFirestore.instance
          .collection('TDEE')
          .orderBy('tdeeTime')
          .limitToLast(1)
          .where("userID", isEqualTo: uid)
          .get();
      for (var tdeeval in tdeevals.docs) {
        print(tdeeval.data());

        double tdee = tdeevals.docs[0].get("tdee");

        return tdee;
      }
      return t2;
    } catch (Exc) {
      print(Exc);
      rethrow;
    }
  }

  Future<String> getDailyCalsRemaining() async {
    String Exc = "Error";

    try {
      final calsvals = await FirebaseFirestore.instance
          .collection('remainingCalories')
          .orderBy('DateTime')
          .limitToLast(1)
          .where("userID", isEqualTo: uid)
          .get();
      for (var cals in calsvals.docs) {
        print(cals.data());
        tempText2 = calsvals.docs[0].get("Cals").toString();

        String calsLeft = tempText2.toString();
        print(calsLeft);

        return calsLeft;
      }
      return tempText2;
    } catch (Exc) {
      print(Exc);
      rethrow;
    }
  }

  Future<Timestamp> getLastCalsRemainingDay() async {
    String Exc = "Error";

    try {
      final calsdate = await FirebaseFirestore.instance
          .collection('remainingCalories')
          .orderBy('DateTime')
          .limitToLast(1)
          .where("userID", isEqualTo: uid)
          .get();
      for (var cals in calsdate.docs) {
        print(cals.data());
        Timestamp time;
        time = calsdate.docs[0].get("DateTime");

        String calsLeftDay = tempText2.toString();
        print(calsLeftDay);

        return time;
      }
      return Timestamp(0, 0);
    } catch (Exc) {
      print(Exc);
      rethrow;
    }
  }

  final Stream<QuerySnapshot> foodStream = FirebaseFirestore.instance
      .collection('Food')
      .orderBy("DateTime")
      .limitToLast(1)
      .where('userID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

  final Stream<QuerySnapshot> lastfoodStream = FirebaseFirestore.instance
      .collection('TempFood')
      .orderBy("DateTime")
      .limitToLast(1)
      .where('userID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

  String? Name;
  String? ingredientsT;
  double? energy_100g_kcal;
  double? servCalorie;
  String foodNameTxt = "Item Unknown";
  String uid = FirebaseAuth.instance.currentUser!.uid;
  int servings = 1;
  int servingSize = 0;
  DateTime inputTime = DateTime.now();

  final today = DateTime.now().day;

  List fields = [];

  bool found = false;

  String tempText1 = ' ';
  String tempText2 = ' ';

  double t2 = 0;

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcode() async {
    String barcodeScanRes;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      // ignore: avoid_print
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scannedBarcode = barcodeScanRes;
    });

    String barcode = barcodeScanRes;

    // request a product from the OpenFoodFacts database

    ProductQueryConfiguration configuration = ProductQueryConfiguration(barcode,
        language: OpenFoodFactsLanguage.ENGLISH, fields: [ProductField.ALL]);
    ProductResult result = await OpenFoodAPIClient.getProduct(configuration);

    if (result.status == 1) {
      if (result.status != 1) {
        print(
            "Error retreiving the product with barcode : $barcode If the barcode number here matches the one on your food item , the item may not exist in the database. Please visit openfoodfacts.org ");

        foodTrackerLogger
            .warn('Food item with barcode $barcode not found in database');

        foodNameTxt = 'error';
        found = false;

        return;
      } else {
        found = true;

        if (result.product!.productName != null) {
          Name = result.product!.productName;
        } else {
          Name = "ERROR: Item Data Exists In Database But Name Not Found!";

          foodTrackerLogger.warn('Food item with barcode $barcode has no name');
        }

        String? ingredientsT = result.product!.ingredientsText;

        double? energy_100g = result.product!.nutriments!.energy;

        if (energy_100g == null) {
          double? energy100gKcal = 1;
        } else {
          double? energy100gKcal = energy_100g / 4.184;

          servCalorie = result.product!.nutriments!.energyKcal;

          String? servingSize = result.product!.servingSize;
          print(servingSize);

          double? servingQuan = result.product!.servingQuantity;
          print(servingQuan);

          double? fat_100g = result.product!.nutriments!.fat;

          double? saltServing = result.product!.nutriments!.saltServing;
          double? fatServing = result.product!.nutriments!.fatServing;

          String uid = FirebaseAuth.instance.currentUser!.uid;
          DateTime inputTime = (DateTime.now());

          print(Name);
          print(ingredientsT);
          print(energy100gKcal.toStringAsFixed(2));

          FirebaseFirestore.instance.collection('TempFood').add({
            'Food Name': Name,
            'DateTime': inputTime,
            'CaloriesPerServing': servCalorie?.toStringAsFixed(2),
            'userID': uid
          });
          foodTrackerLogger.addAttribute('hostname', uid);
          foodTrackerLogger
              .info('Food item :$Name with barcode $barcode added to database');

//Logging item scanned details
          foodTrackerLogger.addAttribute('hostname', uid);
          foodTrackerLogger.addAttribute('item_name', Name!);
          foodTrackerLogger.addAttribute('item_barcode', barcode);
          foodTrackerLogger.addAttribute('calories_per_serving', servCalorie!);

          print("Temp food added");

          getFoodName().then((gotFoodName) {
            foodNameTxt = gotFoodName;

            print("getFoodName method called");
          });

          if (foodNameTxt.isNotEmpty) {
            found = true;
          }
        }
      }
    }
  }

  Future<void> runBarcodeScanner() async {
    scanBarcode();
  }

  void exitscreen(bool reload) {
    Navigator.pop(context, reload);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Food'),
          backgroundColor: Colors.black,
          elevation: 0,
        ),
        bottomNavigationBar: CustomisedNavigationBar(),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    // colors: [Colors.white, Colors.white, Colors.white],
                    colors: [
                  Colors.black,
                  Colors.grey,
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            child: Builder(builder: (BuildContext context) {
              return SingleChildScrollView(
                  // <-- wrap this around
                  child: Column(children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    child: Flex(
                        direction: Axis.vertical,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Card(
                            child: Material(
                              color: Colors.white,
                              child: ListTile(
                                title: found == false
                                    ? const Text("")
                                    : const Text('Scanned Barcode Value'),
                                subtitle: found == false
                                    ? const Text("")
                                    : Text(_scannedBarcode),
                                leading: const Icon(MdiIcons.barcodeScan,
                                    size: 50.0),
                              ),
                            ),
                          ),
                          Card(
                              child: StreamBuilder<QuerySnapshot>(
                            stream: lastfoodStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              // if (found = false) {
                              //   return const Text('Item not found');
                              // }
                              if (snapshot.hasError) {
                                return const Text('Something went wrong');
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Text("Loading");
                              }

                              return ListView(
                                shrinkWrap: true,
                                children: snapshot.data!.docs
                                    .map((DocumentSnapshot document) {
                                  Map<String, dynamic> data =
                                      document.data()! as Map<String, dynamic>;
                                  return Material(
                                      color: Colors.white,
                                      child: ListTile(
                                          leading: const Icon(Icons.fastfood),
                                          isThreeLine: true,
                                          title: found == false
                                              ? const Text(
                                                  "Item not found or doesn't exist in the database")
                                              : Text(
                                                  data['Food Name'],
                                                  style: const TextStyle(
                                                    fontSize: 30.0,
                                                    color: Color.fromARGB(
                                                        255, 77, 75, 75),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                          subtitle: found == false
                                              ? const Text("Please try again")
                                              : Text(
                                                  data['CaloriesPerServing'] +
                                                      " kcal per 100g serving",
                                                  style: const TextStyle(
                                                    fontSize: 15.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                )));
                                }).toList(),
                              );
                            },
                          )),
                          Card(
                              child: Material(
                                  color: Colors.white,
                                  child: ListTile(
                                      title: Text((() {
                                        var a = 1;
                                        if (a == 1) {
                                          return 'Servings ';
                                        } else {
                                          return 'Servings ';
                                        }
                                      }())),
                                      subtitle: const Text(
                                          "Please select amount of servings"),
                                      leading: SizedBox(
                                          width: 40,
                                          // ignore: deprecated_member_use
                                          child: OutlineButton(
                                              child: Text(servings.toString()),
                                              borderSide: const BorderSide(
                                                  width: 2,
                                                  color: Colors.blueGrey),
                                              onPressed: () =>
                                                  showMaterialNumberPicker(
                                                      context: context,
                                                      title:
                                                          "Number of Servings",
                                                      maxNumber: 20,
                                                      minNumber: 1,
                                                      selectedNumber: servings,
                                                      onChanged: (int servNum) {
                                                        //Dont forget to setState so it changes
                                                        setState(() {
                                                          servings = servNum;
                                                        });
                                                      })))))),
                          Card(
                              child: Material(
                                  color: Colors.white,
                                  child: ListTile(
                                      title: Text((() {
                                        var a = 1;
                                        if (a == 1) {
                                          return 'Serving size (g) ';
                                        } else {
                                          return 'Serving size (g)) ';
                                        }
                                      }())),
                                      subtitle: const Text(
                                          "Please enter the weight in grammes for your serving(s)"),
                                      leading: SizedBox(
                                          width: 65,
                                          child: OutlineButton(
                                              borderSide: const BorderSide(
                                                  width: 2,
                                                  color: Colors.blueGrey),
                                              child: Text(
                                                  servingSize.toString() + "g"),
                                              onPressed: () =>
                                                  showMaterialNumberPicker(
                                                      context: context,
                                                      title:
                                                          "Serving size in grammes (g)",
                                                      maxNumber: 5000,
                                                      minNumber: 0,
                                                      selectedNumber:
                                                          servingSize,
                                                      step: 5,
                                                      onChanged:
                                                          (int servSize) {
                                                        setState(() {
                                                          servingSize =
                                                              servSize;
                                                        });
                                                      })))))),
                          Button(
                              edges: const EdgeInsets.all(0.0),
                              color: Colors.white,
                              text: const Text('Enter food', style: textStyle2),
                              onTap: () {
                                double totalCals =
                                    servCalorie! / 100 * servingSize * servings;

                                getFoodName().then((gotFoodName) {
                                  foodNameTxt = gotFoodName;
                                });

                                FirebaseFirestore.instance
                                    .collection('Food')
                                    .add({
                                  'Food Name': foodNameTxt,
                                  'userID': uid,
                                  'NumberOfServings': servings,
                                  'CaloriesPer100gServing':
                                      servCalorie?.toStringAsFixed(2),
                                  'ServingSize': servingSize,
                                  'TotalCaloriesAdded': totalCals,
                                  'DateTime': inputTime,
                                });

                                getLastCalsRemainingDay().then((time) {
                                  DateTime tempdate =
                                      DateTime.fromMicrosecondsSinceEpoch(
                                          time.microsecondsSinceEpoch);

                                  if (tempdate.day != today) {
                                    getTdeeVal().then((tdee) {
                                      servings - 1;
                                      double totalCals = servings *
                                          servCalorie! /
                                          100 *
                                          servingSize;
                                      double totalDeducts = tdee - totalCals;
//Allows us to see how many of our users are overconsuming calories
                                      if (totalDeducts < 0) {
                                        foodTrackerLogger.addAttribute(
                                            'hostname', uid);
                                        foodTrackerLogger.addAttribute(
                                            'calories_overconsumed',
                                            totalDeducts);
                                        foodTrackerLogger.addAttribute(
                                            'hostname', uid);
                                        foodTrackerLogger.warn(
                                            "User $uid has exceeded their daily recommended calorie intake by $totalDeducts calories today");
                                      }
                                      FirebaseFirestore.instance
                                          .collection('remainingCalories')
                                          .add({
                                        'userID': uid,
                                        'Cals': totalDeducts,
                                        'DateTime': inputTime,
                                      });
                                    });
                                  } else {
                                    getDailyCalsRemaining().then((calsLeft) {
                                      double num = double.parse(calsLeft);

                                      servings - 1;

                                      double totalCals = servings *
                                          servCalorie! /
                                          100 *
                                          servingSize;
                                      double totalDeducts = num - totalCals;
//Allows us to see how many of our users are overconsuming calories
                                      if (totalDeducts < 0) {
                                        foodTrackerLogger.addAttribute(
                                            'hostname', uid);
                                        foodTrackerLogger.addAttribute(
                                            'calories_overconsumed',
                                            totalDeducts);
                                        foodTrackerLogger.addAttribute(
                                            'hostname', uid);
                                        foodTrackerLogger.warn(
                                            "User $uid has exceeded their daily recommended calorie intake by $totalDeducts calories today");
                                      }

                                      FirebaseFirestore.instance
                                          .collection('remainingCalories')
                                          .add({
                                        'userID': uid,
                                        'Cals': totalDeducts,
                                        'DateTime': inputTime,
                                      });
                                    });
                                  }
                                });
                                bool reload = true;
                                exitscreen(reload);
                              })
                        ]))
              ]));
            })));
  }

  //THIS METHOD IS FOR GETTING FOOD NAME INTO A STRING , FROM TEMPFOOOD
  Future<String> getFoodName() async {
    String Exc = "Error";

    try {
      final foodname = await FirebaseFirestore.instance
          .collection('TempFood')
          .orderBy("DateTime")
          .limitToLast(1)
          .where('userID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      for (var name in foodname.docs) {
        foodNameTxt = foodname.docs[0].get("Food Name");
        //print(tempText1);
        String gotFoodName = foodNameTxt.toString();

        return gotFoodName;
      }
      return foodNameTxt;
    } catch (Exc) {
      print(Exc);
      rethrow;
    }
  }

//   void deductCal(String tdee, double energy100gKcal, uid, inputTime) {
//     double result = double.parse(tdee);
//     double calRemaining = result - energy100gKcal;

// //Allows us to see how many of our users are overconsuming calories
//     if (calRemaining < 0) {
//         foodTrackerLogger.addAttribute('hostname', uid);
//             foodTrackerLogger.addAttribute('calories_overconsumed', totalDeducts);
//       foodTrackerLogger.info(
//           "User $uid has exceeded their daily recommended calorie intake by $calRemaining calories today");
//     }

//     FirebaseFirestore.instance.collection('remainingCalories').add({
//       'userID': uid,
//       'Cals': calRemaining,
//       'DateTime': inputTime,
//     });
//   }
}
