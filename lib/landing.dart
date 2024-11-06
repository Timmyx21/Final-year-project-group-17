// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finpal/articleFragment.dart';
import 'package:finpal/budget.dart';
import 'package:finpal/constants.dart';
import 'package:finpal/homeFragment.dart';
import 'package:finpal/memoFragment.dart';
import 'package:finpal/settingsFragment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';

class Landing extends StatefulWidget {
  const Landing({
    super.key,
  });
  @override
  State<StatefulWidget> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  int _selectedIndex = 0;

  final _database = Hive.box("settings");

  var hasData = true; //To skip to the main part
  var name = "";
  var phone = "";
  var email = "";
  var userId;

  List<Widget> pages = [];

  @override
  void initState() {
    var log = _database.get("user");
    name = log["name"];
    email = log["email"];
    pages = [Homefragment(), Memofragment(key: UniqueKey(),),articleFragment(),Budget(),SettingsFragment(name: name,phone: "+233254567880",email: email,)];
    userId = FirebaseAuth.instance.currentUser!.uid;
    //readUsers();
    super.initState();
  }

  void readUsers() {
    FirebaseFirestore.instance
        .collection("users")
        .where("id", isEqualTo: userId)
        .get()
        .then((documents) {
      if (documents.size > 0) {
        hasData = true;
        name = documents.docs.first.get("name");
        phone = documents.docs.first.get("phone");
        email = documents.docs.first.get("email");
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (hasData == false)
          ? Center(
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
          : IndexedStack(
            children: pages,
            index: _selectedIndex,
            
          ),

      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
        child: GNav(
            selectedIndex: _selectedIndex,
            onTabChange: (value) {
              setState(() {
                _selectedIndex = value;

                if (_selectedIndex == 1) {

                  setState(() {
                    pages.removeAt(1);
                    pages.insert(1,  Memofragment(key: UniqueKey(),));

                  });
                }

              });
            },
            padding: EdgeInsets.all(10.0),
            tabBackgroundColor: accent,
            color: accent,
            activeColor: Colors.white,
            tabs: [
              GButton(
                icon: FontAwesomeIcons.robot,
                gap: 10,
                text: "Chat",
                iconSize: 16,
              ),
              GButton(
                icon: FontAwesomeIcons.list,
                gap: 10,
                text: "Memo",
                iconSize: 16,
              ),
              GButton(
                icon: FontAwesomeIcons.book,
                gap: 10,
                text: "Article",
                iconSize: 16,
              ),
              GButton(
                icon: FontAwesomeIcons.chartPie,
                gap: 10,
                text: "Budget",
                iconSize: 16,
              ),
              GButton(
                icon: FontAwesomeIcons.gear,
                gap: 10,
                text: "Settings",
                iconSize: 16,
              ),
            ]),
      ),
    );
  }
}
