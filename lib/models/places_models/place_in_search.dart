import 'package:flutter/foundation.dart';
import 'package:tapsalon/models/image_url.dart' as url;
import 'package:tapsalon/models/region.dart';

import '../facility.dart';
import '../field.dart';
import '../image.dart';
import '../city.dart';
import 'place_type.dart';
import '../province.dart';

class PlaceInSearch with ChangeNotifier {
  final int id;

  final String name;
  final String excerpt;
  final String about;
  final int price;
  final String phone;
  final String mobile;
  final double latitude;
  final double longitude;
  final String createdAt;
  final String updatedAt;
  final PlaceType placeType;
  final List<Field> fields;
  final List<Facility> facilities;
  final Image image;
  final Province province;
  final City city;
  final int likesNo;

  final Region region;
  final double stars;

  PlaceInSearch({
    this.id,
    this.name,
    this.excerpt,
    this.about,
    this.price,
    this.phone,
    this.mobile,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.updatedAt,
    this.placeType,
    this.fields,
    this.facilities,
    this.image,
    this.province,
    this.city,
    this.region,
    this.stars,
    this.likesNo,
  });

  factory PlaceInSearch.fromJson(Map<String, dynamic> parsedJson) {
    var facilitiesList = parsedJson['facilities'] as List;
    List<Facility> facilityRaw = new List<Facility>();
    facilityRaw = facilitiesList.map((i) => Facility.fromJson(i)).toList();

    var fieldsList = parsedJson['fields'] as List;
    List<Field> fieldRaw = new List<Field>();
    fieldRaw = fieldsList.map((i) => Field.fromJson(i)).toList();

    return PlaceInSearch(
      id: parsedJson['id'],
      name: parsedJson['name'],
      excerpt: parsedJson['excerpt'] != null ? parsedJson['excerpt'] : '',
      about: parsedJson['about'] != null ? parsedJson['about'] : '',
      price: parsedJson['price'] != null ? parsedJson['price'] : 0,
      phone: parsedJson['phone'] != null ? parsedJson['phone'] : '',
      mobile: parsedJson['mobile'] != null ? parsedJson['mobile'] : '',
      latitude: parsedJson['latitude'] != null
          ? double.parse(parsedJson['latitude'].toString())
          : 0.0,
      longitude: parsedJson['longitude'] != null
          ? double.parse(parsedJson['longitude'].toString())
          : 0.0,
      createdAt:
          parsedJson['created_at'] != null ? parsedJson['created_at'] : '',
      updatedAt:
          parsedJson['updated_at'] != null ? parsedJson['updated_at'] : '',
      placeType: PlaceType.fromJson(parsedJson['place_type']),
      fields: fieldRaw,
      facilities: facilityRaw,
      image: parsedJson['image'] != null
          ? Image.fromJson(parsedJson['image'])
          : Image(id: 0, filename: ''),
      province: Province.fromJson(parsedJson['ostan']),
      city: City.fromJson(parsedJson['city']),
      region: parsedJson['region'] != null
          ? Region.fromJson(parsedJson['region'])
          : Region(id: 0, name: ''),
      stars: parsedJson['stars'] != null
          ? double.parse(parsedJson['stars'].toString())
          : 0.0,
      likesNo: parsedJson['likes'] != null
          ? int.parse(parsedJson['likes'].toString())
          : 0,
    );
  }
}
