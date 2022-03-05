// ignore_for_file: file_names

import 'dart:convert' as decoder;
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class NumberCheckerRepository {
  static final NumberCheckerRepository _singleton = NumberCheckerRepository._();

  factory NumberCheckerRepository() {
    return _singleton;
  }

  NumberCheckerRepository._();

  Future<Transport> check(String number) async {
    debugPrint('NumberCheckerRepository check \'$number\'');
    try {
      final uri = Uri.https(
        'opendatabot.com',
        'api/v3/public/transport',
        {'number': number},
      );
      final response = await http.get(uri);
      final json = decoder.json.decode(
        response.body.toString(),
      ) as Map<String, dynamic>;
      debugPrint('NumberCheckerRepository json \'$json\'');
      if (json['status'] == 'error') {
        if (json['code'] == 404) {
          return Future.error('Транспорт не знайдено');
        } else {
          return Future.error(json['reason'] ?? 'Невідома помилка');
        }
      }
      final transport = Transport.fromJson(json);
      debugPrint('NumberCheckerRepository transport \'$transport\'');
      return transport;
    } catch (e) {
      return Future.error(e);
    }
  }
}

class Transport {
  final String number;
  final String model;
  final String kind;
  final String body;
  final String year;
  final String date;
  final String registration;
  final int capacity;
  final int ownWeight;
  final String color;
  final int regAddrKoatuu;
  final int depCode;
  final String dep;

  Transport({
    required this.number,
    required this.model,
    required this.kind,
    required this.body,
    required this.year,
    required this.date,
    required this.registration,
    required this.capacity,
    required this.ownWeight,
    required this.color,
    required this.regAddrKoatuu,
    required this.depCode,
    required this.dep,
  });

  factory Transport.fromJson(Map<String, dynamic> json) {
    return Transport(
      number: json['number'],
      model: json['model'],
      kind: json['kind'],
      body: json['body'],
      year: json['year'],
      date: json['date'],
      registration: json['registration'],
      capacity: json['capacity'],
      ownWeight: json['ownWeight'],
      color: json['color'],
      regAddrKoatuu: json['regAddrKoatuu'],
      depCode: json['depСode'],
      dep: json['dep'],
    );
  }

  @override
  String toString() {
    return 'Transport{number: $number, model: $model, kind: $kind, body: $body, year: $year, date: $date, registration: $registration, capacity: $capacity, ownWeight: $ownWeight, color: $color, regAddrKoatuu: $regAddrKoatuu, depCode: $depCode, dep: $dep}';
  }
}
