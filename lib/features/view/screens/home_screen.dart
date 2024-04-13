import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late InAppWebViewController webViewController;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
              URLRequest(url: Uri.parse('https://kaizen.deepsense.dev/')),
        ),
      ),
    );
  }
}
