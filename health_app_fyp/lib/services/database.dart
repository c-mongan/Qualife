import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  //collection reference
  final CollectionReference userDataCollection = FirebaseFirestore.instance
      .collection('UserData'); //Firestore will create this collection for us

  Future updateUserData(int age, String gender, int height, int weight,
      int activityLevel) async {
    return await userDataCollection.doc(uid).set(({
          'age': age,
          'gender': gender,
          'height': height,
          'weight': weight,
          'activityLevel': activityLevel,
          
        }));

        
  }

  
}
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

