import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_2/domain/entities/message.dart';
import 'package:flutter_application_2/infrastructure/models/yes_no_model.dart';

class GetYesNoAnswer {
  Future<Message> getAnswer() async {
    final response = await http.get(Uri.parse('https://yesno.wtf/api'));
    final jsonData = json.decode(response.body);

    final yesNoModel = YesNoModel.fromJsonMap(jsonData);

    return yesNoModel.toMessageEntity();
  }
}