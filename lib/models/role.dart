import 'package:flutter/foundation.dart';

class Role with ChangeNotifier {
  final int id;
  final String description;
  final String name;

  Role({
     id,
     description,
     name,
  }):     this.id=0,
        this.description='',
        this.name='';

  factory Role.fromJson(Map<String, dynamic> parsedJson) {
    return Role(
      id: parsedJson['id']!= null ? parsedJson['id'] : 0,
      description: parsedJson['description']!= null ? parsedJson['description'] : '',
      name: parsedJson['name']!= null ? parsedJson['name'] : '',
    );
  }
}
