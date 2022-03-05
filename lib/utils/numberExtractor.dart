// ignore_for_file: file_names

import 'package:google_ml_kit/google_ml_kit.dart';

class NumberExtractor {
  final _spaceRegExp = RegExp(r'\s+');
  final _intRegExp = RegExp(r'[^0-9]');

  String? extractNumber(TextBlock textBlock) {
    final text = textBlock.text.replaceAll(_spaceRegExp, '');

    final number = text.replaceAll(_intRegExp, '');
    if (number.length != 4) return null;

    final numberIndex = text.indexOf(number);
    if (numberIndex == -1) return null;

    var before = text.substring(0, numberIndex);
    if (before.length < 2) return null;
    if (before.length > 2) {
      before = before.substring(before.length - 2, before.length);
    }

    var after = text.substring(numberIndex + number.length, text.length);
    if (after.length < 2) return null;
    if (after.length > 2) {
      after = after.substring(after.length - 2, after.length);
    }

    return before + number + after;
  }
}
