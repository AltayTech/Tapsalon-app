import 'package:flutter/foundation.dart';

class FieldSearch with ChangeNotifier {
  final int id;
  final String description;
  final String name;
  final String excerpt;
  final String icon;

//  final Pivot pivot;

  FieldSearch({
    required this.id,
    required this.description,
    required this.name,
    required this.excerpt,
    required  this.icon,
//    this.pivot,
  });

  factory FieldSearch.fromJson(Map<String, dynamic> parsedJson) {
    return FieldSearch(
      id: parsedJson['id'],
      name: parsedJson['name'],
      description: parsedJson['description'],
      excerpt: parsedJson['excerpt'],
      icon: parsedJson['icon'],
//      pivot: Pivot.fromJson(parsedJson['pivot']),
    );
  }
}
