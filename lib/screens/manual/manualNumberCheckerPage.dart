// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:main/repository/numberCheckerRepository.dart';
import 'package:main/screens/camera/cameraNumberScannerPage.dart';
import 'package:main/views/transportDetailsWidget.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ManualNumberCheckerPage extends StatefulWidget {
  const ManualNumberCheckerPage({Key? key}) : super(key: key);

  @override
  State<ManualNumberCheckerPage> createState() =>
      _ManualNumberCheckerPageState();
}

class _ManualNumberCheckerPageState extends State<ManualNumberCheckerPage> {
  final _editingController = TextEditingController();
  Future<Transport>? _future;

  @override
  void initState() {
    _editingController.text = '';
    super.initState();
  }

  void _onSearch(String number) {
    setState(() {
      _future = NumberCheckerRepository().check(number);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Перевірка транспорту'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _editingController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Введіть номер транспорту',
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              onSubmitted: _onSearch,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _onSearch(_editingController.text);
                },
                child: const Text('Перевірити'),
              ),
            ),
            const SizedBox(height: 16),
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
                  return Text(
                    'Помилка: ${snapshot.error}',
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  );
                }

                return TransportDetailsWidget(
                  transport: snapshot.data as Transport,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: kIsWeb
          ? null
          : FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const CameraNumberScannerPage()));
              },
              child: const Icon(Icons.camera_alt_outlined),
            ),
    );
  }
}
