import 'package:flutter/foundation.dart';

class ComplexInPlace with ChangeNotifier {
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

  ComplexInPlace({
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
  });

  factory ComplexInPlace.fromJson(Map<String, dynamic> parsedJson) {
    return ComplexInPlace(
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
    );
  }
}
