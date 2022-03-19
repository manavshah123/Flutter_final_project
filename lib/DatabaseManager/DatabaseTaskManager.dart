import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:texttask/Homescreen.dart';
import '../model/user_model.dart';

List tasklistname = [];
List tasklistdes = [];
List tasklistuser = [];
List taskstatus = [];
List taskid = [];
UserModel loggedInUser = UserModel();

class DatabaseTaskManager {
  final CollectionReference profileList =
  FirebaseFirestore.instance.collection('task');
  User? user = FirebaseAuth.instance.currentUser;

  Future updatestatus (String id, taskupdate) async{
    FirebaseFirestore.instance.collection('task').doc(id).update({'status': taskupdate});
    if (taskupdate == "Completed"){
      FirebaseFirestore.instance.collection('task').doc(id).delete();
      DatabaseTaskManager().getUsersList(loggedInUser);
    }
  }
  Future getUsersList(UserModel loggedInUser) async {
    List itemsList = [];
    try {
      await profileList.get().then((querySnapshot) {
        itemsList.clear();
        tasklistname.clear();
        tasklistdes.clear();
        tasklistuser.clear();
        taskstatus.clear();
        taskid.clear();

        querySnapshot.docs.forEach((element) {
          itemsList.add(element.data());
          print(itemsList);
        });
        print(loggedInUser.fname.toString());
        itemsList.forEach((element) {
          print(element['user']);
          if((element['user'].toString() == loggedInUser.fname.toString()) && loggedInUser.type.toString() == 'user'){
            tasklistname.add(element['name'].toString());
            tasklistdes.add(element['des'].toString());
            tasklistuser.add(element['user'].toString());
            taskstatus.add(element['status'].toString());
            taskid.add(element['tid'].toString());

          }
          else{
            tasklistname.add(element['name'].toString());
            tasklistdes.add(element['des'].toString());
            tasklistuser.add(element['user'].toString());
            taskstatus.add(element['status'].toString());
            taskid.add(element['tid'].toString());
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