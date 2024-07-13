import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

launchURL(String url) async {
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url);
  } else {
    if (kDebugMode) {
      print('Could not launch $url');
    }
  }
}

goToURL(BuildContext context, String url, title) async {
  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    launchURL(url);
    return;
  }
  WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse(url));
  Navigator.push(context, MaterialPageRoute(builder: (ctx) {
    return Scaffold(
      appBar: AppBar(title: Text(title), actions: const <Widget>[
        // IconButton(
        //     icon: Icon(
        //       Icons.open_in_browser,
        //       color: Colors.white,
        //     ),
        //     onPressed: () {
        //       _launchURL(url);
        //     })
      ]),
      body: WebViewWidget(controller: controller),
    );
  }));
}