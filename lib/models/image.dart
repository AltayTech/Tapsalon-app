import 'package:flutter/foundation.dart';

import '../models/image_url.dart';

class Image with ChangeNotifier {
  final int id;
  final String filename;
  final String extension;

  final Url url;

  Image({this.id, this.filename, this.extension, this.url});

  factory Image.fromJson(Map<String, dynamic> parsedJson) {
    return Image(
      id: parsedJson['id']!=null?parsedJson['id']:0,
      filename: parsedJson['filename'],
      extension: parsedJson['extension'],
      url: Url.fromJson(parsedJson['url']),
    );
  }
}
