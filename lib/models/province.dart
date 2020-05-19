import 'package:flutter/foundation.dart';

class Province with ChangeNotifier {
  final int id;

//  final String description;
  final String name;
  final int no_users;

  Province({
    this.id,
//    this.description,
    this.name,
    this.no_users,
  });

  factory Province.fromJson(Map<String, dynamic> parsedJson) {
    return Province(
      id: parsedJson['id'],
//      description: parsedJson['description'],
      name: parsedJson['name'],
      no_users: parsedJson['no_users'],
    );
  }
}
