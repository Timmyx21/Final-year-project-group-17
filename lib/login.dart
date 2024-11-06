import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:finpal/constants.dart';
import 'package:finpal/signup.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  Future makeLogin() async {
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

    if (emailController.text.toString().isEmpty &&
        passController.text.toString().isEmpty) {
    } else {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text, password: passController.text);
        Navigator.pop(context);
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        if (e.code == "user-not-found" || e.code == "invalid-credential") {
          showMessage("Wrong email or password");
        } else {
          showMessage("Error Signing In");
        }
      }
    }
  }

  void showMessage(String code) {
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            backgroundColor: accent,
            title: Center(
                child: Text(
              code,
              style: TextStyle(color: Colors.white, fontSize: 12),
            )),
          );
        }));
  }

  void cleanUp() {
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => Collector()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Stack(
            children: [
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
                      "Login",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                    const SizedBox(
                      height: 0,
                    ),
                
                    //Description text
                    const Text(
                      "Sign into your account",
                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                
                    SizedBox(
                      height: 20,
                    ),
                
                    //Email
                
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: TextField(
                        controller: emailController,
                        obscureText: false,
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
                        controller: passController,
                        obscureText: false,
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
                
                    //Proceed Button
                
                    GestureDetector(
                      onTap: () {
                        makeLogin();
                      },
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
                              "Proceed",
                              style: TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.bold),
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
                      "Getting Started?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                
                    GestureDetector(
                      onTap: () => {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Signup()))
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        child: Text("Sign Up"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
