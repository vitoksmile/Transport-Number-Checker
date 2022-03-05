import 'package:flutter/material.dart';
import 'package:main/repository/numberCheckerRepository.dart';

class TransportDetailsWidget extends StatefulWidget {
  final Transport transport;

  const TransportDetailsWidget({Key? key, required this.transport})
      : super(key: key);

  @override
  State<TransportDetailsWidget> createState() => _TransportDetailsWidgetState();
}

class _TransportDetailsWidgetState extends State<TransportDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    final transport = widget.transport;

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
