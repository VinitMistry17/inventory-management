import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:inventory_management/core/errors/app_exception.dart';
import 'package:inventory_management/features/items/presentation/providers/items_providers.dart';
import 'package:inventory_management/features/items/presentation/screens/item_detail_screen.dart';

class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  bool _isProcessing = false; // ek baar mein sirf ek scan process ho, duplicate na ho

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return; // agar already processing ho rahi hai, naye scans ignore karo

    final barcode = capture.barcodes.firstOrNull;
    final rawValue = barcode?.rawValue;
    if (rawValue == null) return;

    // Expected format: "tagvault://item/42"
    final match = RegExp(r'^tagvault://item/(\d+)$').firstMatch(rawValue);
    if (match == null) {
      _showError("This tag isn't recognized. Try scanning again.");
      return;
    }

    final itemId = int.parse(match.group(1)!);
    setState(() => _isProcessing = true);

    try {
      final usecase = ref.read(getItemDetailUsecaseProvider);
      await usecase(itemId); // sirf verify karna hai item exist karta hai ya nahi

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ItemDetailScreen(itemId: itemId)),
        );
      }
    } catch (e) {
      final message = e is AppException ? e.message : "This tag isn't recognized. Try scanning again.";
      _showError(message);
      setState(() => _isProcessing = false); // dobara scan allow karo
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    setState(() => _isProcessing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan QR Code")),
      body: Stack(
        children: [
          MobileScanner(onDetect: _onDetect),
          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(child: CircularProgressIndicator(color: Colors.white)),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Point camera at item's QR tag",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}