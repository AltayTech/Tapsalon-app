import 'package:flutter/foundation.dart';
import 'package:tapsalon/models/image.dart';

import '../models/field_search.dart';

class PlaceFavorite with ChangeNotifier {
  final int id;
  final double latitude;
  final double longitude;
  final String name;
  final String excerpt;
  final String about;
  final String address;
  final Image image;
  final int likesNo;
  final int visitsNo;
  final double stars;
  final String phone;
  final String mobile;
  final String createdAt;
  final String updatedAt;

  final List<FieldSearch> fields;

  PlaceFavorite({
    this.id,
    this.latitude,
    this.longitude,
    this.name,
    this.excerpt,
    this.about,
    this.address,
    this.image,
    this.likesNo,
    this.visitsNo,
    this.stars,
    this.phone,
    this.mobile,
    this.createdAt,
    this.updatedAt,
    this.fields,
  });

  factory PlaceFavorite.fromJson(Map<String, dynamic> parsedJson) {
    List<FieldSearch> fieldsRaw = new List<FieldSearch>();

    try {
      var fieldsList = parsedJson['fields'] as List<dynamic>;
      fieldsRaw = new List<FieldSearch>();
      fieldsRaw = fieldsList.map((i) => FieldSearch.fromJson(i)).toList();
    } catch (error) {
      fieldsRaw = [];
    }

    return PlaceFavorite(
      id: parsedJson['id'],
      latitude: parsedJson['latitude'],
      longitude: parsedJson['longitude'],
      name: parsedJson['name'],
      excerpt: parsedJson['excerpt'],
      about: parsedJson['about'],
      address: parsedJson['address'],
      image: Image.fromJson(parsedJson['image']),
      likesNo: parsedJson['likes_no'],
      visitsNo: parsedJson['visits_no'],
      stars: double.parse(parsedJson['stars'].toString()),
      phone: parsedJson['phone'],
      mobile: parsedJson['mobile'],
      createdAt: parsedJson['created_at'],
      updatedAt: parsedJson['updated_at'],
      fields: fieldsRaw,
    );
  }
}
