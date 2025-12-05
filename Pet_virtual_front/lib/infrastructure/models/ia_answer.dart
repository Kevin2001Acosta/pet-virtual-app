import 'package:yes_no_app/domain/entities/message.dart';

class ResponseIAModel {
  final String answer;
  final String emotion;

  ResponseIAModel({
    required this.answer,
    required this.emotion,
  });

  factory ResponseIAModel.fromJsonMap(Map<String, dynamic> json) =>
      ResponseIAModel(answer: json["response"], 
                      emotion: json["emotion"] ?? 'Respirar',
        );

  Map<String, dynamic> toJson() => {"answer": answer, "emotion": emotion};

  Message toMessageEntity() => Message(text: answer, fromWho: FromWho.hers, emotion: emotion);
}

