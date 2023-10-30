import 'package:flutter/foundation.dart';

class Region with ChangeNotifier {
  final int id;
  final int city_id;
  final String name;
  final int no_users;

  Region({
    id,
    city_id,
    name,
    no_users,
  }):  this.id=0,
        this.city_id=0,
        this.name='',
        this.no_users=0;

  factory Region.fromJson(Map<String, dynamic> parsedJson) {
    return Region(
      id: parsedJson['id'],
      city_id: parsedJson['city_id'],
      name: parsedJson['name'],
      no_users: parsedJson['no_users'],
    );
  }
}
