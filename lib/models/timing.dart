import 'package:flutter/foundation.dart';

class Timing with ChangeNotifier {
  final int id;
  final int place_id;
  final int gender;
  final String date_start;
  final String date_end;
  final int discount;
  final int reservable;
  final String created_at;
  final String updated_at;

  Timing(
      {this.id,
      this.place_id,
      this.gender,
      this.date_start,
      this.date_end,
      this.discount,
      this.reservable,
      this.created_at,
      this.updated_at});

  factory Timing.fromJson(Map<String, dynamic> parsedJson) {
    return Timing(
      id: parsedJson['id'],
      place_id: parsedJson['place_id'],
      gender: parsedJson['gender'],
      date_start: parsedJson['date_start'],
      date_end: parsedJson['date_end'],
      discount: parsedJson['discount'],
      reservable: parsedJson['reservable'],
      created_at: parsedJson['created_at'],
      updated_at: parsedJson['updated_at'],
    );
  }
}
