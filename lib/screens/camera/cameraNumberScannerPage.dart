// ignore_for_file: file_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:main/repository/numberCheckerRepository.dart';
import 'package:main/utils/numberExtractor.dart';
import 'package:main/views/textScannerWidget.dart';
import 'package:main/views/transportDetailsWidget.dart';

class CameraNumberScannerPage extends StatefulWidget {
  const CameraNumberScannerPage({Key? key}) : super(key: key);

  @override
  State<CameraNumberScannerPage> createState() =>
      _CameraNumberScannerPageState();
}

class _CameraNumberScannerPageState extends State<CameraNumberScannerPage> {
  final _numberExtractor = NumberExtractor();
  String? _scannerNumber;
  Future<Transport>? _future;

  Future<void> _onTextRecognised(RecognisedText recognisedText) async {
    if (_scannerNumber != null) return;
    for (final block in recognisedText.blocks) {
      final number = _numberExtractor.extractNumber(block);
      if (number == null) continue;
      if (_scannerNumber == number) continue;
      setState(() {
        _scannerNumber = number;
        _future = NumberCheckerRepository().check(number);
      });
      break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_scannerNumber == null) return;
        setState(() {
          _scannerNumber = null;
          _future = null;
        });
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Перевірка транспорту'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            TextScannerWidget(callback: _onTextRecognised),
            FutureBuilder(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.none) {
                  return const SizedBox.shrink();
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError || !snapshot.hasData) {
                  return Container(
                    width: double.infinity,
                    color: Colors.white,
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        _scannerNumber != null
                            ? _buildNumberText(_scannerNumber ?? "")
                            : const SizedBox.shrink(),
                        Text(
                          'Помилка: ${snapshot.error}',
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final transport = snapshot.data as Transport;

                return Container(
                  width: double.infinity,
                  color: Colors.white,
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  child: Wrap(
                    children: [
                      _buildNumberText(transport.number),
                      const SizedBox(height: 32),
                      TransportDetailsWidget(
                        transport: transport,
                      )
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberText(String number) {
    return Center(
      child: Text(
        number,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
