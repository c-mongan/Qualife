import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_app_fyp/services/telemetry.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// import 'package:flutter_material_pickers/helpers/show_number_picker.dart';
import 'package:health_app_fyp/BMR+BMR/components/buttons.dart';

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
                                if (currentValue < minNumber)
                                  currentValue = minNumber;
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
                                if (currentValue > maxNumber)
                                  currentValue = maxNumber;
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
  String? _errorMessage;
  bool _isSaving = false;

  // DatabaseManager helper = DatabaseManager();
  @override
  void initState() {
    super.initState();
    runBarcodeScanner();
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
        final value = doc.get("tdee");
        if (value is num) {
          return value.toDouble();
        }
        return double.tryParse(value.toString()) ?? t2;
      }
      return t2;
    } catch (_) {
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
        tempText2 = doc.get("Cals").toString();
        return tempText2;
      }
      return tempText2;
    } catch (_) {
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
        return doc.get("DateTime") as Timestamp;
      }
      return Timestamp(0, 0);
    } catch (_) {
      rethrow;
    }
  }

  Stream<QuerySnapshot> get lastfoodStream {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Stream<QuerySnapshot>.empty();
    return FirebaseFirestore.instance
        .collection('TempFood')
        .orderBy("DateTime")
        .limitToLast(1)
        .where('userID', isEqualTo: user.uid)
        .snapshots();
  }

  String? Name;
  String? ingredientsT;
  double? servCalorie;
  String foodNameTxt = "Item Unknown";
  String get uid => FirebaseAuth.instance.currentUser?.uid ?? '';
  int servings = 1;
  int servingSize = 0;
  DateTime inputTime = DateTime.now();

  List fields = [];

  bool found = false;

  String tempText1 = ' ';
  String tempText2 = ' ';

  double t2 = 0;

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcode() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw StateError('Please sign in before adding food.');
      }
      final barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      if (barcodeScanRes == '-1') {
        if (mounted) Navigator.pop(context);
        return;
      }
      if (mounted) setState(() => _scannedBarcode = barcodeScanRes);

      final configuration = ProductQueryConfiguration(
        barcodeScanRes,
        version: ProductQueryVersion.v3,
        language: OpenFoodFactsLanguage.ENGLISH,
        fields: [ProductField.ALL],
      );
      final result = await OpenFoodAPIClient.getProductV3(configuration);
      if (!mounted) return;
      final product = result.product;
      if (product == null ||
          result.result?.id == ProductResultV3.resultProductNotFound) {
        AppTelemetry.info(TelemetryEvent.foodLookupNotFound);
        throw StateError('Food not found. Try another barcode.');
      }

      Name = product.productName?.trim();
      if (Name == null || Name!.isEmpty) {
        throw StateError('This food has no product name.');
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
      final double? energy100gKcal = energyKcalPer100g ??
          (energyKjPer100g != null ? energyKjPer100g / 4.184 : null);

      servCalorie = nutriments?.getValue(
        Nutrient.energyKCal,
        PerSize.oneHundredGrams,
      );
      servCalorie ??= energy100gKcal;
      if (servCalorie == null || !servCalorie!.isFinite) {
        throw StateError('Calorie information is unavailable for this food.');
      }

      final inputTime = DateTime.now();

      if (!mounted) return;
      await FirebaseFirestore.instance.collection('TempFood').add({
        'Food Name': Name,
        'DateTime': inputTime,
        'CaloriesPerServing': servCalorie!.toStringAsFixed(2),
        'userID': user.uid
      });
      foodNameTxt = Name!;
      AppTelemetry.info(TelemetryEvent.foodEntrySaved);

      if (mounted) {
        setState(() {
          found = true;
        });
      }
    } on PlatformException {
      _showError('Unable to open the barcode scanner.');
    } catch (error) {
      _showError(_friendlyError(error));
    }
  }

  Future<void> runBarcodeScanner() async {
    await scanBarcode();
  }

  String _friendlyError(Object error) {
    if (error is StateError) return error.message;
    return 'Could not load this food. Check your connection and try again.';
  }

  void _showError(String message) {
    if (!mounted) return;
    setState(() {
      _errorMessage = message;
      found = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      }
    });
  }

  bool _sameCalendarDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

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
                ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)),
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
                                leading: const Icon(
                                  Icons.qr_code_scanner,
                                  size: 50.0,
                                ),
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
                                                padding:
                                                    MaterialStateProperty.all(
                                                  EdgeInsets.symmetric(
                                                      vertical: 14),
                                                ),
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Theme.of(context)
                                                            .primaryColor),
                                                shape:
                                                    MaterialStateProperty.all(
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
                              text: Text(_isSaving ? 'Saving…' : 'Enter food',
                                  style: textStyle2),
                              onTap: _saveFood)
                        ]))
              ]));
            })));
  }

  Future<void> _saveFood() async {
    if (_isSaving) return;
    final user = FirebaseAuth.instance.currentUser;
    final caloriesPer100g = servCalorie;
    final name = Name?.trim();
    if (user == null) {
      _showError('Please sign in before adding food.');
      return;
    }
    if (!found || name == null || name.isEmpty || caloriesPer100g == null) {
      _showError(
          _errorMessage ?? 'Scan a food with calorie information first.');
      return;
    }
    if (servingSize <= 0) {
      _showError('Select a serving size greater than zero.');
      return;
    }

    setState(() => _isSaving = true);
    try {
      final now = DateTime.now();
      final totalCalories = caloriesPer100g / 100 * servingSize * servings;
      final firestore = FirebaseFirestore.instance;
      final latestBalanceQuery = await firestore
          .collection('remainingCalories')
          .orderBy('DateTime')
          .limitToLast(1)
          .where('userID', isEqualTo: user.uid)
          .get();
      final tdee = await getTdeeVal();
      double startingBalance = tdee;
      if (latestBalanceQuery.docs.isNotEmpty) {
        final latest = latestBalanceQuery.docs.first;
        final timestamp = latest.get('DateTime');
        if (timestamp is Timestamp &&
            _sameCalendarDate(timestamp.toDate(), now)) {
          final value = latest.get('Cals');
          startingBalance = value is num
              ? value.toDouble()
              : double.tryParse(value.toString()) ?? tdee;
        }
      }

      final dayKey =
          '${now.year.toString().padLeft(4, '0')}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
      final balanceRef =
          firestore.collection('remainingCalories').doc('${user.uid}_$dayKey');
      final foodRef = firestore.collection('Food').doc();

      await firestore.runTransaction((transaction) async {
        final currentBalance = await transaction.get(balanceRef);
        final currentValue = currentBalance.data()?['Cals'];
        final base = currentValue is num
            ? currentValue.toDouble()
            : double.tryParse(currentValue?.toString() ?? '') ??
                startingBalance;
        transaction.set(foodRef, {
          'Food Name': name,
          'userID': user.uid,
          'NumberOfServings': servings,
          'CaloriesPer100gServing': caloriesPer100g.toStringAsFixed(2),
          'ServingSize': servingSize,
          'TotalCaloriesAdded': totalCalories,
          'DateTime': now,
          'balanceDocumentId': balanceRef.id,
        });
        transaction.set(balanceRef, {
          'userID': user.uid,
          'Cals': base - totalCalories,
          'DateTime': now,
        });
      });

      if (!mounted) return;
      exitscreen(true);
    } catch (_) {
      _showError('Could not save this food. Nothing was changed. Try again.');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

//   void deductCal(String tdee, double energy100gKcal, uid, inputTime) {
//     double result = double.parse(tdee);
//     double calRemaining = result - energy100gKcal;

//     FirebaseFirestore.instance.collection('remainingCalories').add({
//       'userID': uid,
//       'Cals': calRemaining,
//       'DateTime': inputTime,
//     });
//   }
}
