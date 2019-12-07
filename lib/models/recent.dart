import 'package:meta/meta.dart';

class Recent {
  // ? Required for Databse
  int id;

  // ? Fields
  final String topic;

  // ? Constructor
  Recent({
    @required this.topic,
  });

  Map<String, dynamic> toMap() {
    return {
      'topic': topic,
    };
  }

  static Recent fromMap(Map<String, dynamic> map) {
    return Recent(
      topic: map['topic'],
    );
  }
}
