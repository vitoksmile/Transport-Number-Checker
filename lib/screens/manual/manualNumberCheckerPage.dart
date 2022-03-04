// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:main/repository/numberCheckerRepository.dart';

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
                  return Text('Помилка: ${snapshot.error}');
                }

                final transport = snapshot.data as Transport;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTransportItem('Модель', transport.model),
                    _buildTransportItem('Тип авто', transport.kind),
                    _buildTransportItem('Тип кузова', transport.body),
                    _buildTransportItem('Рік випуску', transport.year),
                    _buildTransportItem('Дата', transport.date),
                    _buildTransportItem('Колір', transport.color),
                    _buildTransportItem('Об\'єм двигуна', transport.capacity),
                    _buildTransportItem('Вага', transport.ownWeight),
                    _buildTransportItem('Тип дії', transport.registration),
                    _buildTransportItem('Код АТУ', transport.regAddrKoatuu),
                    _buildTransportItem('Код ТСЦ', transport.depCode),
                    _buildTransportItem('ТСЦ', transport.dep),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransportItem(String title, dynamic body) {
    return RichText(
      text: TextSpan(
        text: '$title: ',
        style: const TextStyle(
          color: Colors.black,
          fontSize: 18,
        ),
        children: <TextSpan>[
          TextSpan(
            text: body.toString(),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
