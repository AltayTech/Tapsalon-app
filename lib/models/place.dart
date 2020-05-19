import 'package:flutter/foundation.dart';

import '../models/complex_in_place.dart';
import '../models/facility.dart';
import '../models/field.dart';
import '../models/image.dart';
import 'palce_type.dart';

class Place with ChangeNotifier {
  final int id;
  final String title;
  final String excerpt;
  final String about;
  final String price;

//  final String timing;
  final String created_at;
  final String updated_at;
  final ComplexInPlace complexInPlace;
  final PlaceType placeType;
  final Image image;
  final List<Image> gallery;
  final List<Facility> facilities;
  final List<Field> fields;

  Place(
      {this.id,
      this.title,
      this.excerpt,
      this.about,
      this.price,
//      this.timing,
      this.created_at,
      this.updated_at,
      this.complexInPlace,
      this.placeType,
      this.image,
      this.gallery,
      this.facilities,
      this.fields});

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

    return Place(
      id: parsedJson['id'],
      title: parsedJson['title'],
      excerpt: parsedJson['excerpt'],
      about: parsedJson['about'],
      price: parsedJson['price'],
//      timing: parsedJson['timing'],
      created_at: parsedJson['created_at'],
      updated_at: parsedJson['updated_at'],
      complexInPlace: ComplexInPlace.fromJson(parsedJson['complex']),
      placeType: PlaceType.fromJson(parsedJson['place_type']),
      image: Image.fromJson(parsedJson['image']),

      gallery: galleryRaw,
      facilities: faciltyRaw,
      fields: fieldRaw,
    );
  }
}
