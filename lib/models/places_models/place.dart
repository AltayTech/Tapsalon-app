import 'package:flutter/foundation.dart';
import 'file:///C:/AndroidStudioProjects/Pro_tapsalon/tapsalon_flutter/tapsalon/lib/models/places_models/complex_in_place.dart';
import 'package:tapsalon/models/timing.dart';

import '../../models/facility.dart';
import '../../models/field.dart';
import '../../models/image.dart';
import '../city.dart';
import '../places_models/place_type.dart';
import '../province.dart';
import '../region.dart';
import '../user_models/user_in_complex.dart';

class Place with ChangeNotifier {
  final int id;

  final String name;
  final String excerpt;
  final String about;
  final int price;
  final String phone;
  final String mobile;
  final String address;
  final double latitude;
  final double longitude;
  final String createdAt;
  final String updatedAt;
  final ComplexInPlace complex;
  final PlaceType placeType;
  final List<Field> fields;
  final List<Facility> facilities;
  final Image image;
  final List<Image> gallery;
  final List<Timing> timings;
  final Province province;
  final City city;
  final Region region;
  final UserInComplex user;
  final int likes;
  final int visitsNo;
  final double stars;

  Place(
      {this.id,
      this.name,
      this.excerpt,
      this.about,
      this.price,
      this.phone,
      this.mobile,
      this.address,
      this.latitude,
      this.longitude,
      this.createdAt,
      this.updatedAt,
      this.complex,
      this.placeType,
      this.fields,
      this.facilities,
      this.image,
      this.gallery,
      this.timings,
      this.province,
      this.city,
      this.region,
      this.user,
      this.likes,
      this.visitsNo,
      this.stars});

  factory Place.fromJson(Map<String, dynamic> parsedJson) {
    var galleryList = parsedJson['gallery'] as List;
    List<Image> galleryRaw = new List<Image>();
    galleryRaw = galleryList.map((i) => Image.fromJson(i)).toList();

    var facilitiesList = parsedJson['facilities'] as List;
    List<Facility> faciltyRaw = new List<Facility>();
    faciltyRaw = facilitiesList.map((i) => Facility.fromJson(i)).toList();

    var filedsList = parsedJson['fields'] as List;
    List<Field> fieldRaw = new List<Field>();
    fieldRaw = filedsList.map((i) => Field.fromJson(i)).toList();

    var timingsList = parsedJson['timings'] as List;
    List<Timing> timingsRaw = new List<Timing>();
    timingsRaw = timingsList.map((i) => Timing.fromJson(i)).toList();

    return Place(
      id: parsedJson['id'],
      name: parsedJson['name'],
      excerpt: parsedJson['excerpt'] != null ? parsedJson['excerpt'] : '',
      about: parsedJson['about'] != null ? parsedJson['about'] : '',
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
      complex: ComplexInPlace.fromJson(parsedJson['complex']),
      placeType: PlaceType.fromJson(parsedJson['place_type']),
      fields: fieldRaw,
      facilities: faciltyRaw,
      image: Image.fromJson(parsedJson['image']),
      gallery: galleryRaw,
      timings: timingsRaw,
      province: Province.fromJson(parsedJson['ostan']),
      city: City.fromJson(parsedJson['city']),
      region: Region.fromJson(parsedJson['region']),
      user: UserInComplex.fromJson(parsedJson['user']),
      likes: parsedJson['likes'] != null
          ? int.parse(parsedJson['likes'].toString())
          : 0,
      visitsNo: parsedJson['visitsNo'] != null
          ? int.parse(parsedJson['visitsNo'].toString())
          : 0,
      stars: parsedJson['stars'] != null
          ? double.parse(parsedJson['stars'].toString())
          : 0.0,
    );
  }
}
