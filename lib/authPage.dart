import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finpal/landing.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:finpal/constants.dart';
import 'package:finpal/started.dart';
import 'package:hive/hive.dart';

class authPage extends StatelessWidget {
  const authPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return userAuth(); //Logged In
            } else {
              return getStarted(); //Logged Out
            }
          }),
    );
  }
}

class userAuth extends StatefulWidget {
  @override
  State<userAuth> createState() => _userAuthState();
}

class _userAuthState extends State<userAuth> {
  final _database = Hive.box("settings");
  var bodyIndex = 0;
  var userId;

  @override
  void initState() {
    userId = FirebaseAuth.instance.currentUser!.uid;
    super.initState();
    checkUser();
  }

  void checkUser() async {
    if(_database.containsKey("user")){
        setState(() {
          bodyIndex = 1;
        });
    }
    else{
      var database = await Hive.openBox("database01" + userId);
      var database2 = await Hive.openBox("database02" + userId);
      await FirebaseFirestore.instance.collection("users").where('id', isEqualTo: userId).get().then((snapshot) {
        if (snapshot.size > 0) {
          var name = snapshot.docs.first.get("name");
          var email = snapshot.docs.first.get("email");
          _database.put("user",{"name":name,"email":email});
          
          setState(() {
            bodyIndex = 1;
          });
        } 
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(body:
    (bodyIndex == 0) ? Center(
      child: SpinKitFadingFour(
        itemBuilder: (BuildContext context, int index) {
          return DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: accent,
            ),
          );
        },
      ),
    )
    : Landing());
  }
}
