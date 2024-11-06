import 'package:finpal/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';

class SettingsFragment extends StatefulWidget {
  final String name;
  final String phone;
  final String email;
  SettingsFragment(
      {super.key,
      required this.name,
      required this.phone,
      required this.email});
  @override
  State<StatefulWidget> createState() => _SettingsFragmentState();
}

class _SettingsFragmentState extends State<SettingsFragment> {
  var canNotify = true;
  var autoLogin = true;
  final _database = Hive.box("settings");
  var userId;

  @override
  void initState() {
    userId = FirebaseAuth.instance.currentUser!.uid;
    setState(() {});
    super.initState();
  }

  void changePassword() async {
    loading();
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: widget.email)
        .then((value) {
      Navigator.pop(context);
      Navigator.pop(context);
      passSent(context);
    }).catchError(() {});
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

  void passMenu(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              width: 300,
              height: 400,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "lib/images/passreset.png",
                      width: 200,
                    ),
                    Text("Password Change",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(
                      width: 200,
                      child: Text(
                        "By clicking proceed an password link would be sent to your email",
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        changePassword();
                      },
                      child: Container(
                        height: 40,
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: accent,
                        ),
                        child: Center(
                            child: Text(
                          "Proceed",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        )),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  void passSent(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              width: 200,
              height: 250,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: accent,
                      size: 50,
                    ),
                    Text("Password link sent",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(
                      width: 200,
                      child: Text(
                        "Reset link has been sent to " + widget.email,
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 50, height: 50,
                      decoration: BoxDecoration(color: accent,borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: Icon(FontAwesomeIcons.gear,color: Colors.white,)
                      ),
                    Column( crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Settings",style: TextStyle(color: accent,fontWeight: FontWeight.bold,fontSize: 20),),
                        Text("Customize app",style: TextStyle(color: accent,fontSize: 12),),
                      ],
                    )
                  ],
                ),
              ),
            ), //Settings label

            //User Panel
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(255, 221, 221, 221),
                        blurRadius: 6)
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Hello!", style: TextStyle(fontSize: 28)),
                    Text(widget.name,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text("${userId}", style: TextStyle(fontSize: 12)),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 30,
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: accent),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.circleUser,
                            size: 18,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "App User",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text("Account",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(
              height: 10,
            ),

            //Change Number
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(255, 234, 234, 234),
                        blurRadius: 6)
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: accent,
                          ),
                          child: Icon(
                            FontAwesomeIcons.envelope,
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.email,
                          style: TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),

            //Change Password
            GestureDetector(
              onTap: () {
                passMenu(context);
                //passSent(context);
              },
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromARGB(255, 234, 234, 234),
                          blurRadius: 6)
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              color: accent,
                            ),
                            child: Icon(
                              FontAwesomeIcons.lock,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Change Password",
                            style: TextStyle(fontSize: 12),
                          )
                        ],
                      ),
                      Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Icon(
                            FontAwesomeIcons.chevronRight,
                            size: 14,
                          )),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(
              height: 20,
            ),
            Text("App",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(
              height: 10,
            ),

            //Auto Login
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(255, 234, 234, 234),
                        blurRadius: 6)
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: accent,
                          ),
                          child: Icon(
                            FontAwesomeIcons.rotate,
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Auto Login",
                          style: TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                    Switch(
                      value: autoLogin,
                      activeColor: accent,
                      onChanged: (bool value) {
                        setState(() {
                          autoLogin = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),

            //Notification
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(255, 234, 234, 234),
                        blurRadius: 6)
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: accent,
                          ),
                          child: Icon(
                            FontAwesomeIcons.bell,
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Notification",
                          style: TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                    Switch(
                      value: canNotify,
                      activeColor: accent,
                      onChanged: (bool value) {
                        setState(() {
                          canNotify = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(
              height: 20,
            ),
            Text("Misc",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(
              height: 10,
            ),

            GestureDetector(
              onTap: () {
                _database.delete("user");
                FirebaseAuth.instance.signOut();
              },
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromARGB(255, 234, 234, 234),
                          blurRadius: 6)
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              color: accent,
                            ),
                            child: Icon(
                              FontAwesomeIcons.powerOff,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Logout",
                            style: TextStyle(fontSize: 12),
                          )
                        ],
                      ),
                      Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Icon(
                            FontAwesomeIcons.arrowRightFromBracket,
                            size: 14,
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
