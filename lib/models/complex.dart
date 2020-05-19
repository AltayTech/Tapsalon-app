import 'package:flutter/foundation.dart';
import 'package:tapsalon/models/field.dart';
import 'package:tapsalon/models/image.dart';

import '../models/place_in_complex.dart';
import '../models/region.dart';
import '../models/user_in_complex.dart';
import 'city.dart';
import 'province.dart';

class Complex with ChangeNotifier {
  final int id;
  final double latitude;
  final double longitude;
  final String name;
  final String excerpt;
  final String about;
  final String address;
  final int likesNo;
  final int visitsNo;
  final double stars;
  final String phone;
  final String mobile;
  final String createdAt;
  final String updatedAt;
  final UserInComplex user;
  final Image image;

  final List<PlaceInComplex> placeList;
  final List<Field> fieldList;
  final List<Image> gallery;
  final Province province;
  final City city;
  final Region region;

  Complex({
    this.id,
    this.latitude,
    this.longitude,
    this.name,
    this.excerpt,
    this.about,
    this.address,
    this.likesNo,
    this.visitsNo,
    this.stars,
    this.phone,
    this.mobile,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.image,
    this.fieldList,
    this.placeList,
    this.province,
    this.city,
    this.region,
    this.gallery,
  });

  factory Complex.fromJson(Map<String, dynamic> parsedJson) {
    var placeList = parsedJson['places'] as List<dynamic>;
    List<PlaceInComplex> placeRaw = new List<PlaceInComplex>();
    placeRaw = placeList.map((i) => PlaceInComplex.fromJson(i)).toList();

    var fieldList = parsedJson['fields'] as List<dynamic>;
    List<Field> fieldRaw = new List<Field>();
    fieldRaw = fieldList.map((i) => Field.fromJson(i)).toList();

    var gallery = parsedJson['gallery'] as List<dynamic>;
    List<Image> galleryRaw = new List<Image>();
    galleryRaw = gallery.map((i) => Image.fromJson(i)).toList();

    return Complex(
      id: parsedJson['id'],
      latitude: parsedJson['latitude'],
      longitude: parsedJson['longitude'],
      name: parsedJson['name'],
      excerpt: parsedJson['excerpt'],
      about: parsedJson['about'],
      address: parsedJson['address'],
      likesNo: parsedJson['likes_no'],
      visitsNo: parsedJson['visits_no'],
      stars: double.parse(parsedJson['stars'].toString()),
      phone: parsedJson['phone'],
      mobile: parsedJson['mobile'],
      createdAt: parsedJson['created_at'],
      updatedAt: parsedJson['updated_at'],
      province: Province.fromJson(parsedJson['ostan']),
      image: Image.fromJson(parsedJson['image']),
      placeList: placeRaw,
      fieldList: fieldRaw,
      gallery: galleryRaw,
      user: UserInComplex.fromJson(parsedJson['user']),
      city: City.fromJson(parsedJson['city']),
      region: Region.fromJson(parsedJson['region']),
    );
  }
}
