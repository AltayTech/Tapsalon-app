import 'package:flutter/foundation.dart';
import 'package:tapsalon/models/places_models/place_in_search.dart';

class MainPlaces with ChangeNotifier {
  final int current_page;
  final List<PlaceInSearch> data;
  final String first_page_url;
  final int from;
  final int last_page;
  final String last_page_url;
  final String next_page_url;
  final String path;
  final int per_page;
  final String prev_page_url;
  final int to;
  final int total;

  MainPlaces({
    required this.current_page,
    required this.data,
    required this.first_page_url,
    required this.from,
    required this.last_page,
    required this.last_page_url,
    required this.next_page_url,
    required this.path,
    required this.per_page,
    required this.prev_page_url,
    required this.to,
    required this.total,
  });

  factory MainPlaces.fromJson(Map<String, dynamic> parsedJson) {
    List<PlaceInSearch> dataRaw = [];
    if (parsedJson['data'] != null) {
      var dataList = parsedJson['data'] as List;

      dataRaw = dataList.map((i) => PlaceInSearch.fromJson(i)).toList();
    }
    return MainPlaces(
      current_page:
          parsedJson['current_page'] != null ? parsedJson['current_page'] : 0,
      data: dataRaw,
      from: parsedJson['from'] != null ? parsedJson['from'] : 0,
      last_page: parsedJson['last_page'] != null ? parsedJson['last_page'] : 0,
      last_page_url: parsedJson['last_page_url'] != null
          ? parsedJson['last_page_url']
          : '',
      next_page_url: parsedJson['next_page_url'] != null
          ? parsedJson['next_page_url']
          : '',
      path: parsedJson['path'] != null ? parsedJson['path'] : '',
      per_page: parsedJson['per_page'] != null ? parsedJson['per_page'] : 0,
      prev_page_url: parsedJson['prev_page_url'] != null
          ? parsedJson['prev_page_url']
          : '',
      to: parsedJson['to'] != null ? parsedJson['to'] : 0,
      total: parsedJson['total'] != null ? parsedJson['total'] : 0,
      first_page_url: '',
    );
  }
}
