import 'package:finpal/articlePage.dart';
import 'package:finpal/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class articleFragment extends StatefulWidget{
  @override
  State<articleFragment> createState() => _articleFragmentState();
}

class _articleFragmentState extends State<articleFragment> {
  List finance = [];
  List extra = [];
  
  @override
  void initState() {
    finance.add({"title":"The 5 Key Components of Financial Literacy","brief":"Educators work to include a wide array of studies within the required curriculum for young adults","author":"Kathryn Knight","link":"https://www.fastweb.com/student-life/articles/the-5-key-components-of-financial-literacy"});
    finance.add({"title":"Choosing a Student Bank Account","brief":"College presents many opportunities to step up to the plate and start taking on more responsibility.","author":"Knight Randolph","link":"https://www.fastweb.com/student-life/articles/choosing-a-student-bank-account"});
    finance.add({"title":"How Getting a Part-Time Job Pays Off","brief":"It seems like as soon as high school starts, a bunch of expenses start assailing students.","author":"Osasere Ewansiha","link":"https://www.fastweb.com/student-life/articles/how-getting-a-part-time-job-pays-off"});
    finance.add({"title":"The Beauty of Budgeting","brief":"Successful businesses around the world have one thing in common","author":"Thomas J. Catalano","link":"https://www.investopedia.com/articles/pf/06/budgeting.asp"});

    extra.add({"title":"Better Digital Banking Through Data Analytics","brief":"Banks haven’t seen the savings expected from the transition to digital products and services.","author":"Mohamed Zarrugh","link":"https://www.toptal.com/finance/data-analysis-consultants/data-analytics-in-banking"});
    extra.add({"title":"Strategic Financial Leadership","brief":"Succeeding as a modern CFO is more demanding than ever before","author":"Puneet Sapra","link":"https://www.toptal.com/finance/interim-cfos/modern-cfo"});
    extra.add({"title":"Quality of Earnings","brief":"Assessing the quality of earnings is one of its key tests.","author":"Saveen Kumar","link":"https://www.toptal.com/finance/due-diligence-consultants/quality-of-earnings"});
    extra.add({"title":"How to Approach Financial Data Visualization","brief":"Looking to make your financial models more effective with better data visualization?","author":"Lursmanashvili","link":"https://www.toptal.com/finance/financial-modelers/financial-data-visualization"});
    super.initState();
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
                      child: Icon(FontAwesomeIcons.chartPie,color: Colors.white,)
                      ),
                    Column( crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Articles",style: TextStyle(color: accent,fontWeight: FontWeight.bold,fontSize: 20),),
                        Text("Explore resources",style: TextStyle(color: accent,fontSize: 12),),
                      ],
                    )
                  ],
                ),
              ),
            ),



            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("Introduction to Finance",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.black45),),
                    ),
                    Container(
                      height: 230,
                      child: Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: finance.length,
                          itemBuilder: (context,position){
                          return GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Articlepage(link: finance[position]["link"])));
                            },
                            child: Container(
                              height:  200, width: 200,
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
                                children: [
                                 Text(finance[position]['title'],style: TextStyle(fontWeight: FontWeight.w100,fontSize: 24), overflow: TextOverflow.ellipsis, maxLines: 2,),
                                 Text(finance[position]['brief'],overflow: TextOverflow.ellipsis, maxLines: 3,
                                 style: TextStyle(fontWeight: FontWeight.w100),),
                                 SizedBox(height: 30,),
                                 Container(
                                  height: 30,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(50)),
                                      color: light_accent),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(FontAwesomeIcons.circleUser,size: 18,color: Colors.white,
                                      ),
                                      SizedBox( width: 10,),
                                      Text(
                                        finance[position]['author'], overflow: TextOverflow.ellipsis,
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
                          );
                        }),
                      ),
                    ),
                
                
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("Advanced Articles",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.black45),),
                    ),
                    Container(
                      height: 230,
                      child: Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: finance.length,
                          itemBuilder: (context,position){
                          return GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Articlepage(link: extra[position]["link"])));
                              },
                            child: Container(
                              height:  200, width: 200,
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
                                children: [
                                 Text(extra[position]['title'],style: TextStyle(fontWeight: FontWeight.w100,fontSize: 24), overflow: TextOverflow.ellipsis, maxLines: 2,),
                                 Text(extra[position]['brief'],overflow: TextOverflow.ellipsis, maxLines: 3,
                                 style: TextStyle(fontWeight: FontWeight.w100),),
                                 SizedBox(height: 30,),
                                 Container(
                                  height: 30,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(50)),
                                      color: complement),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(FontAwesomeIcons.circleUser,size: 18,color: Colors.white,
                                      ),
                                      SizedBox( width: 10,),
                                      Text(
                                        extra[position]['author'], overflow: TextOverflow.ellipsis,
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
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            )
            ],
          ),
      ),
    );
  }
}