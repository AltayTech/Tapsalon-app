import 'package:flutter/foundation.dart';
import 'package:tapsalon/models/image.dart';

class PlaceInComplex with ChangeNotifier {
  final int id;
  final String name;
  final String excerpt;
  final String about;
  final int price;
  final ImageObj image;
  final String created_at;
  final String updated_at;

  PlaceInComplex({
    this.id,
    this.name,
    this.excerpt,
    this.about,
    this.price,
    this.image,
    this.created_at,
    this.updated_at,
  });

  factory PlaceInComplex.fromJson(Map<String, dynamic> parsedJson) {
//    var ostanList = parsedJson['ostan'] as List;
//    List<Ostan> ostanRaw = new List<Ostan>();
//    ostanRaw = ostanList.map((i) => Ostan.fromJson(i)).toList();

    return PlaceInComplex(
      id: parsedJson['id'],
      name: parsedJson['name'],
      excerpt: parsedJson['excerpt'],
      about: parsedJson['about'],
      price: parsedJson['price'],
      image: ImageObj.fromJson(parsedJson['image']),
      created_at: parsedJson['created_at'],
      updated_at: parsedJson['updated_at'],
    );
  }
}
