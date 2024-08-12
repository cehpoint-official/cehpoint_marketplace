// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TestWebViewPage extends StatefulWidget {
  final String destinationUrl;

  const TestWebViewPage(this.destinationUrl, {super.key});

  @override
  _TestWebViewPageState createState() => _TestWebViewPageState();
}

class _TestWebViewPageState extends State<TestWebViewPage> {
  late final Uri url;
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    url = Uri.parse(widget.destinationUrl);
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CehpointMarketplace.com'),
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
