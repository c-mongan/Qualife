import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  //collection reference
  final CollectionReference userDataCollection = FirebaseFirestore.instance
      .collection('UserData'); //Firestore will create this collection for us

  Future updateUserInfo(
    String age1,
    String gender1,
    int height1,
    int weight1,
  ) async {
    return await userDataCollection.doc(uid).set(({
          'age1': age1,
          'gender1': gender1,
          'height1': height1,
          'weight1': weight1,
        }));
  }
}
