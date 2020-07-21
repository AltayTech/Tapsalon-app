import 'package:flutter/foundation.dart';

import '../../models/field.dart';
import '../../models/image.dart';
import '../city.dart';
import '../image_url.dart';
import '../province.dart';
import '../region.dart';

class PlaceFavorite with ChangeNotifier {
  final int id;
  final String name;
  final String excerpt;
  final String about;
  final int price;
  final String mobile;
  final String address;
  final String createdAt;
  final String updatedAt;
  final List<Field> fields;
  final ImageObj image;
  final Province province;
  final City city;
  final Region region;
  final double rate;

  PlaceFavorite(
      {this.id,
      this.name,
      this.excerpt,
      this.about,
      this.price,
      this.mobile,
      this.address,
      this.createdAt,
      this.updatedAt,
      this.fields,
      this.image,
      this.province,
      this.city,
      this.region,
      this.rate});

  factory PlaceFavorite.fromJson(Map<String, dynamic> parsedJson) {
    var filedsList = parsedJson['fields'] as List;
    List<Field> fieldRaw = new List<Field>();
    fieldRaw = filedsList.map((i) => Field.fromJson(i)).toList();

    return PlaceFavorite(
      id: parsedJson['id'],
      name: parsedJson['name'],
      excerpt: parsedJson['excerpt'] != null ? parsedJson['excerpt'] : '',
      about: parsedJson['about'] != null ? parsedJson['about'] : '',
      price: parsedJson['price'] != null ? parsedJson['price'] : 0,
      mobile: parsedJson['mobile'] != null ? parsedJson['mobile'] : '',
      address: parsedJson['address'] != null ? parsedJson['address'] : '',
      createdAt:
          parsedJson['created_at'] != null ? parsedJson['created_at'] : '',
      updatedAt:
          parsedJson['updated_at'] != null ? parsedJson['updated_at'] : '',
      fields: fieldRaw,
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
      region: Region.fromJson(parsedJson['region']),
      rate: parsedJson['rate'] != null
          ? double.parse(parsedJson['rate'].toString())
          : 0.0,
    );
  }
}
