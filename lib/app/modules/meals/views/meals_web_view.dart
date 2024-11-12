import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MealDetailWebView extends StatelessWidget {
  final String url;

  const MealDetailWebView({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // WebViewController setup
    final WebViewController webViewController = WebViewController()
      ..loadRequest(Uri.parse(url));

    return Scaffold(
      appBar: AppBar(
        title: const Text("WebView"),
      ),
      body: WebViewWidget(
        controller: webViewController, // Using the WebViewController
      ),
    );
  }
}
