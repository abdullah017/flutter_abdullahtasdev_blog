import 'package:abdullahtasdev/core/network/graphql_api_service.dart';
import 'dart:developer' as developer;
class PostRepository {
  final GraphQLService _graphqlService = GraphQLService();

  // Tüm postları listeleme
  Future<List<dynamic>> getPosts({bool? isPublishedFilter}) async {
    String query = '''
    query GetPosts(\$isPublished: Boolean!) {
      posts(where: {is_published: {_eq: \$isPublished}}, order_by: {created_at: desc}) {
        id
        title
        content
        cover_image
        audio_url
        is_published
        created_at
      }
    }
  ''';

    final result = await _graphqlService.performQuery(query, variables: {
      'isPublished': isPublishedFilter,
    });

    if (result.hasException) {
      developer.log(result.exception.toString());
      return [];
    }

    return result.data!['posts'];
  }

// Post detaylarını ID'ye göre getir
  Future<Map<String, dynamic>> getPostById(int id) async {
    String query = '''
    query GetPostById(\$id: Int!) {
      posts_by_pk(id: \$id) {
        id
        title
        content
        cover_image
        audio_url
        is_published
        created_at
      }
    }
  ''';

    final result = await _graphqlService.performQuery(query, variables: {
      'id': id,
    });

    if (result.hasException) {
      developer.log(result.exception.toString());
      throw Exception("Failed to load post");
    }

    return result.data!['posts_by_pk'];
  }

  // Post ekleme
  Future<bool> addPost(String title, String content, String? coverImage,
      bool isPublished, String? audioUrl) async {
    String mutation = '''
      mutation AddPost(\$title: String!, \$content: String!, \$coverImage: String, \$isPublished: Boolean!, \$audioUrl: String) {
        insert_posts(objects: {title: \$title, content: \$content, cover_image: \$coverImage, is_published: \$isPublished, audio_url: \$audioUrl}) {
          affected_rows
        }
      }
    ''';

    final result = await _graphqlService.performMutation(mutation, variables: {
      'title': title,
      'content': content,
      'coverImage': coverImage,
      'isPublished': isPublished,
      'audioUrl': audioUrl,
    });

    if (result.hasException) {
      developer.log(result.exception.toString());
      return false;
    }

    return result.data!['insert_posts']['affected_rows'] > 0;
  }

  // Post güncelleme
  Future<bool> updatePost(int id, String title, String content,
      String? coverImage, bool isPublished, String? audioUrl) async {
    String mutation = '''
      mutation UpdatePost(\$id: Int!, \$title: String!, \$content: String!, \$coverImage: String, \$isPublished: Boolean!, \$audioUrl: String) {
        update_posts(where: {id: {_eq: \$id}}, _set: {title: \$title, content: \$content, cover_image: \$coverImage, is_published: \$isPublished, audio_url: \$audioUrl}) {
          affected_rows
        }
      }
    ''';

    final result = await _graphqlService.performMutation(mutation, variables: {
      'id': id,
      'title': title,
      'content': content,
      'coverImage': coverImage,
      'isPublished': isPublished,
      'audioUrl': audioUrl,
    });

    if (result.hasException) {
      developer.log(result.exception.toString());
      return false;
    }

    return result.data!['update_posts']['affected_rows'] > 0;
  }

  // Post silme
  Future<bool> deletePost(int id) async {
    String mutation = '''
      mutation DeletePost(\$id: Int!) {
        delete_posts(where: {id: {_eq: \$id}}) {
          affected_rows
        }
      }
    ''';

    final result = await _graphqlService.performMutation(mutation, variables: {
      'id': id,
    });

    if (result.hasException) {
      developer.log(result.exception.toString());
      return false;
    }

    return result.data!['delete_posts']['affected_rows'] > 0;
  }
}
