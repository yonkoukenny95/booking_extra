import 'dart:convert';
import 'dart:io';
import 'package:booking_extra/util/dialog.dart';
import 'package:open_file/open_file.dart';

import 'package:booking_extra/util/constant.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class InfoAppPage extends StatefulWidget {
  InfoAppPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _InfoAppPageState createState() => _InfoAppPageState();
}

class _InfoAppPageState extends State<InfoAppPage> {
  bool isDownloaded = false;
  bool downloading = false;
  String progress = '0';
  @override
  void initState() {
    super.initState();
  }

  void downloadFile(String url, String fileName, String savePath) async {
    try {
      setState(() {
        downloading = true;
        print("downloading");
      });

      Dio().download(url + fileName, savePath, onReceiveProgress: (rcv, total) {
        setState(() {
          progress = ((rcv / total) * 100).toStringAsFixed(0);
        });
        if (progress == '100') {
          setState(() {
            isDownloaded = true;
          });
        } else if (double.parse(progress) < 100) {}
      }).then((_) {
        setState(() {
          if (progress == '100') {
            isDownloaded = true;
          }
          downloading = false;
          OpenFile.open(savePath);
        });
      });
    } catch (ex) {
      Dialogs.showMessage(
          context,
          "Thông báo",
          "Phiên bản hiện tại (" +
              appVersion +
              ") là bản mới nhất hoặc không có thông tin của bản cập nhật mới hơn (" +
              nextVersion +
              ").");
      setState(() {
        downloading = true;
      });
      print(ex.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final checkUpdateButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(5.0),
      color: Color(0xff134F89),
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          final appStorage = await getApplicationDocumentsDirectory();
          String savePath = '${appStorage.path}/' + upgradeFile;
          print(savePath);
          downloadFile(urlDownloadUpgrade, upgradeFile, savePath);
        },
        child: Text("Cập nhật phiên bản",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      appBar: new AppBar(
        title: Text('Thông tin phiên bản'),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: (!downloading)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Phiên bản',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, // light
                              fontStyle: FontStyle.italic,
                              fontSize: 20 // italic
                              ),
                        ),
                        SizedBox(height: 35),
                        Text(
                          appName,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18 // italic
                              ),
                        ),
                        SizedBox(height: 15),
                        Text('App version: ' + appVersion),
                        SizedBox(height: 15),
                        Text('Package Name: ' + packageName),
                        SizedBox(height: 15),
                        Text('Ngày cập nhật phiên bản: ' + lastUpdate),
                        SizedBox(height: 150),
                        checkUpdateButton,
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Phiên bản',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, // light
                              fontStyle: FontStyle.italic,
                              fontSize: 20 // italic
                              ),
                        ),
                        SizedBox(height: 35),
                        Text(
                          appName,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18 // italic
                              ),
                        ),
                        SizedBox(height: 15),
                        Text('App version: ' + nextVersion),
                        SizedBox(height: 35.0),
                        Text('$progress%'),
                        SizedBox(height: 15.0),
                        Text('Đang tải xuống...'),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
