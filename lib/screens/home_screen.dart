import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ripeto/services/sign_in.dart';

import '../main.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Data data; //data for the courseInfo
  List courseList; //list of the course to be used
  final _firestore = FirebaseFirestore.instance; //firestore instance

  TextEditingController courseCodeController = TextEditingController();
  TextEditingController courseNameController = TextEditingController();

  String courseCode;
  String courseName;

  var stream;

  void addData(String courseCode, String courseName) {
    Map<String, dynamic> demoData = {
      'course_code': courseCode,
      'course_name': courseName,
      'date_created': FieldValue.serverTimestamp(),
    };
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .collection('course');
    collectionReference.add(demoData);
  }

  void deleteData(String courseCodeDelete) {
    _firestore
        .collection('user')
        .doc(uid)
        .collection('course')
        .doc(courseCodeDelete)
        .delete()
        .catchError(
      (error) {
        print("Failed to delete user: $error");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: courseCodeController,
                decoration: InputDecoration(hintText: 'Course Code'),
                onChanged: (value) {
                  setState(() {
                    courseCode = value;
                    print(courseCode);
                  });
                },
              ),
              TextField(
                controller: courseNameController,
                decoration: InputDecoration(hintText: 'Course Name'),
                onChanged: (value) {
                  setState(() {
                    courseName = value;
                    print(courseName);
                  });
                },
              ),
              FlatButton(
                child: Text('Submit'),
                onPressed: () {
                  addData(courseCode, courseName);

                  setState(() {
                    courseCodeController.clear();
                    courseNameController.clear();
                  });
                },
              ),
              courseListStream(),
            ],
          ),
        ),
      ),
    );
  }

  StreamBuilder<QuerySnapshot> courseListStream() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('user')
          .doc(uid)
          .collection('course')
          .orderBy('date_created')
          .snapshots(),
      builder: (context, snapshot) {
        List<CourseCard> courseList = [];
        if (snapshot.hasData) {
          final courseQuerySnapshotList = snapshot.data.docs;

          for (var courseQuerySnapshot in courseQuerySnapshotList) {
            final courseIdFetch = courseQuerySnapshot.id;
            final courseCodeFetch = courseQuerySnapshot.data()['course_code'];
            final courseNameFetch = courseQuerySnapshot.data()['course_name'];

            final delete = () {
              showAlertDialog(context, courseIdFetch);
              print('Delete button clicked');
            };

            final messageWidget = CourseCard(
              courseCode: courseCodeFetch,
              courseName: courseNameFetch,
              delete: delete,
            );
            courseList.add(messageWidget);
          }
        }
        return Container(
          height: 100.0,
          child: ListView(
            children: courseList,
            scrollDirection: Axis.horizontal,
          ),
        );
      },
    );
  }

  void showAlertDialog(BuildContext context, String courseIdDelete) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text(
        "Cancel",
        style: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text(
        "Delete",
        style: TextStyle(
          color: Colors.red,
          fontSize: 16.0,
        ),
      ),
      onPressed: () {
        deleteData(courseIdDelete);
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "Delete Timer",
        style: TextStyle(
          fontSize: 17.0,
          fontWeight: FontWeight.w700,
        ),
      ),
      content: Text(
        "Are you sure you want to delete the timer?",
        style: TextStyle(
          fontWeight: FontWeight.w300,
          letterSpacing: 0.3,
        ),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class CourseCard extends StatelessWidget {
  final String courseCode;
  final String courseName;
  final delete;

  CourseCard({this.courseCode, this.courseName, this.delete});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      height: 100.0,
      child: Card(
        child: Column(
          children: [
            Text(courseCode != null ? courseCode : ''),
            Text(courseName != null ? courseName : ''),
            GestureDetector(
                onTap: delete, //delete
                child: Icon(
                  Icons.delete,
                  color: Colors.red,
                ))
          ],
        ),
      ),
    );
  }
}
