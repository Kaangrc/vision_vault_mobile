import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScanPage extends StatefulWidget {
  const QrScanPage({super.key});

  @override
  _QrScanPageState createState() => _QrScanPageState();
}

class _QrScanPageState extends State<QrScanPage> {
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? _controller;
  String? _qrResult;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Kodu Tara'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: QRView(
              key: _qrKey,
              onQRViewCreated: (QRViewController controller) {
                _controller = controller;
                controller.scannedDataStream.listen(
                  (scanData) {
                    setState(() {
                      _qrResult = scanData.code;
                      controller.stopCamera();
                    });
                  },
                  onError: (error) {
                    
                    print('Error scanning QR code: $error');
                  },
                );
              },
            ),
          ),
          Expanded(
            child: Center(
              child: _qrResult != null
                  ? Card(
                      elevation: 5,
                      margin: const EdgeInsets.all(16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'QR Kodunda Bulunan Bilgiler:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _qrResult!,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                
                                _controller?.resumeCamera();
                                setState(() {
                                  _qrResult = null;
                                });
                              },
                              child: const Text('Tekrar Tara'),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const Text('QR kodunu tarayın'),
            ),
          ),
        ],
      ),
    );
  }
}
