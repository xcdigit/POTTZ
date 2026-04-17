import 'package:flutter/material.dart';
import 'dart:html';
import 'dart:ui_web' as ui_web;

showConfirmationAlertDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierColor: Colors.transparent,
    builder: (BuildContext context) {
      return Container(
        child: Stack(
          children: <Widget>[
            Positioned(
              right: 10.0,
              bottom: 50.0,
              child: AlertDialog(
                actions: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.clear)
                  ),
                  Container(
                    child: Center(
                      child: Container(
                        width: 520,
                        height: 610,
                        child: getWebView(),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0,)
                ],
              ),
            )
          ],
        ),
      );
    },
  );
}

getWebView(){
  final IFrameElement _iframeElement = IFrameElement();
    _iframeElement.src = "https://k-aigent.biz-x.app/?page_id=264";
    _iframeElement.style.border = 'none';
    _iframeElement.style.height = '600px';
    _iframeElement.style.width = '500px';
// ignore: undefined_prefixed_name
    ui_web.platformViewRegistry.registerViewFactory(
      'iframeElement',
      (int viewId) => _iframeElement,
    );
    Widget _iframeWidget;
    _iframeWidget = HtmlElementView(
      key: UniqueKey(),
      viewType: 'iframeElement',
    );
    return Stack(
      children: <Widget>[
        IgnorePointer(
          ignoring: true,
          child: Center(
            child: _iframeWidget,
          ),
        ),
        HtmlElementView(
          viewType: "iframe-webview"
        ),
      ],
    );
}