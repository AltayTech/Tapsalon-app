import 'package:flutter/foundation.dart';

class Notification with ChangeNotifier {
  final int id;
  final int complex_id;
  final String title;
  final String description;
  final int type;
  final String created_at;
  final String updated_at;

  Notification(
      {required this.id,
      required this.complex_id,
     required  this.title,
     required  this.description,
     required  this.type,
     required  this.created_at,
     required  this.updated_at});

  factory Notification.fromJson(Map<String, dynamic> parsedJson) {
    return Notification(
      id: parsedJson['id'],
      complex_id: parsedJson['complex_id'],
      title: parsedJson['title'],
      description: parsedJson['description'],
      type: parsedJson['type'],
      created_at: parsedJson['created_at'],
      updated_at: parsedJson['updated_at'],
    );
  }
}
