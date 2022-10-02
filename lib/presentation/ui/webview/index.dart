import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChiSpendWebView extends StatefulWidget {
  const ChiSpendWebView({Key? key, this.cookieManager}) : super(key: key);

  final CookieManager? cookieManager;

  @override
  State<ChiSpendWebView> createState() => _ChiSpendWebViewState();
}

class _ChiSpendWebViewState extends State<ChiSpendWebView> {
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: WebView(
          initialUrl: 'https://chispend.com/?cSContext=mobile&primaryColor=670a78&xAppStyle=light&maxAmountInUSD=100',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          javascriptChannels: {
            JavascriptChannel(
              name: 'ChiSpendChannel',
              onMessageReceived: (message) async {
                debugPrint('Javascript: ${message.message}');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message.message)),
                );
              },
            ),
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
          },
          gestureNavigationEnabled: true,
          backgroundColor: const Color(0x00000000),
        )
      ),
    );
  }
}


