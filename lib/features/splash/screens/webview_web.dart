import 'dart:js_interop';
import 'dart:ui_web' as ui;

import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

Widget buildWebFrame(String url) => _IframeWidget(url: url);

class _IframeWidget extends StatefulWidget {
  const _IframeWidget({required this.url});
  final String url;

  @override
  State<_IframeWidget> createState() => _IframeWidgetState();
}

class _IframeWidgetState extends State<_IframeWidget> {
  late final String _viewType;

  @override
  void initState() {
    super.initState();
    _viewType = 'voltage-iframe-${widget.url.hashCode}';

    ui.platformViewRegistry.registerViewFactory(_viewType, (_) {
      final iframe = web.document.createElement('iframe') as web.HTMLIFrameElement
        ..src = widget.url
        ..setAttribute('allow', 'geolocation; camera; microphone')
        ..setAttribute('allowfullscreen', 'true')
        ..setAttribute('frameborder', '0');

      // Fill the entire container
      iframe.style
        ..width = '100%'
        ..height = '100%'
        ..border = 'none';

      return iframe.toJSBox;
    });
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: _viewType);
  }
}
