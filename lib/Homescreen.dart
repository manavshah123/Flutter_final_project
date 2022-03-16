import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:texttask/DatabaseManager/DatabaseManager.dart';
import 'package:texttask/model/user_model.dart';

class homescreen extends StatefulWidget {
  const homescreen({Key? key}) : super(key: key);

  @override
  _homescreenState createState() => _homescreenState();
}

class _homescreenState extends State<homescreen> {

  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  final _formkey = GlobalKey<FormState>();

  final TextEditingController taskcontroller = new TextEditingController();
  final TextEditingController descontroller = new TextEditingController();
  String dropdownValue = 'One';
  final List<String> imageList = [
    'assets/ban1.png',
    'assets/ban2.png',
    'assets/ban3.png',
    'assets/ban4.png'
  ];

  List userlist = [];
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection("users").doc(user!.uid).get().then((value){
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {

      });
    });
    fetchDatabaseList();
  }
  fetchDatabaseList() async{
    dynamic result = await DatabaseManager().getUsersList();
    if(result == null){
      print('Unable to retrive');
    }
    else{
      setState(() {
        userlist = result;
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
      obscureText: true,
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
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          print(userlist);
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return SingleChildScrollView(
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
                                DropdownButton<String>(
                                      value: dropdownValue,
                                      icon: const Icon(Icons.arrow_downward),
                                  elevation: 16,
                                  style: const TextStyle(color: Colors.deepPurple),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.deepPurpleAccent,
                                  ),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownValue = newValue!;
                                    });
                                  },

                                  items: <String>['One', 'Two', 'Free', 'Four']
                                      .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),

                                    );
                                  }).toList(),
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
              );
            },
          );
        },
        label: const Text('Add Task'),
        icon: const Icon(Icons.add_circle),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

}
