import 'package:flutter/foundation.dart';
import 'package:abdullahtasdev/core/network/graphql_api_service.dart';

class BlogRepository {
  final GraphQLService _graphqlService = GraphQLService();

  // Yazılı blogları çekmek için GraphQL sorgusu
  Future<Map<String, dynamic>> fetchBlogs(int page, int pageSize) async {
    String fragment = '''
    fragment BlogFields on posts {
      id
      title
      cover_image
      created_at
      content
    }
    ''';

    String query = '''
    $fragment

    query GetPosts(\$offset: Int!, \$limit: Int!) {
      posts_aggregate(where: {audio_url: {_is_null: true}, is_published: {_eq: true}}) {
        aggregate {
          count
        }
      }
      posts(
        where: {audio_url: {_is_null: true}, is_published: {_eq: true}}, 
        limit: \$limit,
        offset: \$offset
      ) {
        ...BlogFields
      }
    }
    ''';

    final variables = {
      'limit': pageSize,
      'offset': (page - 1) * pageSize,
    };

    final result =
        await _graphqlService.performQuery(query, variables: variables);

    if (result.hasException) {
      if (kDebugMode) {
        print(result.exception.toString());
      }
      throw Exception(result.exception.toString());
    }

    final totalCount = result.data!['posts_aggregate']['aggregate']['count'];
    final posts = result.data!['posts'];

    return {
      'totalCount': totalCount,
      'posts': posts,
    };
  }

  // Belirli bir blogun detaylarını almak için GraphQL sorgusu
  Future<Map<String, dynamic>?> fetchBlogDetail(int blogId) async {
    String query = '''
    query GetBlogDetail(\$id: Int!) {
      posts_by_pk(id: \$id) {
        id
        title
        content
        cover_image
        created_at
      }
    }
    ''';

    final variables = {
      'id': blogId,
    };

    final result =
        await _graphqlService.performQuery(query, variables: variables);

    if (result.hasException) {
      if (kDebugMode) {
        print(result.exception.toString());
      }
      return null;
    }

    return result.data!['posts_by_pk'];
  }

  // Sesli blogları çekmek için GraphQL sorgusu
  Future<Map<String, dynamic>> fetchAudioBlogsPaginated(
      int page, int pageSize) async {
    String fragment = '''
    fragment AudioBlogFields on posts {
      id
      title
      cover_image
      audio_url
      created_at
      content
    }
    ''';

    String query = '''
    $fragment

    query GetAudioPosts(\$offset: Int!, \$limit: Int!) {
      posts_aggregate(where: {audio_url: {_is_null: false}, is_published: {_eq: true}}) {
        aggregate {
          count
        }
      }
      posts(
        where: {audio_url: {_is_null: false}, is_published: {_eq: true}},
        limit: \$limit,
        offset: \$offset
      ) {
        ...AudioBlogFields
      }
    }
    ''';

    final variables = {
      'limit': pageSize,
      'offset': (page - 1) * pageSize,
    };

    final result =
        await _graphqlService.performQuery(query, variables: variables);

    if (result.hasException) {
      if (kDebugMode) {
        print(result.exception.toString());
      }
      throw Exception(result.exception.toString());
    }

    final totalCount = result.data!['posts_aggregate']['aggregate']['count'];
    final posts = result.data!['posts'];

    return {
      'totalCount': totalCount,
      'posts': posts,
    };
  }

  // Modify the existing fetchAudioBlogs if needed
  Future<Map<String, dynamic>?> fetchAudioBlogById(int id) async {
    String query = '''
    query GetAudioPostById(\$id: Int!) {
      posts_by_pk(id: \$id) {
        id
        title
        cover_image
        audio_url
        content
        created_at
      }
    }
    ''';

    final result = await _graphqlService.performQuery(query, variables: {
      'id': id,
    });

    if (result.hasException) {
      if (kDebugMode) {
        print(result.exception.toString());
      }
      return null;
    }

    return result.data!['posts_by_pk'];
  }

  // Yazılı blog arama fonksiyonu
  Future<Map<String, dynamic>> searchBlogs(String query,
      {int page = 1, int pageSize = 10}) async {
    String fragment = '''
    fragment BlogFields on posts {
      id
      title
      cover_image
      created_at
      content
    }
    ''';

    String searchQuery = '''
    $fragment

    query SearchPosts(\$offset: Int!, \$limit: Int!, \$search: String!) {
      posts_aggregate(
        where: {
          audio_url: {_is_null: true}, 
          is_published: {_eq: true},
          title: {_ilike: \$search}
        }
      ) {
        aggregate {
          count
        }
      }
      posts(
        where: {
          audio_url: {_is_null: true}, 
          is_published: {_eq: true},
          title: {_ilike: \$search}
        }, 
        limit: \$limit,
        offset: \$offset
      ) {
        ...BlogFields
      }
    }
    ''';

    final variables = {
      'limit': pageSize,
      'offset': (page - 1) * pageSize,
      'search': '%$query%',
    };

    final result =
        await _graphqlService.performQuery(searchQuery, variables: variables);

    if (result.hasException) {
      if (kDebugMode) {
        print(result.exception.toString());
      }
      throw Exception(result.exception.toString());
    }

    final totalCount = result.data!['posts_aggregate']['aggregate']['count'];
    final posts = result.data!['posts'];

    return {
      'totalCount': totalCount,
      'posts': posts,
    };
  }

  // Sesli blog arama fonksiyonu
  Future<Map<String, dynamic>> searchAudioBlogs(String query,
      {int page = 1, int pageSize = 10}) async {
    String fragment = '''
    fragment AudioBlogFields on posts {
      id
      title
      cover_image
      audio_url
      created_at
      content
    }
    ''';

    String searchQuery = '''
    $fragment

    query SearchAudioPosts(\$offset: Int!, \$limit: Int!, \$search: String!) {
      posts_aggregate(
        where: {
          audio_url: {_is_null: false}, 
          is_published: {_eq: true},
          title: {_ilike: \$search}
        }
      ) {
        aggregate {
          count
        }
      }
      posts(
        where: {
          audio_url: {_is_null: false}, 
          is_published: {_eq: true},
          title: {_ilike: \$search}
        },
        limit: \$limit,
        offset: \$offset
      ) {
        ...AudioBlogFields
      }
    }
    ''';

    final variables = {
      'limit': pageSize,
      'offset': (page - 1) * pageSize,
      'search': '%$query%',
    };

    final result =
        await _graphqlService.performQuery(searchQuery, variables: variables);

    if (result.hasException) {
      if (kDebugMode) {
        print(result.exception.toString());
      }
      throw Exception(result.exception.toString());
    }

    final totalCount = result.data!['posts_aggregate']['aggregate']['count'];
    final posts = result.data!['posts'];

    return {
      'totalCount': totalCount,
      'posts': posts,
    };
  }
}
