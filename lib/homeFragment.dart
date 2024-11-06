// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:finpal/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Homefragment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeFragmentState();
}

class HomeFragmentState extends State<Homefragment> {

  final TextEditingController textController = TextEditingController();
  var token = "AIzaSyAeSCjF9nQjgDouW8fIpBqbOtQTHda-xbE";
  var userId = FirebaseAuth.instance.currentUser!.uid;
  var _database;
  var complete = false;

  List logs = [];
  bool canRequest = true;
  bool suggestionPopped = false;
  var lastQuestion = "";
  var turn = 0.0;

  ScrollController listScrollController = ScrollController();

  @override
  void initState() {
     _database = Hive.box("database01" + userId);
    logs.add(["Hello My name is Finpal® Bot,👋 your personal financial assistant. How can I help you?",0,generateHash()]);
    complete = true;
    setState(() {});
    //logs.add(["Nothing",404,generateHash()]);
    super.initState();
  }

  
  void insertTopic(String topic){
    List initials = ["How do I begin with","I want to learn about","Teach me about","Brief me on"];
    var question = initials[Random().nextInt(initials.length)] + " " + topic;
    List newLog = [question,1,generateHash()];
    if(canRequest){
        logs.add(newLog);
        scrollMax();
        setState(() {});
        canRequest = false;
        gptRequest(question);
    }
    setState(() {});
  }

  String generateHash(){
    var _final = "";
    var dict = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
    for (var i = 0; i < 10; i++) {
      _final += dict[Random().nextInt(dict.length)];
    }
    return _final;
  }

  void scrollMax(){
   Timer(
    Duration(milliseconds: 300),
    () => listScrollController.jumpTo(listScrollController.position.maxScrollExtent));
  }

  void popSuggestion(){
    suggestionPopped = !suggestionPopped;
    setState(() {});
  }

  void sendRequest(){
    String request = textController.text;
    if(!request.isEmpty){
      List newLog = [request,1];
      if(canRequest){
        logs.add(newLog);
        setState(() {});
        gptRequest(request);
        textController.clear();
        canRequest = false;
        scrollMax();
        
      }
    }
  }

  void gptRequest(String question) async{
    lastQuestion = question;
    final model = GenerativeModel(model: 'gemini-pro', apiKey: token);
    final outcome;
    try {
       Timer(Duration(milliseconds: 30000),(){ requestTimeout(); return;});
       outcome = await model.generateContent([Content.text(question + ". in summary")]);
       setState(() {
        var outcomeModel = outcome.text;
        logs.add([cleanString(outcomeModel.toString()),0,generateHash()]);
        canRequest = true;
        scrollMax();
        //print(outcomeModel);
      });
    } catch (e) {
      print(e.toString());
    }
  }
  

  void saveToMemo(index){
    var _question = lastQuestion;
    var _ans = logs[index][0];
    var hash = logs[index][2];
    _ans = cleanString(_ans.toString());

    _database.put(hash, {"quest":_question,"ans":_ans,"hash":hash});
    setState(() {});
    print(_database.get(hash));
  }

  void requestTimeout(){
    canRequest = true;
    logs.add(["Nothing",404,generateHash()]);
    setState(() {
      
    });
  }

  void retryRequest(){
    setState(() {
      canRequest = false;
    });
    gptRequest(lastQuestion);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Appbar Container
            Container(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        scrollMax();
                      },
                      child: Container(
                        width: 50, height: 50,
                        decoration: BoxDecoration(color: accent,borderRadius: BorderRadius.all(Radius.circular(50))),
                        child: Icon(FontAwesomeIcons.robot,color: Colors.white,)
                        ),
                    ),
                    Column( crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("ChatBot",style: TextStyle(color: accent,fontWeight: FontWeight.bold,fontSize: 20),),
                        Text("Assistance",style: TextStyle(color: accent,fontSize: 12),),
                      ],
                    )
                  ],
                ),
              ),
            ),

            //List here
            (logs.length == 0) ? Center(child: Text("Waiting.."),)
            :Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                controller: listScrollController,
                itemCount: logs.length,
                itemBuilder: (context,position){
                return(
                  Padding(padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: 
                   (logs[position][1] == 0) ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                      width: 35, height: 35,
                      decoration: BoxDecoration(color: complement,borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: Icon(FontAwesomeIcons.robot,color: Colors.white,size: 16,)
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)
                            )),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(logs[position][0]),
                                SizedBox(height: 10,),
                                (position > 0) 
                                ? GestureDetector(
                                  onTap: (){
                                    if(!_database.containsKey(logs[position][2])) {saveToMemo(position);}
                                  },
                                  child:(!_database.containsKey(logs[position][2])) ? Container(
                                    width: 80,
                                    padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                    decoration: BoxDecoration( color: gray, borderRadius: BorderRadius.all(Radius.circular(20))),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,                        
                                      children: [
                                        Icon(Icons.save_outlined),
                                        Text("Save",),
                                      ],
                                    ),
                                  )
                                  :Container(
                                    width: 90,
                                    padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                    decoration: BoxDecoration( color: Colors.greenAccent, borderRadius: BorderRadius.all(Radius.circular(20))),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,                        
                                      children: [
                                        Icon(Icons.check),
                                        Text("Saved",),
                                      ],
                                    ),
                                  ),
                                ) : Center()
                              ],
                            ),
                        ),
                      ),
                    ],
                  ) 
                  : (logs[position][1] == 404) 
                  ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                      width: 35, height: 35,
                      decoration: BoxDecoration(color: complement,borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: Icon(FontAwesomeIcons.triangleExclamation,color: Colors.white,size: 18,)
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(color: Color.fromARGB(255, 250, 247, 241),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)
                            )),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("GPT Request Timeout 😕 please check network connection and try again "),
                                SizedBox(height: 10,),
                                 GestureDetector(
                                  onTap: (){retryRequest();},
                                  child: Container(
                                    width: 80,
                                    padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                    decoration: BoxDecoration( color: gray, borderRadius: BorderRadius.all(Radius.circular(20))),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,                        
                                      children: [
                                        Icon(Icons.replay_circle_filled_outlined),
                                        Text("Retry",),
                                      ],
                                    ),
                                  ), 
                                ) 
                              ],
                            ),
                        ),
                      ),
                    ],
                  )
                  :Expanded(
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(color: light_accent,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)
                            )),
                            child: Text(logs[position][0],style: TextStyle(color: Colors.white),),
                        ),
                      ),
                  )
                );
              }),
            ),

            //PopUp Menu
            (suggestionPopped) ? Positioned(    
              child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: lighter_accent,
                borderRadius: BorderRadius.all(Radius.circular(20))
              ),
              child: Column(children: [
                Text("Any topic on finance?",style: TextStyle(fontWeight: FontWeight.bold, color: accent,fontSize: 14),),
                SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  GestureDetector(onTap: (){insertTopic("Stock Market");},
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Row(children: [Icon(FontAwesomeIcons.barChart,color: light_accent, size: 16,),SizedBox(width: 5,),Text("Stock Market",style: TextStyle(color: light_accent),)],),
                    ),
                  ),
                  SizedBox(width: 10,), //Gap
                  GestureDetector( onTap: (){insertTopic("Investment");},
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Row(children: [Icon(FontAwesomeIcons.circleDollarToSlot,color: light_accent, size: 16,),SizedBox(width: 5,),Text("Investment",style: TextStyle(color: light_accent),)],),
                    ),
                  ),
                ],),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  GestureDetector(onTap: (){insertTopic("Budgeting");},
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Row(children: [Icon(FontAwesomeIcons.penFancy,color: light_accent, size: 16,),SizedBox(width: 5,),Text("Budgeting",style: TextStyle(color: light_accent),)],),
                    ),
                  ),
                  SizedBox(width: 10,), //Gap
                  GestureDetector(onTap: (){insertTopic("Finance Management");},
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Row(children: [Icon(FontAwesomeIcons.calculator,color: light_accent, size: 16,),SizedBox(width: 5,),Text("Finance management",style: TextStyle(color: light_accent),)],),
                    ),
                  ),
                ],)
              ],),
            ))

            : Text(""),

            //Input Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Suggestion Icon
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: GestureDetector( onTap: (){popSuggestion();},
                      child: Icon(FontAwesomeIcons.ellipsis,color: accent,)),
                  ),
                  // ignore: prefer_const_constructors
                  //InputField
                  Expanded(
                    child: Stack(
                      children: [
                        Expanded(
                          child: TextField(
                            readOnly: !canRequest,
                            controller: textController,
                            style: TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              hintText: (canRequest == false) ? "Thinking.." : "Type a Question...",
                              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20)))
                              ),
                            ),
                        ),
                        (canRequest == false) ? Positioned(left: 230, top:13,child: LoadingAnimationWidget.staggeredDotsWave(color: accent, size: 30),)
                        :Center()
                      ],
                    ),
                  ),
                  //Send Button
                  GestureDetector(
                    onTap: sendRequest,
                    child: Container( 
                      width: 50, height: 50,
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: Icon(FontAwesomeIcons.paperPlane,color: Colors.white,)),
                  ),
                ],
              ),
            ),
            
          ],
          
        ),
      ),
    );
  }
}
