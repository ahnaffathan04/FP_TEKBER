// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:js' as js;
// ignore: undefined_prefixed_name
import 'dart:ui_web' as ui;
import 'package:flutter/material.dart';

class QRScannerWeb extends StatefulWidget {
  const QRScannerWeb({super.key});

  @override
  State<QRScannerWeb> createState() => _QRScannerWebState();
}

class _QRScannerWebState extends State<QRScannerWeb> {
  late VideoElement _videoElement;
  CanvasElement? _canvas;
  String _qrResult = 'Belum ada hasil';
  bool _hasShownDialog = false;

  @override
  void initState() {
    super.initState();

    _videoElement = VideoElement()
      ..autoplay = true
      ..style.width = '100%'
      ..style.height = '100%'
      ..setAttribute('playsinline', 'true'); // untuk iOS

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'videoElement',
      (int viewId) => _videoElement,
    );

    window.navigator.mediaDevices?.getUserMedia({
      'video': {
        'facingMode': {'exact': 'environment'}
      }
    }).then((mediaStream) {
      _videoElement.srcObject = mediaStream;
      _startScanLoop();
    }).catchError((e) {
      setState(() {
        _qrResult = 'Gagal membuka kamera: $e';
      });
    });
  }

  void _startScanLoop() {
    _canvas = CanvasElement(width: 600, height: 600);

    void scan(num _) {
      if (_canvas == null) return;

      final ctx = _canvas!.context2D;
      ctx.drawImage(_videoElement, 0, 0);

      final imageData = ctx.getImageData(0, 0, _canvas!.width!, _canvas!.height!);
      final result = js.context.callMethod('jsQR', [
        imageData.data,
        _canvas!.width,
        _canvas!.height,
      ]);

      if (result != null && result['data'] != null && !_hasShownDialog) {
        setState(() {
          _qrResult = result['data'];
          _hasShownDialog = true;
        });

        Future.delayed(Duration.zero, () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => FeedbackSentDialog(
              onOkPressed: () {
                Navigator.of(context).pop(); // close dialog
                Navigator.of(context).pop(); // go back
              },
            ),
          );
        });
      }
      window.requestAnimationFrame(scan);
    }
    window.requestAnimationFrame(scan);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR-Code'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.width * 0.9,
                color: Colors.black,
                child: HtmlElementView(viewType: 'videoElement'),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '*Arahkan kamera ke QR-Code',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class FeedbackSentDialog extends StatelessWidget {
  final void Function() onOkPressed;
  const FeedbackSentDialog({super.key, required this.onOkPressed});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF000000),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF2EE6FF),
            width: 3,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF3E3E3E),
              ),
              child: const Icon(
                Icons.check,
                color: Color(0xFF10FF8C),
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Tiket terdaftar!',
              style: TextStyle(
                color: Color(0xFFB9DEE4),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A1A2E),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: onOkPressed,
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFF2EE6FF),
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}