import 'package:flutter/foundation.dart';
import 'package:flutter_abdullahtasdev_blog/core/network/graphql_service.dart';

class BlogRepository {
  final GraphQLService _graphqlService = GraphQLService();

  // Modify the existing fetchAudioBlogs if needed
  Future<Map<String, dynamic>?> fetchAudioBlogById(
      String name, email, message) async {
    String query = '''
    mutation InsertContact($name: String!, $email: String!, $message: String!) {
  insert_contacts_one(object: {name: $name, email: $email, message: $message}) {
    id
    name
    email
    message
    created_at
  }
}

    ''';

    final result = await _graphqlService.performQuery(query, variables: {});

    if (result.hasException) {
      if (kDebugMode) {
        print(result.exception.toString());
      }
      return null;
    }

    return result.data!['posts_by_pk'];
  }
}
