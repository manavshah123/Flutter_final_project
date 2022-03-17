import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:texttask/Homescreen.dart';
import '../model/user_model.dart';

List tasklistname = [];
List tasklistdes = [];
List tasklistuser = [];
UserModel loggedInUser = UserModel();

class DatabaseTaskManager {
  final CollectionReference profileList =
  FirebaseFirestore.instance.collection('task');
  User? user = FirebaseAuth.instance.currentUser;

  Future getUsersList(UserModel loggedInUser) async {
    List itemsList = [];
    try {
      await profileList.get().then((querySnapshot) {
        itemsList.clear();
        tasklistname.clear();
        tasklistdes.clear();
        tasklistuser.clear();

        querySnapshot.docs.forEach((element) {
          itemsList.add(element.data());
          print(itemsList);
        });
        print(loggedInUser.fname.toString());
        itemsList.forEach((element) {
          print(element['user']);
          if(element['user'].toString() == loggedInUser.fname.toString()){
            tasklistname.add(element['name'].toString());
            tasklistdes.add(element['des'].toString());
            tasklistuser.add(element['user'].toString());
          }
        });
      });
      return itemsList;
    }
    catch (e) {
      print(e.toString());
      return null;
    }
  }
}