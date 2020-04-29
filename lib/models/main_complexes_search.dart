import 'package:flutter/foundation.dart';
import 'package:tapsalon/models/complex.dart';
import 'package:tapsalon/models/complex_search.dart';

class MainComplexesSearch with ChangeNotifier {
  final int current_page;
  final List<ComplexSearch> data;
  final String first_page_url;
  final int from;
  final int last_page;
  final String last_page_url;
  final String next_page_url;
  final String path;
  final String per_page;
  final String prev_page_url;
  final int to;
  final int total;

  MainComplexesSearch(
      {this.current_page,
      this.data,
      this.first_page_url,
      this.from,
      this.last_page,
      this.last_page_url,
      this.next_page_url,
      this.path,
      this.per_page,
      this.prev_page_url,
      this.to,
      this.total});

  factory MainComplexesSearch.fromJson(Map<String, dynamic> parsedJson) {
    var dataList = parsedJson['data'] as List;
    List<ComplexSearch> dataRaw = new List<ComplexSearch>();
    dataRaw = dataList.map((i) => ComplexSearch.fromJson(i)).toList();

    return MainComplexesSearch(
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
    );
  }
}
