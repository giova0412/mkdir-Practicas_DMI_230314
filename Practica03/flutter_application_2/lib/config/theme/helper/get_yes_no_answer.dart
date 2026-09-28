import 'dart:convert';
import 'dart:math';

import 'package:flutter_application_2/domain/entities/message.dart';
import 'package:flutter_application_2/infrastructure/models/yes_no_model.dart';
import 'package:http/http.dart' as http;

enum YesNoAnswerKind { yes, no, maybe }

class GetYesNoAnswer {
  final Random _random = Random();

  /// Elige Sí (40%), No (40%) o Tal vez (20%) y pide el GIF a yesno.wtf.
  YesNoAnswerKind pickWeightedAnswer() {
    final roll = _random.nextDouble();
    if (roll < 0.4) return YesNoAnswerKind.yes;
    if (roll < 0.8) return YesNoAnswerKind.no;
    return YesNoAnswerKind.maybe;
  }

  Future<Message> getAnswer() async {
    final kind = pickWeightedAnswer();
    final force = switch (kind) {
      YesNoAnswerKind.yes => 'yes',
      YesNoAnswerKind.no => 'no',
      YesNoAnswerKind.maybe => 'maybe',
    };

    final response = await http.get(
      Uri.parse('https://yesno.wtf/api?force=$force'),
    );
    final jsonData = json.decode(response.body) as Map<String, dynamic>;

    final yesNoModel = YesNoModel.fromJsonMap(jsonData);

    return yesNoModel.toMessageEntity();
  }
}
