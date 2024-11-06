import 'dart:math';

import 'package:flutter/material.dart';

const accent = Color.fromRGBO(38, 34, 98, 1);
const light_accent = Color.fromRGBO(145, 141, 201, 1);
const lighter_accent = Color.fromRGBO(231, 230, 248, 1);
const complement = Colors.orange;
const gray = Color.fromARGB(255, 236, 236, 236);


String generateHash(){
    var _final = "";
    var dict = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
    for (var i = 0; i < 10; i++) {
      _final += dict[Random().nextInt(dict.length)];
    }
    return _final;
}

String cleanString(String words){
  var _final = "";
  _final =words.replaceAll("*", "");
  var newans = _final.toString().split("\n");
  newans.removeAt(0);
  _final = newans.join("\n");
  return _final;
}

List GetUniqueNumbers(int count, int max){
  List _final = [];
  bool done = false;
  while (!done){
    var newNum = Random().nextInt(max);
    if(_final.isEmpty){
      _final.add(newNum);
    }
    else if(newNum != _final.last){
      _final.add(newNum);
    }
    if(_final.length == count){
      return _final;
    }
  }
}