import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:texttask/DatabaseManager/DatabaseManager.dart';
import 'package:texttask/DatabaseManager/DatabaseTaskManager.dart';
import 'package:texttask/model/user_model.dart';
import 'package:texttask/profile.dart';

class homescreen extends StatefulWidget {
  const homescreen({Key? key}) : super(key: key);

  @override
  _homescreenState createState() => _homescreenState();
}

class _homescreenState extends State<homescreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  String slected_status = 'Not yet started';

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      DatabaseTaskManager().getUsersList(loggedInUser).then((value) {
        setState(() {});
      });
    });
  }

  String slected_user = 'manav';

  String dropdownValue = 'One';
  final List<String> imageList = [
    'assets/ban1.png',
    'assets/ban2.png',
    'assets/ban3.png',
    'assets/ban4.png'
  ];

  @override
  Widget build(BuildContext context) {
    //fetchDatabaseList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          "Hello ${loggedInUser.fname.toString()}",
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    (context),
                    MaterialPageRoute(builder: (context) => profile()),
                    (route) => false);
              },
              icon: Icon(Icons.person, color: Colors.black))
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Row(
            children: [
              SizedBox(width: 25),
              Text(
                "Recent Task",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Container(
            height: 150,
            margin: EdgeInsets.all(15),
            child: CarouselSlider.builder(
              itemCount: imageList.length,
              options: CarouselOptions(
                enlargeCenterPage: true,
                height: 200,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                reverse: false,
                aspectRatio: 5.0,
              ),
              itemBuilder: (context, i, id) {
                //for onTap to redirect to another screen
                return Container(
                    child: Column(
                  children: [
                    GestureDetector(
                      child: Container(
                        //ClipRRect for image border radius
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            imageList[i],
                            width: 1000,
                            height: 150,
                          ),
                        ),
                      ),
                      onTap: () {
                        var url = imageList[i];
                        print(url.toString());
                      },
                    ),
                  ],
                ));
              },
            ),
          ),
          Row(
            children: [
              SizedBox(width: 25),
              Text(
                "All Task",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: tasklistname.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        color: Colors.redAccent,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 40,
                                ),
                                Text(
                                  tasklistname[index],
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  'Task Assigned to: ',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white),
                                ),
                                Text(
                                  tasklistuser[index],
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  'Description',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Container(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    tasklistdes[index],
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 25,
                                ),
                                Text(
                                  'Current Status',
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                DropdownButton<String>(
                                  value: taskstatus[index],
                                  icon: const Icon(Icons.arrow_downward),
                                  elevation: 16,
                                  style:
                                      const TextStyle(color: Colors.deepPurple),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.deepPurpleAccent,
                                  ),
                                  onChanged: (String? newValue) {
                                    DatabaseTaskManager()
                                        .updatestatus(taskid[index], newValue)
                                        .then((value) {
                                      Timer(Duration(seconds: 1), (){
                                        setState(() {

                                        });
                                      });
                                    });
                                    print(newValue);
                                    print(taskid[index]);
                                    taskstatus[index] = newValue!;
                                  },
                                  items: <String>[
                                    'Not yet started',
                                    'Ongoing',
                                    'Paused',
                                    'Completed'
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        )),
                  );
                }),
          ),
        ],
      ),
      floatingActionButton: loggedInUser.type == 'admin'
          ? FloatingActionButton.extended(
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return dropdown();
                  },
                ).then((value) {
                  Timer(Duration(seconds: 3), () {
                    setState(() {});
                  });
                });
              },
              label: const Text('Add Task'),
              icon: const Icon(Icons.add_circle),
              backgroundColor: Colors.black87,
            )
          : null,
    );
  }
}

class dropdown extends StatefulWidget {
  const dropdown({Key? key}) : super(key: key);

  @override
  _dropdownState createState() => _dropdownState();
}

class _dropdownState extends State<dropdown> {
  List<String> userlist = [];
  List<String> tasklist = [];

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  String slected_user = 'manav';
  final TextEditingController taskcontroller = new TextEditingController();
  final TextEditingController descontroller = new TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {
        fetchDatabaseList();
      });
    });
  }

  fetchDatabaseList() async {
    List result = await DatabaseManager().getUsersList();
    if (result == null) {
      print('Unable to retrive');
    } else {
      setState(() {
        result.forEach((element) {
          userlist.add(element['fname'].toString());
        });
        slected_user = userlist[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskField = TextFormField(
      autofocus: false,
      controller: taskcontroller,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please enter your task title");
        }
        return null;
      },
      onSaved: (value) {
        taskcontroller.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.work,
            color: Colors.white,
          ),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Task title",
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      style: TextStyle(color: Colors.white),
    );

    final desField = TextFormField(
      autofocus: false,
      controller: descontroller,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{25,}$');
        if (value!.isEmpty) {
          return ("please Enter Your task discription");
        }
        if (!regex.hasMatch(value)) {
          return ("please Enter valid discription(Minimum 25 character)");
        }
      },
      onSaved: (value) {
        descontroller.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.description,
            color: Colors.white,
          ),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Task Description",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
      style: TextStyle(color: Colors.white),
    );

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.white,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          String id = DateTime.now().toString();
          FirebaseFirestore.instance.collection('task').doc(id).set({
            'name': taskcontroller.text,
            'des': descontroller.text,
            'user': slected_user.toString(),
            'status': 'Not yet started',
            'tid': id,
          }).then((value) {
            DatabaseTaskManager().getUsersList(loggedInUser);
            Navigator.pop(context);
          });
          //logIn(taskcontroller.text, descontroller.text);
        },
        child: Text(
          "Add Task",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20,
              color: Colors.redAccent,
              fontWeight: FontWeight.bold),
        ),
      ),
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: 600,
          color: Colors.redAccent,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Add Task",
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 20.0),
                  ),
                  Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 30,
                        ),
                        taskField,
                        SizedBox(
                          height: 20,
                        ),
                        desField,
                        SizedBox(
                          height: 25,
                        ),
                        Container(
                          child: DropdownButton<String>(
                            value: slected_user,
                            icon: const Icon(
                              Icons.arrow_downward,
                              color: Colors.white,
                            ),
                            elevation: 16,
                            style: const TextStyle(color: Colors.black),
                            underline: Container(
                              height: 2,
                              width: 50,
                              color: Colors.white,
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                slected_user = newValue!;
                              });
                            },
                            items: userlist
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        loginButton,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
