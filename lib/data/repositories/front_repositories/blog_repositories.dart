import 'package:abdullahtasdev/core/api/graphql/graphql_service.dart';
import 'package:abdullahtasdev/core/api/graphql/queries.dart';
import 'package:flutter/foundation.dart';

class BlogRepository {
  final GraphQLService _graphqlService = GraphQLService();
  final GraphQLQueries _queries = GraphQLQueries();

  // Yazılı blogları çekmek için GraphQL sorgusu
  Future<Map<String, dynamic>> fetchBlogs(int page, int pageSize) async {
    String query = _queries.getPost;

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
    String query = _queries.getBlogDetail;

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
    String query = _queries.getAudioPosts;

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
    String query = _queries.getAudioPostById;

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
    String searchQuery = _queries.searchPosts;

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
    String searchQuery = _queries.searchAudioPosts;

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
