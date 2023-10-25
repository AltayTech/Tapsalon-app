import 'package:flutter/foundation.dart';

import 'place_favorite.dart';

class Favorite with ChangeNotifier {
  final int id;
  final int user_id;
  final int place_id;
  final PlaceFavorite place;
  final String created_at;
  final String updated_at;

  Favorite(
      {required this.id,
      required this.user_id,
      required this.place_id,
      required this.place,
      required this.created_at,
      required this.updated_at});

  factory Favorite.fromJson(Map<String, dynamic> parsedJson) {
    return Favorite(
      id: parsedJson['id'],
      place_id: parsedJson['place_id'],
      user_id: parsedJson['user_id'],
      place: PlaceFavorite.fromJson(parsedJson['place']),
      created_at: parsedJson['created_at'],
      updated_at: parsedJson['updated_at'],
    );
  }
}
