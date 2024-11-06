import 'package:finpal/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:finpal/authPage.dart';
import 'package:finpal/started.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'firebase_options.dart';

void main() async {
  debugPaintSizeEnabled = false;
  
  await Hive.initFlutter();
  
  var settingsdb = await Hive.openBox("settings");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

final _settings_database = Hive.box("settings");

  @override
  void initState() {
    initDatabase();
    super.initState();
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => authPage()),
      );
    });
  }

  void initDatabase() async{
    if(_settings_database.containsKey("user")){
        var userId = FirebaseAuth.instance.currentUser!.uid;
        var database = await Hive.openBox("database01" + userId);
        var database2 = await Hive.openBox("database02" + userId);
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Column(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     Row(
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       children: [
            //         Image.asset('lib/images/tone.png',width: 250,height: 250,),
            //       ],
            //     )
            //   ],
            // ),
            Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
               Animate(
                effects: [FadeEffect()],
                 child: Image.asset(                
                    'lib/images/Logo.png',
                    width: 150,
                    height: 150,
                  ),
               ),
                SizedBox(height: 10,),
               LoadingAnimationWidget.inkDrop(color: accent, size: 20)
                
            ],
          ),
        ],
        )
      ),
    );
  }
}
