import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:finpal/constants.dart';
import 'package:finpal/login.dart';

class Signup extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SignupState();
}

class SignupState extends State<Signup> {
  final name_cont = TextEditingController();
  final email_cont = TextEditingController();
  final pass_cont = TextEditingController();

  var userId;

  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    email_cont.dispose();
    pass_cont.dispose();
    super.dispose();
  }

  Future signUp() async {
    if (!checkEmpty()) {
      if (checkPassLength()) {
        loading();
        //creates account
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email_cont.text.toString(),
            password: pass_cont.text.toString());
        //Gets account id
        userId = FirebaseAuth.instance.currentUser!.uid;
        //Store other information on firestore
        await FirebaseFirestore.instance.collection('users').add({
          'id': userId,
          'name': name_cont.text.toString(),
          'email': email_cont.text.toString(),
          'password': pass_cont.text.toString(),
          'joined': DateTime.now().toString(),
          // ignore: unnecessary_set_literal
        });
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        showMessage("Password length should be more than 6");
      }
    } else {
      showMessage("All Fields are required");
    }
  }

  bool checkPassLength(){
    if(pass_cont.text.length > 6){
      return true;
    }
    else{
      
      return false;
    }
  }

  bool checkEmpty() {
    if (name_cont.text.isEmpty ||
        email_cont.text.isEmpty ||
        pass_cont.text.isEmpty) {
      return true;
    }
    return false;
  }

  void showMessage(String code) {
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            backgroundColor: accent,
            title: Center(
                child: Row(
              children: [
                Icon(
                  Icons.dangerous,
                  color: Colors.orange,
                ),
                SizedBox(
                  width: 30,
                ),
                Text(
                  code,
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            )),
          );
        }));
  }

  void loading() {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: SpinKitFadingFour(
              itemBuilder: (BuildContext context, int index) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.white,
                  ),
                );
              },
            ),
          );
        });
  }

  void cleanUp() {
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => Verification()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [Container()],
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Sign Up text
                  const Text(
                    "Register",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  const SizedBox(
                    height: 0,
                  ),

                  //Description text
                  const Text(
                    "Create an account",
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                  ),
                  const SizedBox(
                    height: 18,
                  ),

                  //Phone

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: TextField(
                      controller: name_cont,
                      obscureText: false,
                      keyboardType: TextInputType.phone,
                      style: TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Color.fromARGB(255, 255, 255, 255),
                        hintText: 'Username',
                        prefixIcon: Icon(
                          Icons.person,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),

                  //Email

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: TextField(
                      controller: email_cont,
                      obscureText: false,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Color.fromARGB(255, 255, 255, 255),
                        hintText: 'Email',
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),

                  //Password

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: TextField(
                      controller: pass_cont,
                      obscureText: true,
                      style: TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Color.fromARGB(255, 255, 255, 255),
                        hintText: 'Password',
                        prefixIcon: Icon(
                          Icons.password,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),

                  const SizedBox(
                    height: 18,
                  ),

                  //Proceed Button

                  GestureDetector(
                    onTap: () => {signUp()},
                    child: Container(
                      decoration: BoxDecoration(
                        color: accent,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      child: Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Sign Up",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            Icons.keyboard_arrow_right_rounded,
                            color: Colors.white,
                          )
                        ],
                      )),
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Text(
                    "Already have an account?",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  GestureDetector(
                    onTap: () => {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Login()))
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: Text("Login"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
