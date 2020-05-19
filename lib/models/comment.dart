import 'package:flutter/foundation.dart';
import '../models/user_in_comment.dart';

class Comment with ChangeNotifier {
  final int id;
  final int rate;
  final String content;
  final String createdAt;
  final String updatedAt;
  final UserInComment user;

  Comment(
      {this.id,
      this.rate,
      this.content,
      this.createdAt,
      this.updatedAt,
      this.user});

  factory Comment.fromJson(Map<String, dynamic> parsedJson) {
    return Comment(
        id: parsedJson['id'],
        rate: parsedJson['rate'],
        content: parsedJson['content'],
        createdAt: parsedJson['created_at'],
        updatedAt: parsedJson['updated_at'],
        user: UserInComment.fromJson(parsedJson['user']));
  }
}
