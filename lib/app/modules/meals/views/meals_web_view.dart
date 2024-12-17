import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MealDetailWebView extends StatelessWidget {
  final String url;

  const MealDetailWebView({
    super.key,
    required this.url,
  });

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
