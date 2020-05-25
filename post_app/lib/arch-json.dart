import 'dart:convert';
import 'package:http/http.dart' as http;
import 'post.dart';

class ArchJsonPyC {
  Future<List<Comment>> getComments(int postId) async {
    var url = 'https://jsonplaceholder.typicode.com/posts/$postId/comments';
    var response = await http.get(url);

    var comments = List<Comment>();

    if (response.statusCode == 200) {
      var commentsJson = json.decode(response.body);

      for (var commentJson in commentsJson) {
        comments.add(Comment.fromJson(commentJson));
      }
    }
    return comments;
  }
}