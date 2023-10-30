import 'package:flutter/foundation.dart';

import '../models/user_models/user_in_comment.dart';

class Comment with ChangeNotifier {
  final int id;
  final int place_id;
  final int rate;
  final String content;
  final String createdAt;
  final String updatedAt;
  final UserInComment user;

  Comment(
      {required this.id,
      required this.place_id,
      required this.rate,
      required this.content,
      required this.createdAt,
      required this.updatedAt,
      required this.user});

  factory Comment.fromJson(Map<String, dynamic> parsedJson) {
    return Comment(
        id: parsedJson['id'] != null ? parsedJson['id'] : 0,
        place_id: parsedJson['place_id'] != null ? parsedJson['place_id'] : 0,
        rate: parsedJson['rate'] != null ? parsedJson['rate'] : 0,
        content: parsedJson['content'] != null ? parsedJson['content'] : '',
        createdAt:
            parsedJson['created_at'] != null ? parsedJson['created_at'] : '',
        updatedAt:
            parsedJson['updated_at'] != null ? parsedJson['updated_at'] : '',
        user: parsedJson['user'] != null
            ? UserInComment.fromJson(parsedJson['user'])
            : UserInComment(
                id: 0,
                fname: '',
                lname: '',
                role_id: 0,
                gender: 0,
                phone: '',
                mobile: '',
                no_comments: 0,
                no_likes: 0,
                no_reserves: 0,
                wallet: '',
                created_at: '',
                updated_at: ''));
  }
}
