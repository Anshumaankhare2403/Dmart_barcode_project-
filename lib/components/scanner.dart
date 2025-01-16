import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class Scanner extends StatefulWidget {
  final Function(String) onDetect;

  const Scanner({super.key, required this.onDetect});

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  final MobileScannerController _cameraController = MobileScannerController();
  bool _isTorchOn = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Camera Scanner
            Flexible(
              flex: 10,
              child: Stack(
                children: [
                  MobileScanner(
                    controller: _cameraController,
                    onDetect: (capture) {
                      final List<Barcode> barcodes = capture.barcodes;
                      for (final barcode in barcodes) {
                        if (barcode.rawValue != null) {
                          widget.onDetect(barcode.rawValue!);
                        }
                      }
                    },
                  ),
                  // Optional Overlay (can be customized)
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: screenWidth *
                          0.7, // Dynamic width based on screen size
                      height: screenWidth * 0.7, // Square aspect ratio
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green, width: 4),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Camera Controls
            Flexible(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Switch Camera Button
                  IconButton(
                    icon: const Icon(Icons.flip_camera_ios),
                    onPressed: () {
                      _cameraController.switchCamera();
                    },
                  ),

                  // Torch Toggle Button
                  IconButton(
                    icon: Icon(
                      _isTorchOn ? Icons.flash_on : Icons.flash_off,
                      color: _isTorchOn ? Colors.amber : Colors.grey,
                    ),
                    onPressed: () {
                      _cameraController.toggleTorch();
                      setState(() {
                        _isTorchOn = !_isTorchOn;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }
}
