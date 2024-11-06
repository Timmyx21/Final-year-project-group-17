import 'package:finpal/constants.dart';
import 'package:flutter/material.dart';
import 'package:finpal/signup.dart';

class getStarted extends StatelessWidget {
  const getStarted({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Colors.white,
              Color.fromARGB(255, 255, 255, 255),
              Colors.white
            ])),
          ),
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    height: 300,
                    child: Center(
                      child: Image.asset(
                        "lib/images/splash_a.png",
                        width: 400,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                //Get Started here
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: const Text(
                    "Welcome to Finpal®",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 48, 48, 48)),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),

                //Small Info Here
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: const Text(
                    "Finpal® is a modern intelligent Natural Language Processing Chatbot that is aimed at assisting in the field of Finance. Let's get going!",
                    style: TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),

                //Button Here
                GestureDetector(
                  onTap: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Signup()))
                  },
                  child: Container(
                    width: 200,
                    decoration: BoxDecoration(
                        color: accent,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromARGB(255, 255, 255, 255),
                              spreadRadius: 1)
                        ]),
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Get Started",
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontWeight: FontWeight.bold),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right_rounded,
                          color: Color.fromARGB(255, 255, 255, 255),
                        )
                      ],
                    )),
                  ),
                ),
              ]),
        ]),
      ),
    );
  }
}
