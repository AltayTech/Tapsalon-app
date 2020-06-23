import 'package:flutter/foundation.dart';

class Province with ChangeNotifier {
  final int id;

  final String name;
  final int no_users;

  Province({
    this.id,
    this.name,
    this.no_users,
  });

  factory Province.fromJson(Map<String, dynamic> parsedJson) {
    return Province(
      id: parsedJson['id'] != null ? parsedJson['id'] : 0,
      name: parsedJson['name'] != null ? parsedJson['name'] : '',
      no_users: parsedJson['no_users'] != null ? parsedJson['no_users'] : 0,
    );
  }
}
