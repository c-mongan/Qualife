import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<String> getCurrentUID() async {
  String uid = await FirebaseAuth.instance.currentUser!.uid;
  return uid;
}

Future<void> userSetup(String gender) async {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = auth.currentUser!.uid.toString();

  users.add({
    'gender': gender,
    'uid': uid,
  });

  return;
}
