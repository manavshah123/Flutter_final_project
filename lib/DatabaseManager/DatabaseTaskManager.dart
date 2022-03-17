import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseTaskManager {
  final CollectionReference profileList =
  FirebaseFirestore.instance.collection('task');



  Future getUsersList() async {
    List itemsList = [];

    try {
      await profileList.get().then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          print('*******************');

          itemsList.add(element.data());
          print(itemsList);
        });
      });
      return itemsList;
    } catch (e) {
      print(e.toString());
      return null;
    }

  }
}