import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
RemoteMessage? remoteMessage;

class _HomeScreenState extends State<HomeScreen> {
  late InAppWebViewController webViewController;
  @override
  Widget build(BuildContext context) {
    final messageData = ModalRoute.of(context)?.settings.arguments;
    if(messageData != null){
      setState(() {
        remoteMessage = RemoteMessage.fromMap(jsonDecode(messageData.toString()));
        print(remoteMessage);
      });
    }

    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          if (await webViewController.canGoBack()) {
            webViewController.goBack();
            return false;
          }
          return true;
        },
        child: Scaffold(
          body: InAppWebView(
            onWebViewCreated: (InAppWebViewController controller) {
              webViewController = controller;
            },
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                  supportZoom: false, javaScriptEnabled: true),
            ),
            initialUrlRequest:
                URLRequest(url: Uri.parse(remoteMessage == null?'https://www.impacteers.com/':remoteMessage!.notification!.body.toString())),
          ),
        ),
      ),
    );
  }
}

