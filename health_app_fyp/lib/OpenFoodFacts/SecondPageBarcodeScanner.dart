import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_material_pickers/helpers/show_number_picker.dart';
import 'package:health_app_fyp/BMR+BMR/components/buttons.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

import '../BMR+BMR/colors&fonts.dart';
import '../widgets/customnavbar.dart';

class BarcodeScanSecond extends StatefulWidget {
  const BarcodeScanSecond({Key? key}) : super(key: key);

  @override
  _BarcodeScanSecondState createState() => _BarcodeScanSecondState();
}

class _BarcodeScanSecondState extends State<BarcodeScanSecond> {
  String _scannedBarcode = 'Unknown';

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

    ProductQueryConfiguration configurations = ProductQueryConfiguration(
        barcode,
        language: OpenFoodFactsLanguage.ENGLISH,
        fields: [
          ProductField.NAME,
          ProductField.NUTRIMENTS,
          ProductField.INGREDIENTS_TEXT,
          ProductField.INGREDIENTS,
          ProductField.ADDITIVES,
          ProductField.NUTRIENT_LEVELS,
          ProductField.NUTRIMENT_ENERGY_UNIT,
          ProductField.SERVING_SIZE,
          ProductField.SERVING_QUANTITY
          //ProductField.NUTRIMENT_DATA_PER
        ]);

    ProductResult result = await OpenFoodAPIClient.getProduct(
      configurations,
    );

    if (result.status != 1) {
      print(
          "Error retreiving the product with barcode : $barcode If the barcode number here matches the one on your food item , the item may not exist in the database. Please visit openfoodfacts.org ");

      foodNameTxt = 'error';
      found = false;
      return;

      // ${result.status!.errorVerbose}
    } else {
      found = true;

      String? Name;
      //= result.product!.productName;

      if (result.product!.productName != null) {
        Name = result.product!.productName;
      } else {
        Name = "ERROR: Item Data Exists In Database But Name Not Found!";
      }

      // }

      //String? Calories = result.product!.nutrimentEnergyUnit;
//foodNameTxt = result.product!.productName!;

      String? ingredientsT = result.product!.ingredientsText;
      // List<Ingredient>? ingredients = result!.product!.ingredients;

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

        // double? energy_serving = result.product!.nutriments!.energyServing;

        //divide the energy value by 4.184

        // double? energy_100g_kcal = energy_100g! / 4.184;
        //divide the energy value by 4.184
        double? fat_100g = result.product!.nutriments!.fat;

        double? salt_serving = result.product!.nutriments!.saltServing;
        double? fat_serving = result.product!.nutriments!.fatServing;

        String uid = FirebaseAuth.instance.currentUser!.uid;
        DateTime inputTime = (DateTime.now());
//Level? sugars_level = result.product!.nutrientLevels!.levels[NutrientLevels.NUTRIENT_SUGARS];

        print(Name);
        print(ingredientsT);
        print(energy100gKcal.toStringAsFixed(2));

        // getTdeeVal().then((tdee) {
        //   String val = tdee;
        // print("getTdeeVal() method called , val = " + val);

        // getDailyCalsRemaining().then((calsLeft) {
        //   print(calsLeft + "result");
        //   // double num = double.parse(calsLeft);
        //   // String val = calsLeft.toString();

        //   // String decimal = ".00";
        //   // String val = calsLeft + decimal;

        //   String val = calsLeft;

        //   print(val);

        //   // deductCal(tdee, energy_100g_kcal, uid, inputTime);
        //  // deductCal(val, energy_100g_kcal, uid, inputTime);

        //   // double result = double.parse(tdee);
        //   // double calRemaining = result - energy_100g_kcal;
        //   // print(tdee + " " + "kcal");
        //   // print(calRemaining.toString() + "kcal");
        // });

        // FirebaseFirestore.instance.collection('Food').add({
        //   'Food Name': Name,
        //   'DateTime': inputTime,
        //   'CaloriesPerServing': servCalorie?.toStringAsFixed(2),
        //   'userID': uid
        // });

        FirebaseFirestore.instance.collection('TempFood').add({
          'Food Name': Name,
          'DateTime': inputTime,
          'CaloriesPerServing': servCalorie?.toStringAsFixed(2),
          'userID': uid
        });

        print("Temp food added");

        getFoodName().then((gotFoodName) {
          // print(foodNameTxt + "result LINE 143");
          // String val = tdee;
          foodNameTxt = gotFoodName;
          //  print(foodNameTxt + " GOT FOOD NAME TXT FROM FIRESTORE LINE 145");
          print("getFoodName method called");
        });

        if (foodNameTxt.isNotEmpty) {
          found = true;
        }

        //});

        //addToDB(Name, ingredientsT, energy_100g_kcal, inputTime);

      }
      //  found = true;
    }
  }

  // Future<void> getFoodName() async {
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     food = fetchAnItem(_scannedBarcode);
  //     // ignore: avoid_print
  //     print('GET FOOD METHOD CALLED');
  //     // ignore: avoid_print
  //     print((await food));
  //   // ignore: empty_catches
  //   } on PlatformException {
  //   }

  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   if (!mounted) return;

  //   setState(() {
  //   });
  // }

  Future<void> runBarcodeScanner() async {
    scanBarcode();
  }

  // Future<void> addFood() async {
  //   helper.insertAnItem(await food!);
  //   exitscreen(true);
  // }

  void exitscreen(bool reload) {
    Navigator.pop(context, reload);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Food'),
          elevation: 0,
        ),
        bottomNavigationBar: CustomisedNavigationBar(),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    // colors: [Colors.red, Colors.white, Colors.red],
                    colors: [
                  Colors.red,
                  Colors.blue,
                  // Colors.red,
                  //Colors.blue,

                  // Colors.orange,
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
                              color: Colors.red,
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
                                      color: Colors.red,
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

                          // Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          // crossAxisAlignment: CrossAxisAlignment.center,

                          // Card(
                          //   child: ListTile(
                          //     title: Text(foodNameTxt),
                          //     subtitle: const Text(
                          //       ' kcal per serving',
                          //     ),
                          //     trailing: const Icon(MdiIcons.food, size: 50.0),
                          //   ),
                          // ),

                          Card(
                              child: Material(
                                  color: Colors.red,
                                  child: ListTile(
                                      title: Text((() {
                                        var a = 1;
                                        if (a == 1) {
                                          return 'Servings ';
                                        } else {
                                          return 'Servings ';
                                        }
                                      }())
                                          //+
                                          //"Quantity)"
                                          //${(snapshot.data!.servingQty).toStringAsFixed(2)} ${snapshot.data!.servingUnit})

                                          ),
                                      subtitle: const Text(
                                          "Please select amount of servings"
                                          //'${(snapshot.data!.calories * snapshot.data!.servingConsumed).toString()} Calories')
                                          ),
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
                                                      // onChanged: (double newValue) => setState(() => null

                                                      onChanged: (int servNum) {
                                                        //Dont forget to setState so it changes
                                                        setState(() {
                                                          servings = servNum;
                                                          //  String? foodName = Name;

//Commenting below out for the moment

                                                          //     double totalCals =
                                                          //         servCalorie! * servings;

                                                          //     getFoodName()
                                                          //         .then((gotFoodName) {

                                                          //       foodNameTxt = gotFoodName;

                                                          //       print(
                                                          //           "GET FOOD NAME METHOD CALLED TO GET FOOD NAME FROM TEMP TO FOOD TABLE");
                                                          //     });

                                                          //     FirebaseFirestore.instance
                                                          //         .collection('Food')
                                                          //         .add({
                                                          //       'Food Name': foodNameTxt,
                                                          //       'userID': uid,
                                                          //       'NumberOfServings':
                                                          //           servings,
                                                          //       'CaloriesPerServing':
                                                          //           servCalorie
                                                          //               ?.toStringAsFixed(
                                                          //                   2),
                                                          //       'TotalCaloriesAdded':
                                                          //           totalCals,
                                                          //       'DateTime': inputTime,
                                                          //     });

                                                          //     print("FOOD ADDED");

                                                          //     getLastCalsRemainingDay()
                                                          //         .then((time) {
                                                          //       print(time.toString() +
                                                          //           "result");

                                                          //       DateTime tempdate = DateTime
                                                          //           .fromMicrosecondsSinceEpoch(
                                                          //               time.microsecondsSinceEpoch);

                                                          //       if (tempdate.day != today) {
                                                          //         getTdeeVal().then((tdee) {
                                                          //           print(tdee);

                                                          //           servings - 1;
                                                          //           double totalCals =
                                                          //               servings *
                                                          //                   servCalorie!;
                                                          //           double totalDeducts =
                                                          //               tdee - totalCals;

                                                          //           //THIS WORKS

                                                          //           // Date today = inputTime.;

                                                          //           FirebaseFirestore
                                                          //               .instance
                                                          //               .collection(
                                                          //                   'remainingCalories')
                                                          //               .add({
                                                          //             'userID': uid,
                                                          //             'Cals': totalDeducts,
                                                          //             'DateTime': inputTime,
                                                          //           });
                                                          //         });
                                                          //       } else {
                                                          //         getDailyCalsRemaining().then(
                                                          //             (calsLeft) {
                                                          //           print(calsLeft +
                                                          //               "result");
                                                          //           double num =
                                                          //               double.parse(
                                                          //                   calsLeft);

                                                          //           print(foodNameTxt +
                                                          //               " " +
                                                          //               num.toString() +
                                                          //               "CALORIES LEFT");

                                                          //           servings - 1;
                                                          //           double totalCals =
                                                          //               servings *
                                                          //                   servCalorie!;
                                                          //           double totalDeducts =
                                                          //               num - totalCals;

                                                          //           //THIS WORKS

                                                          //           FirebaseFirestore
                                                          //               .instance
                                                          //               .collection(
                                                          //                   'remainingCalories')
                                                          //               .add({
                                                          //             'userID': uid,
                                                          //             'Cals': totalDeducts,
                                                          //             'DateTime': inputTime,
                                                          //           });

                                                          //           print(totalDeducts);
                                                          //         }

                                                          //             );

                                                          //             }
                                                          //           });
                                                          //         });
                                                          //       }),
                                                          // )))))
                                                        });
                                                      })))))),
                          Card(
                              child: Material(
                                  color: Colors.red,
                                  child: ListTile(
                                      title: Text((() {
                                        var a = 1;
                                        if (a == 1) {
                                          return 'Serving size (g) ';
                                        } else {
                                          return 'Serving size (g)) ';
                                        }
                                      }())
                                          //+
                                          //"Quantity)"
                                          //${(snapshot.data!.servingQty).toStringAsFixed(2)} ${snapshot.data!.servingUnit})

                                          ),
                                      subtitle: const Text(
                                          "Please enter the weight in grammes for your serving(s)"
                                          //'${(snapshot.data!.calories * snapshot.data!.servingConsumed).toString()} Calories')
                                          ),
                                      leading: SizedBox(
                                          width: 65,
                                          // ignore: deprecated_member_use
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
                                                      // onChanged: (double newValue) => setState(() => null

                                                      onChanged:
                                                          (int servSize) {
                                                        //Dont forget to setState so it changes
                                                        setState(() {
                                                          servingSize =
                                                              servSize;
                                                          //  String? foodName = Name;
                                                          //     double totalCals =
                                                          //         servCalorie! /
                                                          //             100 *
                                                          //             servingSize *
                                                          //             servings;

                                                          //     getFoodName()
                                                          //         .then((gotFoodName) {
                                                          //       // print(foodNameTxt +
                                                          //       //     "result LINE 143");
                                                          //       // String val = tdee;
                                                          //       foodNameTxt = gotFoodName;
                                                          //       // print(foodNameTxt +
                                                          //       //     " GOT FOOD NAME TXT FROM FIRESTORE LINE 145");

                                                          //       print(
                                                          //           "GET FOOD NAME METHOD CALLED TO GET FOOD NAME FROM TEMP TO FOOD TABLE");
                                                          //     });

                                                          //     FirebaseFirestore.instance
                                                          //         .collection('Food')
                                                          //         .add({
                                                          //       'Food Name': foodNameTxt,
                                                          //       'userID': uid,
                                                          //       'NumberOfServings':
                                                          //           servings,
                                                          //       'CaloriesPer100gServing':
                                                          //           servCalorie
                                                          //               ?.toStringAsFixed(
                                                          //                   2),
                                                          //       'ServingSize': servingSize,
                                                          //       'TotalCaloriesAdded':
                                                          //           totalCals,
                                                          //       'DateTime': inputTime,
                                                          //     });

                                                          //     print("FOOD ADDED");

                                                          //     getLastCalsRemainingDay()
                                                          //         .then((time) {
                                                          //       print(time.toString() +
                                                          //           "result");

                                                          //       DateTime tempdate = DateTime
                                                          //           .fromMicrosecondsSinceEpoch(
                                                          //               time.microsecondsSinceEpoch);

                                                          //       if (tempdate.day != today) {
                                                          //         getTdeeVal().then((tdee) {
                                                          //           print(tdee);

                                                          //           servings - 1;
                                                          //           double totalCals =
                                                          //               servings *
                                                          //                   servCalorie! /
                                                          //                   100 *
                                                          //                   servingSize;
                                                          //           double totalDeducts =
                                                          //               tdee - totalCals;

                                                          //           //THIS WORKS

                                                          //           // Date today = inputTime.;

                                                          //           FirebaseFirestore
                                                          //               .instance
                                                          //               .collection(
                                                          //                   'remainingCalories')
                                                          //               .add({
                                                          //             'userID': uid,
                                                          //             'Cals': totalDeducts,
                                                          //             'DateTime': inputTime,
                                                          //           });
                                                          //         });
                                                          //       } else {
                                                          //         getDailyCalsRemaining()
                                                          //             .then((calsLeft) {
                                                          //           print(calsLeft +
                                                          //               "result");
                                                          //           double num =
                                                          //               double.parse(
                                                          //                   calsLeft);

                                                          //           print(foodNameTxt +
                                                          //               " " +
                                                          //               num.toString() +
                                                          //               "CALORIES LEFT");

                                                          //           servings - 1;

                                                          //           double totalCals =
                                                          //               servings *
                                                          //                   servCalorie! /
                                                          //                   100 *
                                                          //                   servingSize;
                                                          //           double totalDeducts =
                                                          //               num - totalCals;

                                                          //           //THIS WORKS

                                                          //           FirebaseFirestore
                                                          //               .instance
                                                          //               .collection(
                                                          //                   'remainingCalories')
                                                          //               .add({
                                                          //             'userID': uid,
                                                          //             'Cals': totalDeducts,
                                                          //             'DateTime': inputTime,
                                                          //           });

                                                          //           print(totalDeducts);
                                                          //         });
                                                          //       }
                                                          //     });
                                                          //   });
                                                          // }),
                                                          // ;};))))),
                                                        });
                                                      })))))),
                          Button(
                              edges: const EdgeInsets.all(0.0),
                              color: Colors.red,
                              text: const Text(
                                'Enter food',
                                style: textStyle2,
                                // TextStyle(fontWeight: FontWeight.bold),
                              ),
                              onTap: () {
                                double totalCals =
                                    servCalorie! / 100 * servingSize * servings;

                                getFoodName().then((gotFoodName) {
                                  // print(foodNameTxt +
                                  //     "result LINE 143");
                                  // String val = tdee;
                                  foodNameTxt = gotFoodName;
                                  // print(foodNameTxt +
                                  //     " GOT FOOD NAME TXT FROM FIRESTORE LINE 145");

                                  print(
                                      "GET FOOD NAME METHOD CALLED TO GET FOOD NAME FROM TEMP TO FOOD TABLE");
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

                                print("FOOD ADDED");

                                getLastCalsRemainingDay().then((time) {
                                  print(time.toString() + "result");

                                  DateTime tempdate =
                                      DateTime.fromMicrosecondsSinceEpoch(
                                          time.microsecondsSinceEpoch);

                                  if (tempdate.day != today) {
                                    getTdeeVal().then((tdee) {
                                      print(tdee);

                                      servings - 1;
                                      double totalCals = servings *
                                          servCalorie! /
                                          100 *
                                          servingSize;
                                      double totalDeducts = tdee - totalCals;

                                      //THIS WORKS

                                      // Date today = inputTime.;

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
                                      print(calsLeft + "result");
                                      double num = double.parse(calsLeft);

                                      print(foodNameTxt +
                                          " " +
                                          num.toString() +
                                          "CALORIES LEFT");

                                      servings - 1;

                                      double totalCals = servings *
                                          servCalorie! /
                                          100 *
                                          servingSize;
                                      double totalDeducts = num - totalCals;

                                      //THIS WORKS

                                      FirebaseFirestore.instance
                                          .collection('remainingCalories')
                                          .add({
                                        'userID': uid,
                                        'Cals': totalDeducts,
                                        'DateTime': inputTime,
                                      });

                                      print(totalDeducts);
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
  // },

  // }))
  // ))))

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
        print(name.data());
        foodNameTxt = foodname.docs[0].get("Food Name");
        //print(tempText1);
        String gotFoodName = foodNameTxt.toString();
        print(gotFoodName);

        return gotFoodName;
      }
      return foodNameTxt;
    } catch (Exc) {
      print(Exc);
      rethrow;
    }
  }

  void deductCal(String tdee, double energy_100g_kcal, uid, inputTime) {
    double result = double.parse(tdee);
    double calRemaining = result - energy_100g_kcal;
    // print(tdee + " " + "kcal");
    // print(calRemaining.toString() + "kcal deductCal method successful ");

    print("deductCal Method called , result : " +
        result.toString() +
        "calRemaining : " +
        calRemaining.toString());

    FirebaseFirestore.instance.collection('remainingCalories').add({
      'userID': uid,
      'Cals': calRemaining,
      'DateTime': inputTime,
    });
  }
}
  



//THIS METHOD DOESNT WORK
  // getTDEE() async {
  //   final documents = await FirebaseFirestore.instance
  //       .collection('TDEE')
  //       .where("userID", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
  //       .get();
  //   final userTDEE = documents.docs.first.data;
  //   String sTDEE = userTDEE.toString();
  //   print(sTDEE);
  //   return sTDEE;
  // }

  
