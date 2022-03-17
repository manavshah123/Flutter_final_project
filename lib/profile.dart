import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'model/user_model.dart';

class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  _profileState createState() => _profileState();
}

class _profileState extends State<profile> {

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      print(loggedInUser);
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(height: 40,),
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/profile.png'),
              ),
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(loggedInUser.fname??'',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
                SizedBox(width: 10,),
                Text(loggedInUser.lname??'',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
              ],
            ),
            SizedBox(height: 20,),
            Text(loggedInUser.email??'',style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),),
          ],
        ),
      ),
    );
  }
}
