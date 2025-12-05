enum FromWho { me, hers, typing }

class Message {
  final String text;
  final String? imageUrl;
  final FromWho fromWho;
  final String emotion;

  Message({
    required this.text,
    this.imageUrl,
    required this.fromWho,
    this.emotion = 'respirar',
  });
}
