import 'package:flutter/foundation.dart';
import 'package:tapsalon/models/places_models/complex_in_place.dart';
import 'package:tapsalon/models/timing.dart';

import '../../models/facility.dart';
import '../../models/field.dart';
import '../../models/image.dart';
import '../city.dart';
import '../image_url.dart';
import '../places_models/place_type.dart';
import '../province.dart';
import '../region.dart';

class Place with ChangeNotifier {
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
  final ComplexInPlace complex;
  final PlaceType placeType;
  final List<Field> fields;
  final List<Facility> facilities;
  final ImageObj image;
  final List<ImageObj> gallery;
  final List<Timing> timings;
  final Province province;
  final City city;
  final Region region;

//  final UserInComplex user;
  final int likes_count;
  final int comments_count;
  final int visitsNo;
  final double rate;

  Place({
    required this.id,
    this.name = '',
    this.excerpt = '',
    this.about = '',
    this.timings_excerpt = '',
    this.price = 0,
    this.phone = '',
    this.mobile = '',
    this.address = '',
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.createdAt = '',
    this.updatedAt = '',
    this.liked = true,
    complex,
    placeType,
    this.fields = const [],
    this.facilities = const [],
    image,
    gallery,
    timings,
    province,
    city,
    region,
    likes_count,
    comments_count,
    visitsNo,
    rate,
  })  : this.complex = ComplexInPlace(),
        this.placeType = PlaceType(),
        this.image = ImageObj(),
        this.gallery = [],
        this.timings = [],
        this.province = Province(id: 1, name: ''),
        this.city = City(),
        this.region = Region(),
        this.likes_count = 0,
        this.comments_count = 0,
        this.visitsNo = 0,
        this.rate = 0;

  factory Place.fromJson(Map<String, dynamic> parsedJson) {
    List<ImageObj> galleryRaw = [];

    if (parsedJson['gallery'] != null) {
      var galleryList = parsedJson['gallery'] as List;
      galleryRaw = [];
      galleryRaw = galleryList.map((i) => ImageObj.fromJson(i)).toList();
    }

    var facilitiesList = parsedJson['facilities'] as List;
    List<Facility> faciltyRaw = [];
    faciltyRaw = facilitiesList.map((i) => Facility.fromJson(i)).toList();

    var filedsList = parsedJson['fields'] as List;
    List<Field> fieldRaw = [];
    fieldRaw = filedsList.map((i) => Field.fromJson(i)).toList();

    List<Timing> timingsRaw = [];
    if (parsedJson['timings'] != null) {
      var timingsList = parsedJson['timings'] as List;
      timingsRaw = [];
      timingsRaw = timingsList.map((i) => Timing.fromJson(i)).toList();
    }
    return Place(
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
      complex: ComplexInPlace.fromJson(parsedJson['complex']),
      placeType: PlaceType.fromJson(parsedJson['place_type']),
      fields: fieldRaw,
      facilities: faciltyRaw,
      image: parsedJson['image'] != null
          ? ImageObj.fromJson(parsedJson['image'])
          : ImageObj(
              id: 0,
              filename: '',
              url: ImageUrl(
                medium: 'assets/images/place_placeholder.jpeg',
                large: 'assets/images/place_placeholder.jpeg',
                thumb: 'assets/images/place_placeholder.jpeg',
              ),
              extension: ''),
      gallery: galleryRaw,
      timings: timingsRaw,
      province: Province.fromJson(parsedJson['ostan']),
      city: City.fromJson(parsedJson['city']),
      region: Region.fromJson(parsedJson['region']),
//      user: UserInComplex.fromJson(parsedJson['user']),
      likes_count: parsedJson['likes_count'] != null
          ? int.parse(parsedJson['likes_count'].toString())
          : 0,
      comments_count: parsedJson['comments_count'] != null
          ? int.parse(parsedJson['comments_count'].toString())
          : 0,
      visitsNo: parsedJson['visitsNo'] != null
          ? int.parse(parsedJson['visitsNo'].toString())
          : 0,
      rate: parsedJson['rate'] != null
          ? double.parse(parsedJson['rate'].toString())
          : 0.0,
    );
  }
}
