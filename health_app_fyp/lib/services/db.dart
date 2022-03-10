import 'package:cloud_firestore/cloud_firestore.dart';

class DbService {
  final String uid;
  DbService({required this.uid});

  //collection reference
  final CollectionReference userDataCollection = FirebaseFirestore.instance
      .collection('bmiData'); //Firestore will create this collection for us

  Future updateBMI( int bmi, String bmiTime) async {
    return await userDataCollection.doc(uid).set(({
         
          'bmi': bmi,
          'bmiTime': bmiTime,
         
        }));
  }
}
