import 'package:flutter/foundation.dart';
import 'package:tapsalon/models/featured.dart';
import 'package:tapsalon/models/field_search.dart';
import 'package:tapsalon/models/image_url.dart';
import 'package:tapsalon/models/place_in_complex.dart';
import 'package:tapsalon/models/region.dart';

class ComplexFavorite with ChangeNotifier {
  final int id;

  final double latitude;
  final double longitude;
  final String name;
  final String excerpt;
  final String about;
  final String address;
  final String img_url;

  final int likes_no;
  final int visits_no;
  final double stars;
  final String phone;
  final String mobile;
  final String created_at;
  final String updated_at;

  final List<FieldSearch> fields;

  ComplexFavorite({
    this.id,
    this.latitude,
    this.longitude,
    this.name,
    this.excerpt,
    this.about,
    this.address,
    this.img_url,
    this.likes_no,
    this.visits_no,
    this.stars,
    this.phone,
    this.mobile,
    this.created_at,
    this.updated_at,
    this.fields,
  });

  factory ComplexFavorite.fromJson(Map<String, dynamic> parsedJson) {
    List<FieldSearch> fieldsRaw = new List<FieldSearch>();

    try {
      var fieldsList = parsedJson['fields'] as List<dynamic>;
      fieldsRaw = new List<FieldSearch>();
      fieldsRaw = fieldsList.map((i) => FieldSearch.fromJson(i)).toList();
    } catch (error) {
      fieldsRaw = [];
    }


    return ComplexFavorite(
      id: parsedJson['id'],
      latitude: parsedJson['latitude'],
      longitude: parsedJson['longitude'],
      name: parsedJson['name'],
      excerpt: parsedJson['excerpt'],
      about: parsedJson['about'],
      address: parsedJson['address'],
      img_url: parsedJson['img_url'],
      likes_no: parsedJson['likes_no'],
      visits_no: parsedJson['visits_no'],
      stars: double.parse(parsedJson['stars'].toString()),
      phone: parsedJson['phone'],
      mobile: parsedJson['mobile'],
      created_at: parsedJson['created_at'],
      updated_at: parsedJson['updated_at'],
      fields: fieldsRaw,

    );
  }
}
