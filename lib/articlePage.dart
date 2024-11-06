import 'package:finpal/constants.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Articlepage extends StatefulWidget{
  final String link;
  Articlepage({super.key, required this.link});
  
  @override
  State<Articlepage> createState() => _ArticlepageState();
}

class _ArticlepageState extends State<Articlepage> {

var hasLoaded = false;  

 var controller = WebViewController();
  
  @override
  void initState() {

    controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    controller.setBackgroundColor(const Color(0x00000000));
    controller.setNavigationDelegate(
    NavigationDelegate(
      onProgress: (int progress) {
        // Update loading bar.
        
      },
      onPageStarted: (String url) {},
      onPageFinished: (String url) {setState(() {
        hasLoaded = true;
      });},
      onHttpError: (HttpResponseError error) {},
      onWebResourceError: (WebResourceError error) {},
      onNavigationRequest: (NavigationRequest request) {
        if (request.url.startsWith('https://www.youtube.com/')) {
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
    ),
  );

    controller.loadRequest(Uri.parse(widget.link));
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: GestureDetector(
        onTap: () {Navigator.pop(context);},
        child: Icon(Icons.chevron_left)),),
      body: SafeArea(child: Stack(
        children: [
          Expanded(child: WebViewWidget(            
            controller: controller,
            )),
          Center(child: (!hasLoaded) ? LoadingAnimationWidget.staggeredDotsWave(color: accent, size: 50) : Center(),)
        ],
      )),
    );
  }
}