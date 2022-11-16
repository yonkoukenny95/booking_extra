import 'package:booking_extra/main.dart';
import 'package:booking_extra/screen/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart';

class WebView extends StatefulWidget {
  WebView({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  final flutterWebViewPlugin = new FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();
    flutterWebViewPlugin.onUrlChanged.listen((String url) {
      if (url == "http://pqe.seago.vn:5000/BookTicket") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SearchPage()),
        );
        flutterWebViewPlugin.close();
        flutterWebViewPlugin.getCookies().then((Map<String, String> _cookies) {
          _cookies.forEach((key, value) {
            if(key == '\"HB.ASPXAUTH'){
              MyApp().setTokenSession("HB.ASPXAUTH=${value.replaceAll('\"','')}");
              print(MyApp().getTokenSession());
            }
          });
        });

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: 'http://pqe.seago.vn:5000/',
      withLocalStorage: true,
      clearCache: true, // <-- first clearCache
      appCacheEnabled: false,
      hidden: true,
      userAgent:
          "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36",
      appBar: new AppBar(
        centerTitle: true,
        title: new Text("Login"),
      ),
      initialChild: Container(
        child: new Center(
          child: new CupertinoActivityIndicator(
            animating: true,
          ),
        ),
      ),
    );
  }
}
