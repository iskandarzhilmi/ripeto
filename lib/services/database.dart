import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('users');
/*
  Future updateUserData(String courseCode, String courseName) async {
    Map<String, dynamic> data = {
      'course_code': courseCode,
      'course_name': courseName
    };
    return await collectionReference.doc(uid).set(data);
  }

 */
}
