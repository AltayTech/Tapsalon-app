import 'package:flutter/foundation.dart';
import 'package:tapsalon/models/image_url.dart';
import 'package:tapsalon/models/places_models/place_type.dart';
import 'package:tapsalon/models/region.dart';

import '../city.dart';
import '../facility.dart';
import '../field.dart';
import '../image.dart';
import '../province.dart';

class PlaceInSearch with ChangeNotifier {
  final int id;

  final String name;
  final String excerpt;
  final String about;
  final String timings_excerpt;
  final int price;
  final String phone;
  final String mobile;
  final String address;
  final double latitude;
  final double longitude;
  final String createdAt;
  final String updatedAt;
  final bool liked;
  final PlaceType placeType;
  final List<Field> fields;
  final List<Facility> facilities;
  final ImageObj image;
  final Province province;
  final City city;
  final int likes_count;

  final Region region;
  final double rate;

  PlaceInSearch({
    this.id,
    this.name,
    this.excerpt,
    this.about,
    this.timings_excerpt,
    this.price,
    this.phone,
    this.mobile,
    this.address,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.updatedAt,
    this.liked,
    this.placeType,
    this.fields,
    this.facilities,
    this.image,
    this.province,
    this.city,
    this.region,
    this.rate,
    this.likes_count,
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
      timings_excerpt: parsedJson['timings_excerpt'] != null
          ? parsedJson['timings_excerpt']
          : '',
      price: parsedJson['price'] != null ? parsedJson['price'] : 0,
      phone: parsedJson['phone'] != null ? parsedJson['phone'] : '',
      mobile: parsedJson['mobile'] != null ? parsedJson['mobile'] : '',
      address: parsedJson['address'] != null ? parsedJson['address'] : '',
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
      liked: parsedJson['liked'] != null ? parsedJson['liked'] : false,
      placeType: PlaceType.fromJson(parsedJson['place_type']),
      fields: fieldRaw,
      facilities: facilityRaw,
      image: parsedJson['image'] != null
          ? ImageObj.fromJson(parsedJson['image'])
          : ImageObj(
          id: 0,
          filename: '',
          url: ImageUrl(
            medium: 'assets/images/place_placeholder.jpeg',
            large: 'assets/images/place_placeholder.jpeg',
            thumb: 'assets/images/place_placeholder.jpeg',
          )),
      province: Province.fromJson(parsedJson['ostan']),
      city: City.fromJson(parsedJson['city']),
      region: parsedJson['region'] != null
          ? Region.fromJson(parsedJson['region'])
          : Region(id: 0, name: ''),
      rate: parsedJson['rate'] != null
          ? double.parse(parsedJson['rate'].toString())
          : 0.0,
      likes_count: parsedJson['likes_count'] != null
          ? int.parse(parsedJson['likes_count'].toString())
          : 0,
    );
  }
}
