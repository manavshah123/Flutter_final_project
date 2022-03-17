import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:texttask/DatabaseManager/DatabaseManager.dart';
import 'package:texttask/DatabaseManager/DatabaseTaskManager.dart';
import 'package:texttask/model/user_model.dart';

class homescreen extends StatefulWidget {
  const homescreen({Key? key}) : super(key: key);

  @override
  _homescreenState createState() => _homescreenState();
}

class _homescreenState extends State<homescreen> {

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  List tasklistname = [];
  List tasklistdes = [];
  List tasklistuser = [];
  String slected_user = 'manav';

  String dropdownValue = 'One';
  final List<String> imageList = [
    'assets/ban1.png',
    'assets/ban2.png',
    'assets/ban3.png',
    'assets/ban4.png'
  ];


  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection("users").doc(user!.uid).get().then((value){
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {
        fetchTaskDatabaseList();
      });
    });
  }


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
        title: Text("Hello artisan", style: TextStyle(fontSize: 20, color: Colors.black),),
        actions: [
          IconButton(
          onPressed: () {},
          icon: Icon(Icons.notifications, color: Colors.black))
        ],
      ),

      body: Column(
        children: [
          SizedBox(height: 30,),
          Row(
            children: [
              SizedBox(width: 25),
              Text("Recent Task", style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,),),
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
              Text("All Task", style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,),),
            ],
          ),
          SingleChildScrollView(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
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
                              SizedBox(width: 20,height: 40,),
                              Text(tasklistname[index], style: TextStyle(fontSize: 20, color: Colors.white),),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              SizedBox(width: 20,),
                              Text('Task Assigned to: ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400,color: Colors.white),),
                              Text(tasklistuser[index], style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,color: Colors.white),),
                            ],
                          ),
                          SizedBox(height: 20,),
                          Row(
                            children: [
                              SizedBox(width: 20,),
                              Text('Description', style: TextStyle(color: Colors.white),),
                            ],
                          ),
                          
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                                alignment: Alignment.bottomLeft,
                                child: Text(tasklistdes[index], style: TextStyle(color: Colors.white),)),
                          ),

                        ],
                      )
                    ),
                  );
                }
            ),
          ),
        ],
      ),

      floatingActionButton: loggedInUser.type == 'admin'? FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return dropdown();
            },
          );
        },
        label: const Text('Add Task'),
        icon: const Icon(Icons.add_circle),
        backgroundColor: Colors.redAccent,
      ):null,
    );
  }

  void fetchTaskDatabaseList() async{
    List result = await DatabaseTaskManager().getUsersList();
    if (result == null) {
      print('Unable to retrive');
    }
    else {
      setState(() {
        result.forEach((element) {
          tasklistname.add(element['name'].toString());
          tasklistdes.add(element['des'].toString());
          tasklistuser.add(element['user'].toString());
        });
      });
    }
    print("aaaaaaaaaaaaaaaaaaaaaaaa");
    print(tasklistname);
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
    FirebaseFirestore.instance.collection("users").doc(user!.uid).get().then((value){
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {
        fetchDatabaseList();
      });
    });
  }


    fetchDatabaseList() async{

    List result = await DatabaseManager().getUsersList();
    if(result == null){
      print('Unable to retrive');
    }
    else{
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
      validator: (value){
        if(value!.isEmpty){
          return ("Please enter your task title");
        }
        return null;
      },
      onSaved: (value) {
        taskcontroller.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.work, color: Colors.white,),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Task title",
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      style: TextStyle(color: Colors.white),

    );

    final desField = TextFormField(
      autofocus: false,
      controller: descontroller,
      validator: (value){
        RegExp regex = new RegExp(r'^.{25,}$');
        if(value!.isEmpty){
          return ("please Enter Your task discription");

        }
        if(!regex.hasMatch(value))
        {
          return ("please Enter valid discription(Minimum 25 character)");
        }
      },
      onSaved: (value) {
        descontroller.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.description, color: Colors.white,),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
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
          //logIn(taskcontroller.text, descontroller.text);
        },
        child: Text(
          "Add Task",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.redAccent, fontWeight: FontWeight.bold),
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
                  Text("Add Task", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20.0),),
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
                            icon: const Icon(Icons.arrow_downward, color: Colors.white,),
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