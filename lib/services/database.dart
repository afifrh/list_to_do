import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

//CRUD operation in Firebase Firestore
class DatabaseMethod {
  //CREATE the data
  Future addUserDetails(Map<String, dynamic> userInfo, String id) async {
    return await FirebaseFirestore.instance
        .collection("User")
        .doc(id)
        .set(userInfo);
  }

  //READ the data
  Future<Stream<QuerySnapshot>> getUserInfo() async {
    return await FirebaseFirestore.instance.collection("User").snapshots();
  }

  //UPDATE the data
  Future updateUserDetails(String id, Map<String, dynamic> updateInfo) async {
    return await FirebaseFirestore.instance
        .collection("User")
        .doc(id)
        .update(updateInfo);
  }

  //DELETE the data
  Future deleteUserDetails(String id) async {
    return await FirebaseFirestore.instance.collection("User").doc(id).delete();
  }
}
