import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

// Conditional import: uses dart:html on web, stub on mobile
import 'webview_stub.dart'
    if (dart.library.html) 'webview_web.dart';

const _targetUrl = 'https://voltageacademy.in/';

class WelcomeWebViewScreen extends StatefulWidget {
  const WelcomeWebViewScreen({super.key});

  @override
  State<WelcomeWebViewScreen> createState() => _WelcomeWebViewScreenState();
}

class _WelcomeWebViewScreenState extends State<WelcomeWebViewScreen> {
  WebViewController? _controller;
  bool _isLoading = true;

  // ── Razorpay ──────────────────────────────────────────────────────────────
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,   _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    if (!kIsWeb) {
      _initMobileController();
    }
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  // ── Razorpay Handlers ─────────────────────────────────────────────────────

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    debugPrint('Razorpay payment success: ${response.paymentId}');
    final payload = jsonEncode({
      'success': true,
      'paymentId':  response.paymentId  ?? '',
      'orderId':    response.orderId    ?? '',
      'signature':  response.signature  ?? '',
    });
    _postResultToWeb(payload);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint('Razorpay payment error: ${response.message}');
    final payload = jsonEncode({
      'success': false,
      'error': response.message ?? 'Payment failed. Please try again.',
    });
    _postResultToWeb(payload);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint('Razorpay external wallet: ${response.walletName}');
    final payload = jsonEncode({
      'success': false,
      'error': 'External wallet selected: ${response.walletName}. Please complete payment in the wallet app.',
    });
    _postResultToWeb(payload);
  }

  /// Posts the payment result JSON back to the webpage via JS.
  void _postResultToWeb(String jsonPayload) {
    final escaped = jsonPayload.replaceAll("'", "\\'");
    _controller?.runJavaScript(
      "if(window.__rzpResultCallback) { window.__rzpResultCallback('$escaped'); }",
    );
  }

  // ── WebView setup ─────────────────────────────────────────────────────────

  void _initMobileController() {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            debugPrint('Page started: $url');
          },
          onPageFinished: (url) {
            debugPrint('Page loaded: $url');
            if (mounted) setState(() => _isLoading = false);

            // ── Inject Flutter bridge flag so the web page knows it's inside the app ──
            _controller?.runJavaScript('''
              (function() {
                window.FlutterRazorpay = true;
                console.log('[VoltageApp] Flutter Razorpay bridge active');
              })();
            ''');
          },
          onWebResourceError: (error) {
            debugPrint('WebView error: \${error.description}');
            if (mounted) setState(() => _isLoading = false);
          },
          onNavigationRequest: (NavigationRequest request) async {
            final url = request.url;
            debugPrint('Navigation: \$url');

            final uri = Uri.parse(url);

            // Non-http/https links
            if (!url.startsWith('http://') && !url.startsWith('https://')) {
              // UPI / payment deep links
              if (url.startsWith('upi://') ||
                  url.startsWith('phonepe://') ||
                  url.startsWith('paytmmp://') ||
                  url.startsWith('gpay://') ||
                  url.startsWith('tez://') ||
                  url.startsWith('credpay://')) {
                try {
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                } catch (e) {
                  debugPrint('Error launching deep link: \$e');
                }
                return NavigationDecision.prevent;
              }

              // Android intent scheme
              if (url.startsWith('intent://')) {
                try {
                  final intentPart = url.substring('intent://'.length);
                  final parts = intentPart.split('#Intent;');
                  if (parts.isNotEmpty) {
                    final queryAndPath = parts[0];
                    String scheme = 'upi';
                    if (parts.length > 1) {
                      final params = parts[1].split(';');
                      for (var param in params) {
                        if (param.startsWith('scheme=')) {
                          scheme = param.substring('scheme='.length);
                        }
                      }
                    }
                    final reconstructedUrl = '\$scheme://\$queryAndPath';
                    final reconstructedUri = Uri.parse(reconstructedUrl);
                    if (await canLaunchUrl(reconstructedUri)) {
                      await launchUrl(reconstructedUri, mode: LaunchMode.externalApplication);
                    }
                  }
                } catch (e) {
                  debugPrint('Error parsing intent URL: \$e');
                }
                return NavigationDecision.prevent;
              }

              return NavigationDecision.prevent;
            }

            // PDF / data URIs
            if (url.startsWith('data:application/pdf') || url.startsWith('data:image/')) {
              try {
                final String rawData = url.split(',')[1];
                final bytes = base64Decode(rawData);
                
                String ext = 'pdf';
                if (url.startsWith('data:image/png')) ext = 'png';
                if (url.startsWith('data:image/jpeg')) ext = 'jpg';

                final fileName = "File_\${DateTime.now().millisecondsSinceEpoch}.$ext";
                final String? outputFile = await FilePicker.platform.saveFile(
                  dialogTitle: 'Save File',
                  fileName: fileName,
                  type: FileType.custom,
                  allowedExtensions: [ext],
                  bytes: bytes, // Automatically writes bytes to file on Android
                );
                
                if (outputFile != null) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Saved to: $outputFile'),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 5),
                    ));
                  }
                }
              } catch (e) {
                debugPrint('Error handling data URL: \$e');
              }
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )

      // ── JS Channel: AppDownloadChannel ─────────────────────────────────────────
      ..addJavaScriptChannel(
        'PDFDownloadChannel', // Keeping name for backward compatibility
        onMessageReceived: (JavaScriptMessage message) async {
          try {
            final parts = message.message.split('|');
            if (parts.length < 2) return;
            final fileName  = parts[0];
            final base64Data = parts[1];
            final bytes = base64Decode(base64Data);
            
            final ext = fileName.split('.').last.toLowerCase();
            
            final String? outputFile = await FilePicker.platform.saveFile(
              dialogTitle: 'Save File',
              fileName: fileName,
              type: FileType.custom,
              allowedExtensions: [ext],
              bytes: bytes, // Automatically writes bytes to file on Android
            );
            
            if (outputFile != null) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Saved to: $outputFile'),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 5),
                ));
              }
            }
          } catch (e) {
            debugPrint('PDFDownloadChannel error: \$e');
          }
        },
      )

      // ── JS Channel: Razorpay Native Payment ───────────────────────────────
      // The web page posts JSON: { key, orderId, amount, currency, name, email, contact, description }
      ..addJavaScriptChannel(
        'RazorpayChannel',
        onMessageReceived: (JavaScriptMessage message) {
          debugPrint('[RazorpayChannel] Received: \${message.message}');
          try {
            final Map<String, dynamic> data = jsonDecode(message.message);

            final options = {
              'key':         data['key']         ?? '',
              'order_id':    data['orderId']      ?? '',
              'amount':      data['amount']       ?? 0,
              'currency':    data['currency']     ?? 'INR',
              'name':        data['instituteName'] ?? 'Voltage Academy',
              'description': data['description']  ?? 'Assessment Fee',
              'prefill': {
                'contact': data['contact'] ?? '',
                'email':   data['email']   ?? '',
                'name':    data['name']    ?? '',
              },
              'theme': {
                'color': '#FFB800',
              },
              'retry': {
                'enabled': true,
                'max_count': 3,
              },
            };

            debugPrint("[RazorpayChannel] Launching native SDK with order: \${data['orderId']}");
            _razorpay.open(options);
          } catch (e) {
            debugPrint('[RazorpayChannel] Error parsing payload: \$e');
            final payload = jsonEncode({'success': false, 'error': 'Invalid payment data from web.'});
            _postResultToWeb(payload);
          }
        },
      )

      ..loadRequest(Uri.parse(_targetUrl));

    // ── Android-specific: geolocation + file picker ───────────────────────
    if (controller.platform is AndroidWebViewController) {
      final androidController = controller.platform as AndroidWebViewController;

      androidController.setGeolocationEnabled(true);
      androidController.setGeolocationPermissionsPromptCallbacks(
        onShowPrompt: (GeolocationPermissionsRequestParams request) async {
          final status = await Permission.location.request();
          return GeolocationPermissionsResponse(
            allow: status.isGranted,
            retain: status.isGranted,
          );
        },
        onHidePrompt: () {
          debugPrint('WebView geolocation prompt hidden.');
        },
      );

      androidController.setOnShowFileSelector(_androidFilePicker);
    }

    setState(() => _controller = controller);
  }

  Future<List<String>> _androidFilePicker(FileSelectorParams params) async {
    if (params.isCaptureEnabled) {
      final ImagePicker picker = ImagePicker();
      final mimeType = params.acceptTypes.isNotEmpty ? params.acceptTypes.first.toLowerCase() : '';
      if (mimeType.startsWith('video/')) {
        final status = await Permission.camera.request();
        if (status.isGranted) {
          final XFile? video = await picker.pickVideo(source: ImageSource.camera);
          if (video != null) return [File(video.path).uri.toString()];
        }
      } else {
        final status = await Permission.camera.request();
        if (status.isGranted) {
          final XFile? image = await picker.pickImage(source: ImageSource.camera);
          if (image != null) return [File(image.path).uri.toString()];
        }
      }
      return [];
    }

    List<String>? allowedExtensions;
    FileType fileType = FileType.any;

    if (params.acceptTypes.isNotEmpty) {
      final mimeType = params.acceptTypes.first.toLowerCase();
      if (mimeType.startsWith('image/'))           fileType = FileType.image;
      else if (mimeType.startsWith('video/'))       fileType = FileType.video;
      else if (mimeType.startsWith('audio/'))       fileType = FileType.audio;
      else if (mimeType == 'application/pdf' || mimeType == '.pdf') {
        fileType = FileType.custom;
        allowedExtensions = ['pdf'];
      }
    }

    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: params.mode == FileSelectorMode.openMultiple,
        type: fileType,
        allowedExtensions: allowedExtensions,
      );
      if (result != null && result.files.isNotEmpty) {
        return result.files
            .where((f) => f.path != null)
            .map((f) => File(f.path!).uri.toString())
            .toList();
      }
    } catch (e) {
      debugPrint('File picker error: \$e');
    }
    return [];
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // Flutter Web: render an iframe
    if (kIsWeb) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: buildWebFrame(_targetUrl),
      );
    }

    // Mobile: native WebView
    if (_controller == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF0A0A0A),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFFFB800)),
        ),
      );
    }

    return PopScope(
      // canPop: false means we handle the back press ourselves
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return; // already popped, nothing to do
        final canGoBack = await _controller!.canGoBack();
        if (canGoBack) {
          // WebView has history → go back inside the web page
          await _controller!.goBack();
        } else {
          // No WebView history left → exit the app
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            WebViewWidget(controller: _controller!),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(color: Color(0xFFFFB800)),
              ),
          ],
        ),
      ),
    );
  }
}
