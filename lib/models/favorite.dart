import 'package:flutter/foundation.dart';

import '../models/place_favorite.dart';

class Favorite with ChangeNotifier {
  final int id;
  final int user_id;
  final int complex_id;
  final PlaceFavorite complex;
  final String created_at;
  final String updated_at;

  Favorite(
      {this.id,
      this.user_id,
      this.complex_id,
      this.complex,
      this.created_at,
      this.updated_at});

  factory Favorite.fromJson(Map<String, dynamic> parsedJson) {
    return Favorite(
      id: parsedJson['id'],
      complex_id: parsedJson['complex_id'],
      user_id: parsedJson['user_id'],
      complex: PlaceFavorite.fromJson(parsedJson['complex']),
      created_at: parsedJson['created_at'],
      updated_at: parsedJson['updated_at'],
    );
  }
}
