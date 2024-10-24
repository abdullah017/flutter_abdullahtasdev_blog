import 'package:flutter_abdullahtasdev_blog/core/network/graphql_service.dart';

class BlogRepository {
  final GraphQLService _graphqlService = GraphQLService();

  // Yazılı blogları çekmek için GraphQL sorgusu
Future<List<dynamic>> fetchBlogs() async {
    String query = '''
    query GetPosts {
      posts(where: {audio_url: {_is_null: true}, is_published: {_eq: true}}) {
        id
        title
        cover_image
        created_at
        content
      }
    }
    ''';

    final result = await _graphqlService.performQuery(query);

    if (result.hasException) {
      print(result.exception.toString());
      return [];
    }

    return result.data!['posts'];
  }

  // Sesli blogları çekmek için GraphQL sorgusu
Future<List<dynamic>> fetchAudioBlogs() async {
    String query = '''
    query GetAudioPosts {
      posts(where: {audio_url: {_is_null: false}, is_published: {_eq: true}}) {
        id
        title
        cover_image
        audio_url
        created_at
      }
    }
    ''';

    final result = await _graphqlService.performQuery(query);

    if (result.hasException) {
      print(result.exception.toString());
      return [];
    }

    return result.data!['posts'];
  }
}
