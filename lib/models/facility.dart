import 'package:flutter/foundation.dart';

class Facility with ChangeNotifier {
  final int id;
  final String description;
  final String name;
  final String excerpt;
  final String icon;

  Facility({
    required  this.id,
    required  this.description,
    required  this.name,
    required  this.excerpt,
    required   this.icon,
  });

  factory Facility.fromJson(Map<String, dynamic> parsedJson) {
    return Facility(
      id: parsedJson['id'] != null ? parsedJson['id'] : 0,
      name: parsedJson['name'] != null ? parsedJson['name'] : '',
      description:
          parsedJson['description'] != null ? parsedJson['description'] : '',
      excerpt: parsedJson['excerpt'] != null ? parsedJson['excerpt'] : '',
      icon: parsedJson['icon'] != null ? parsedJson['icon'] : '',
    );
  }
}
