import 'package:flutter_application_2/domain/entities/message.dart';

class YesNoModel {
  YesNoModel({
    required this.answer,
    required this.forced,
    required this.image,
  });

  final String answer;
  final bool forced;
  final String image;

  factory YesNoModel.fromJsonMap(Map<String, dynamic> json) => YesNoModel(
        answer: json['answer'] as String,
        forced: json['forced'] as bool,
        image: json['image'] as String,
      );

  Map<String, dynamic> toJson() => {
        'answer': answer,
        'forced': forced,
        'image': image,
      };

  String get displayText => switch (answer) {
        'yes' => 'Sí',
        'no' => 'No',
        'maybe' => 'Tal vez',
        _ => answer,
      };

  Message toMessageEntity() => Message(
        text: displayText,
        fromWho: FromWho.hers,
        imageUrl: image,
      );
}
