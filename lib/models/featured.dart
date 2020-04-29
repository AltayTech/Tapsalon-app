import 'package:flutter/foundation.dart';

import 'image_url.dart';

class Featured with ChangeNotifier {
  final int id;
  final int place_id;
  final String title;
  final String filename;
  final String extension;
  final String created_at;
  final String updated_at;

  final Url url;

  Featured(
      {this.id,
      this.place_id,
      this.title,
      this.filename,
      this.extension,
      this.created_at,
      this.updated_at,
      this.url});

  factory Featured.fromJson(Map<String, dynamic> parsedJson) {
    return Featured(
      id: parsedJson['id'],
      place_id: parsedJson['place_id'],
      title: parsedJson['title'],
      filename: parsedJson['filename'],
      extension: parsedJson['extension'],
      created_at: parsedJson['created_at'],
      updated_at: parsedJson['updated_at'],
      url: Url.fromJson(parsedJson['url']),
    );
  }
}
