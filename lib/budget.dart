
import 'package:finpal/StringValues.dart';
import 'package:finpal/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';

class Budget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BudgetState();
}

class BudgetState extends State<Budget> {
var userId = FirebaseAuth.instance.currentUser!.uid;
var _database;
final TextEditingController income_txt = TextEditingController();
final TextEditingController title_txt = TextEditingController();
final TextEditingController amount_txt = TextEditingController();

var income = 0.0;
var expenditure = 0.0;
var percentage = 0.0;
List entries = [];
var numList = GetUniqueNumbers(3, tips.length);

PageController controller = PageController(initialPage: 0);
var indicatorValue = 0;

@override
  void initState() {
    _database = Hive.box("database02" + userId);
    //print(numList);
    readDatabase();
    super.initState();
  }

void saveIncome(){
    if(!income_txt.text.isEmpty){
      _database.put("income", {"amount":income_txt.text});
      readDatabase();
      Navigator.pop(context); 
    }
    else{Fluttertoast.showToast(msg: "Give us your Income as amount");}
       
    setState(() {});
}

void saveExpense(String hash){
    if(!title_txt.text.isEmpty && !amount_txt.text.isEmpty){
      var newHash = generateHash();
      if(!hash.isEmpty){
          newHash = hash; 
      }
      _database.put(newHash, {"title":title_txt.text,"amount":amount_txt.text, "hash":newHash});      
      title_txt.clear();
      amount_txt.clear();
    }
    else{Fluttertoast.showToast(msg: "Don't leave any field Empty");}
    
    readDatabase();
    Navigator.pop(context);
  }

void readDatabase(){
  var _keys = _database.keys;
  entries.clear();
  expenditure = 0;
    for (var k in _keys) {
      var log = _database.get(k);
      //_database.delete(k);
      if(k != "income"){
        entries.add(log);
        expenditure += num.tryParse(log["amount"])!.toDouble();       
      }
      else {income = double.parse(log["amount"].toString());}
      //print(entries);
      if(income > 0){
        percentage = ((expenditure/income) * 100).truncateToDouble();
      }
      
      
    }
    setState(() {});
}


void AddModal(context,bool isEdit,String hash) {
    
    if(isEdit){
     var log = _database.get(hash);
     title_txt.text = log["title"];
     amount_txt.text = log["amount"];
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: 
                Container(
                  width: 300,
                  height: 400,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                       (!isEdit) ? Center() : GestureDetector(
                          onTap: () {
                            ConfirmAction(context, hash);
                          },
                          child: Container(
                            width: 100,
                            padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                            decoration: BoxDecoration( color: gray, borderRadius: BorderRadius.all(Radius.circular(20))),
                            child: Row(
                              children: [
                                Icon(Icons.delete_outline),
                                Text("Remove",),
                                ],
                              ),
                            ),
                        ),

                        SizedBox(height: 20,),
                       
                        Text( (isEdit) ? "Edit Expence":"Add Expense",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(
                          width: 200,
                          child: Text(
                            "Set a financial target for a category of items ",
                            style: TextStyle(fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                
                        TextField(
                          controller: title_txt,                    
                          decoration: InputDecoration(
                            hintText: "Title", hintStyle: TextStyle(fontWeight: FontWeight.w400,fontSize: 14),
                            border: OutlineInputBorder(borderSide: BorderSide(width: 1,), borderRadius: BorderRadius.all(Radius.circular(10)))
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: amount_txt,
                          keyboardType: TextInputType.number,                                      
                          decoration: InputDecoration(                        
                            hintText: "Amount", hintStyle: TextStyle(fontWeight: FontWeight.w400,fontSize: 14),
                            border: OutlineInputBorder(borderSide: BorderSide(width: 1,), borderRadius: BorderRadius.all(Radius.circular(10)))
                          ),
                        ),
                
                        SizedBox(
                          height: 20,
                        ),
                
                        GestureDetector(
                          onTap: () {
                            (isEdit)? saveExpense(hash) : saveExpense("");
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
                              "Save",
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

void AddIncomeModal(context) {
  if(income != 0){income_txt.text = income.toString();}
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              width: 300,
              height: 300,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Add Income",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(
                      width: 200,
                      child: Text(
                        "What's your appoximate Income",
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    TextField(
                      controller: income_txt,
                      keyboardType: TextInputType.number,                                      
                      decoration: InputDecoration(                        
                        hintText: "Amount", hintStyle: TextStyle(fontWeight: FontWeight.w400,fontSize: 14),
                        border: OutlineInputBorder(borderSide: BorderSide(width: 1,), borderRadius: BorderRadius.all(Radius.circular(10)))
                      ),
                    ),

                    SizedBox(
                      height: 20,
                    ),

                    GestureDetector(
                      onTap: () {
                        saveIncome();
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
                          "Save",
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
                            readDatabase();
                            Navigator.pop(context);
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
          child: Stack(
            children: [              
              Column(
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
                          child: Icon(FontAwesomeIcons.chartPie,color: Colors.white,)
                          ),
                        Column( crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("Budget",style: TextStyle(color: accent,fontWeight: FontWeight.bold,fontSize: 20),),
                            Text("Financial Goals",style: TextStyle(color: accent,fontSize: 12),),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              
                Container(
                    height:  160,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromARGB(255, 238, 238, 238),
                          blurRadius: 6)
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Daily Tips",style: TextStyle(fontWeight: FontWeight.w100,fontSize: 20), overflow: TextOverflow.ellipsis, maxLines: 2,),
                            Icon(Icons.lightbulb_circle,color: complement,size: 30,)
                          ],
                        ),
                  
                        SizedBox(height: 20,),
                        Expanded(
                          child: PageView(
                            onPageChanged: (value) {
                              setState(() {
                                indicatorValue = value;
                              });
                            },
                            controller: controller,
                            children: [
                              Text("${tips[numList[0]]}", maxLines: 3,
                              style: TextStyle(fontWeight: FontWeight.w300),),
                              Text("${tips[numList[1]]}", maxLines: 3,
                              style: TextStyle(fontWeight: FontWeight.w300),),
                              Text("${tips[numList[2]]}", maxLines: 3,
                              style: TextStyle(fontWeight: FontWeight.w300),),
                            ],
                          ),
                        ),
                        SizedBox(height: 10,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(3, 
                           (index) => Padding(
                             padding: const EdgeInsets.all(4.0),
                             child: AnimatedContainer(
                                curve: Curves.easeIn,
                                duration: const Duration(milliseconds: 400),
                                width: (index == indicatorValue) ? 20 : 10,
                                height: 10,
                                decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.all(Radius.circular(20))),
                                ),
                           )
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                            
                  SizedBox(height: 20,),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [BoxShadow(color: Color.fromARGB(255, 238, 238, 238),blurRadius: 6)],
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height:  120,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            
                            decoration: const BoxDecoration(
                            color: light_accent,
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromARGB(255, 238, 238, 238),
                                  blurRadius: 6)
                            ],
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Expenses",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 18,color: Colors.white), overflow: TextOverflow.ellipsis, maxLines: 2,),
                                    Icon(FontAwesomeIcons.circleDollarToSlot,color: Colors.white,size: 30,)
                                  ],
                                ),
                              
                                SizedBox(height: 5,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text("GH¢${income}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: accent),),
                                            SizedBox(width: 5,),
                                            GestureDetector(
                                              onTap: () {
                                                AddIncomeModal(context);
                                              },
                                              child: Container(
                                                width: 30,
                                                height: 30,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                                  color: accent,
                                                ),
                                                child: Icon(Icons.edit,color: Colors.white, size: 14,),
                                              ),
                                            )
                                          ],
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(vertical: 2,horizontal: 6),
                                          decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.white),
                                        borderRadius: BorderRadius.all(Radius.circular(20))),
                                        child: Text("Income",style: TextStyle(color: Colors.white),)),
                                      ],
                                    ),
                                    
                                    Container(                            
                                        width: 80, alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                        decoration: BoxDecoration( color: complement, borderRadius: BorderRadius.all(Radius.circular(20))),
                                        child: Text("${percentage}%",style: TextStyle(fontWeight: FontWeight.bold),),
                                      ),
                                    
                                    Column(
                                      children: [
                                        Text("GH¢${expenditure}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white),),
                                        Container(
                                          padding: EdgeInsets.symmetric(vertical: 2,horizontal: 6),
                                          decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.white),
                                        borderRadius: BorderRadius.all(Radius.circular(20))),
                                        child: Text("Expenditure",style: TextStyle(color: Colors.white),)),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                    
                          SizedBox(height: 20,),
                          (entries.length == 0)
                           ? Center(child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.face_2_rounded,size: 30,),
                              Text("No Entries added",style: TextStyle(fontWeight: FontWeight.w100,fontSize: 24),),
                              Text("Press add button to insert a new entry",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 14),)
                            ],
                           ),)    
                          : Expanded(
                            child: ListView.builder(
                              itemCount: entries.length,
                              itemBuilder: (context,position){
                                return 
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      child: Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                AddModal(context, true, entries[position]["hash"]);
                                              },
                                              child: Container(
                                                width: 30,
                                                height: 30,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                                  color: accent,
                                                ),
                                                child: Icon(Icons.edit,color: Colors.white, size: 14,),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        "${entries[position]["title"]}", style: TextStyle(fontSize: 12), 
                                                      ),
                                                      Text(
                                                        "¢${entries[position]["amount"]}", style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold), 
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 5,),
                                                  Row(
                                                    children: [
                                                      Container(width: 200, height: 2, decoration: BoxDecoration(color: complement),),
                                                      Expanded(child: Container(height: 2, decoration: BoxDecoration(color: const Color.fromARGB(255, 224, 224, 224)),)),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                      ),
                                    ),
                                    SizedBox(height: 15,),
                                    
                                  ],
                                );       
                            }),
                          )
                        ],
                      ),
                    ),
                  ),
                        
                  
                        
                ],
              ),
          
              Column(
                mainAxisAlignment: MainAxisAlignment.end,                                
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [                      
                      GestureDetector(
                        onTap: () {
                          AddModal(context,false,"");
                        },
                        child: Container(
                        width: 80,
                        margin: EdgeInsets.all(20),
                        padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                        decoration: BoxDecoration( color: lighter_accent, borderRadius: BorderRadius.all(Radius.circular(20))),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,                        
                          children: [
                            Icon(Icons.add_circle,color: Colors.black,),
                            Text("Add",style: TextStyle(color: Colors.black),),
                        ],
                                        ),
                                      ),
                      ),
                    ],
                  )
              ]),
            ],
          ),
      ),
    );
  }
}
