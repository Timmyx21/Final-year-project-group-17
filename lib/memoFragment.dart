// ignore_for_file: prefer_const_constructors

import 'dart:ffi';

import 'package:finpal/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';

class Memofragment extends StatefulWidget {
  Memofragment({super.key});
  @override
  State<StatefulWidget> createState() => MemoFragmentState();
}

class MemoFragmentState extends State<Memofragment> {
  var _database;
  var userId = FirebaseAuth.instance.currentUser!.uid;
  List memoList = [];
  List attribute = [false];


  @override
  void initState() {
    _database = Hive.box("database01" + userId);
    readMemo();
    super.initState();
  }

  

  void readMemo(){
    var _keys = _database.keys;
    memoList.clear();
    for (var k in _keys) {
      var log = _database.get(k);
      memoList.add(log);
      print(log["hash"]);
      attribute.add(false);
    }
    //_database.clear();
    
    setState(() {});
  }

  void ConfirmAction(context,String hash) {
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: accent,
                      size: 50,
                    ),
                    Text("Confirm removal",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(
                      width: 200,
                      child: Text(
                        "Are you sure you want to remove Item?",
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    SizedBox(height: 20,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _database.delete(hash);                            
                            Navigator.pop(context);
                            readMemo();
                          },
                          child: Container(
                            height: 40,width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(50)),
                              color: accent,
                            ),
                            child: Center(
                                child: Text(
                              "Yes",
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            )),
                          ),
                        ),

                        SizedBox(width: 20,),

                        GestureDetector(
                          onTap: () {Navigator.pop(context);},
                          child: Container(
                            height: 40,width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(50)),
                              color:gray,
                            ),
                            child: Center(
                                child: Text(
                              "No",
                              style: TextStyle( fontSize: 12),
                            )),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
             Container(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 50, height: 50,
                      decoration: BoxDecoration(color: accent,borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: Icon(FontAwesomeIcons.list,color: Colors.white,)
                      ),
                    const Column( crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Memo",style: TextStyle(color: accent,fontWeight: FontWeight.bold,fontSize: 20),),
                        Text("from conversations",style: TextStyle(color: accent,fontSize: 12),),
                      ],
                    )
                  ],
                ),
              ),
            ),

            Expanded(
              child: (memoList.length ==0) ? Center(
                child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.face_2_rounded,size: 30,),
                        Text("No Memos Yet",style: TextStyle(fontWeight: FontWeight.w100,fontSize: 24),),
                        Text("Save responses from chatbot",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 14),)
                      ],
                      ),

              ) : ListView.builder(
                itemCount: memoList.length,
                itemBuilder: (context,position){
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      attribute[position] = !attribute[position];
                    });
                  },
                  child: Container(
                    height: (attribute[position] == false) ? 150 : 400,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                    decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromARGB(255, 238, 238, 238),
                          blurRadius: 6)
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Column(
                      children: [
                        Row(children: [
                          Container(
                              width: 20, height: 20,
                              decoration: const BoxDecoration(color: complement,borderRadius: BorderRadius.all(Radius.circular(50))),
                              child:const Icon(FontAwesomeIcons.question,color: Colors.white, size: 10,)
                            ), const SizedBox(width: 10,),
                            Text(memoList[position]["quest"],style: TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,)
                        ],),
                        const SizedBox(height: 10,),
                        const Divider(height: 2, color: gray, endIndent: 100, ),
                        const SizedBox(height: 10,),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            Container(
                                width: 20, height: 20,
                                decoration: BoxDecoration(color: complement,borderRadius: BorderRadius.all(Radius.circular(50))),
                                child: Icon(FontAwesomeIcons.ellipsis,color: Colors.white, size: 10,)
                              ), SizedBox(width: 10,),
                              (attribute[position] == true) 
                              ? Expanded(child: SingleChildScrollView(child: Text(memoList[position]["ans"])))
                              : Expanded(child: Text(memoList[position]["ans"],overflow: TextOverflow.ellipsis, maxLines: (attribute[position] == false) ? 2 : 100,)),
                          ],),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                GestureDetector(
                                  onTap: () {
                                    ConfirmAction(context, memoList[position]["hash"]);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                    decoration: BoxDecoration( color: gray, borderRadius: BorderRadius.all(Radius.circular(20))),
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete_outline),
                                        Text("Clear",),
                                      ],
                                    ),
                                  ),
                                ),
                          
                                Icon((attribute[position] == false) ? FontAwesomeIcons.chevronDown : FontAwesomeIcons.chevronUp)
                          
                          
                              ],),
                        )
                      ],
                    ),
                  ),
                );
              }),
            )
            ],
          ),
      ),
    );
  }
}
