import 'package:flutter/foundation.dart';
import 'package:tapsalon/models/region.dart';

class MainRegions with ChangeNotifier {
  final int current_page;
  final List<Region> data;
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

  factory MainRegions.fromJson(Map<String, dynamic> parsedJson) {
    var dataList = parsedJson['data'] as List;
    List<Region> dataRaw = [];
    dataRaw = dataList.map((i) => Region.fromJson(i)).toList();

    return MainRegions(
      current_page: parsedJson['current_page'],
      data: dataRaw,
      from: parsedJson['from'],
      last_page: parsedJson['last_page'],
      last_page_url: parsedJson['last_page_url'],
      next_page_url: parsedJson['next_page_url'],
      path: parsedJson['path'],
      per_page: parsedJson['per_page'],
      prev_page_url: parsedJson['prev_page_url'],
      to: parsedJson['to'],
      total: parsedJson['total'],
      first_page_url: '',
    );
  }

  MainRegions(
      {required this.current_page,
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
      required this.total});
}
