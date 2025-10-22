import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datadog_flutter_plugin/datadog_flutter_plugin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// import 'package:flutter_material_pickers/helpers/show_number_picker.dart';
import 'package:health_app_fyp/BMR+BMR/components/buttons.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

import '../BMR+BMR/colors&fonts.dart';
import '../widgets/customnavbar.dart';

// Simple number picker dialog to replace flutter_material_pickers
Future<int?> showMaterialNumberPicker({
  required BuildContext context,
  required String title,
  required int minNumber,
  required int maxNumber,
  required int selectedNumber,
  required Function(int) onChanged,
  int step = 1,
}) async {
  int currentValue = selectedNumber;
  return showDialog<int>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  currentValue.toString(),
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: currentValue > minNumber
                          ? () {
                              setState(() {
                                currentValue = currentValue - step;
                                if (currentValue < minNumber) currentValue = minNumber;
                              });
                            }
                          : null,
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: currentValue < maxNumber
                          ? () {
                              setState(() {
                                currentValue = currentValue + step;
                                if (currentValue > maxNumber) currentValue = maxNumber;
                              });
                            }
                          : null,
                    ),
                  ],
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              onChanged(currentValue);
              Navigator.pop(context, currentValue);
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

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
    try {
      final tdeevals = await FirebaseFirestore.instance
          .collection('TDEE')
          .orderBy('tdeeTime')
          .limitToLast(1)
          .where("userID", isEqualTo: uid)
          .get();
      if (tdeevals.docs.isNotEmpty) {
        final doc = tdeevals.docs.first;
        print(doc.data());
        final value = doc.get("tdee");
        if (value is num) {
          return value.toDouble();
        }
        return double.tryParse(value.toString()) ?? t2;
      }
      return t2;
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<String> getDailyCalsRemaining() async {
    try {
      final calsvals = await FirebaseFirestore.instance
          .collection('remainingCalories')
          .orderBy('DateTime')
          .limitToLast(1)
          .where("userID", isEqualTo: uid)
          .get();
      if (calsvals.docs.isNotEmpty) {
        final doc = calsvals.docs.first;
        print(doc.data());
        tempText2 = doc.get("Cals").toString();
        print(tempText2);
        return tempText2;
      }
      return tempText2;
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<Timestamp> getLastCalsRemainingDay() async {
    try {
      final calsdate = await FirebaseFirestore.instance
          .collection('remainingCalories')
          .orderBy('DateTime')
          .limitToLast(1)
          .where("userID", isEqualTo: uid)
          .get();
      if (calsdate.docs.isNotEmpty) {
        final doc = calsdate.docs.first;
        print(doc.data());
        return doc.get("DateTime") as Timestamp;
      }
      return Timestamp(0, 0);
    } catch (error) {
      print(error);
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

    final configuration = ProductQueryConfiguration(
      barcode,
      version: ProductQueryVersion.v3,
      language: OpenFoodFactsLanguage.ENGLISH,
      fields: [ProductField.ALL],
    );
    final ProductResultV3 result =
        await OpenFoodAPIClient.getProductV3(configuration);

    final product = result.product;
    final notFound =
        product == null || result.result?.id == ProductResultV3.resultProductNotFound;

    if (notFound) {
      print(
          "Error retreiving the product with barcode : $barcode If the barcode number here matches the one on your food item , the item may not exist in the database. Please visit openfoodfacts.org ");

      foodTrackerLogger
          .warn('Food item with barcode $barcode not found in database');

      foodNameTxt = 'error';
      found = false;
      return;
    }

    found = true;

    Name = product.productName ??
        "ERROR: Item Data Exists In Database But Name Not Found!";
    if (product.productName == null) {
      foodTrackerLogger.warn('Food item with barcode $barcode has no name');
    }

    ingredientsT = product.ingredientsText;

    final nutriments = product.nutriments;
    final double? energyKcalPer100g = nutriments?.getValue(
      Nutrient.energyKCal,
      PerSize.oneHundredGrams,
    );
    final double? energyKjPer100g = nutriments?.getValue(
      Nutrient.energyKJ,
      PerSize.oneHundredGrams,
    );
    final double? energy100gKcal =
        energyKcalPer100g ?? (energyKjPer100g != null ? energyKjPer100g / 4.184 : null);

    servCalorie = nutriments?.getValue(
      Nutrient.energyKCal,
      PerSize.serving,
    );
    servCalorie ??= energy100gKcal;

    final String? servingSize = product.servingSize;
    final double? servingQuantity = product.servingQuantity;
    final double? fat100g = nutriments?.getValue(
      Nutrient.fat,
      PerSize.oneHundredGrams,
    );
    final double? saltServing = nutriments?.getValue(
      Nutrient.salt,
      PerSize.serving,
    );
    final double? fatServing = nutriments?.getValue(
      Nutrient.fat,
      PerSize.serving,
    );

    final String uid = FirebaseAuth.instance.currentUser!.uid;
    final DateTime inputTime = DateTime.now();

    print(Name);
    print(ingredientsT);
    if (energy100gKcal != null) {
      print(energy100gKcal.toStringAsFixed(2));
    }
    print(servingSize);
    print(servingQuantity);
    print(fat100g);
    print(saltServing);
    print(fatServing);

    FirebaseFirestore.instance.collection('TempFood').add({
      'Food Name': Name,
      'DateTime': inputTime,
      'CaloriesPerServing': servCalorie?.toStringAsFixed(2),
      'userID': uid
    });
    foodTrackerLogger.addAttribute('hostname', uid);
    foodTrackerLogger
        .info('Food item :$Name with barcode $barcode added to database');

    if (Name != null) {
      foodTrackerLogger.addAttribute('item_name', Name!);
    }
    foodTrackerLogger.addAttribute('item_barcode', barcode);
    if (servCalorie != null) {
      foodTrackerLogger.addAttribute('calories_per_serving', servCalorie!);
    }

    print("Temp food added");

    getFoodName().then((gotFoodName) {
      foodNameTxt = gotFoodName;
      print("getFoodName method called");
    });

    if (foodNameTxt.isNotEmpty) {
      found = true;
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
                                leading: Icon(MdiIcons.barcodeScan,
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
                                          child: OutlinedButton(
                                              child: Text(servings.toString()),
                                              // side: const BorderSide(
                                              //     width: 2,
                                              //     color: Colors.blueGrey),
                                                  style: ButtonStyle(
              padding: MaterialStateProperty.all(
                EdgeInsets.symmetric(vertical: 14),
              ),
              backgroundColor:
                  MaterialStateProperty.all(Theme.of(context).primaryColor),
              shape: MaterialStateProperty.all(
                StadiumBorder(),
              ),
            ),
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
                                          child: OutlinedButton(
                                              // borderSide: const BorderSide(
                                              //     width: 2,
                                              //     color: Colors.blueGrey),
                                              
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
    try {
      final foodname = await FirebaseFirestore.instance
          .collection('TempFood')
          .orderBy("DateTime")
          .limitToLast(1)
          .where('userID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      if (foodname.docs.isNotEmpty) {
        final doc = foodname.docs.first;
        foodNameTxt = doc.get("Food Name");
        return foodNameTxt.toString();
      }
      return foodNameTxt;
    } catch (error) {
      print(error);
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
