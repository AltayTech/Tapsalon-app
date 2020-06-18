import 'package:flutter/foundation.dart';

class City with ChangeNotifier {
  final int id;
  final int provinceId;
  final String name;
  final double latitude;
  final double longitude;

  City({
    this.id,
    this.provinceId,
    this.name,
    this.latitude,
    this.longitude,
  });

  factory City.fromJson(Map<String, dynamic> parsedJson) {
    return City(
      id: parsedJson['id'],
      provinceId: parsedJson['ostan_id'],
      name: parsedJson['name'],
      latitude: parsedJson['latitude'],
      longitude: parsedJson['longitude'],
    );
  }
}
