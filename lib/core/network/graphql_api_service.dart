import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLService {
  static final GraphQLService _instance = GraphQLService._internal();
  factory GraphQLService() => _instance;

  late GraphQLClient _client;

  GraphQLService._internal() {
    // Sadece HttpLink ile GraphQL bağlantısı
    HttpLink httpLink = HttpLink(
      'your_hasura_url', // GraphQL URL'inizi buraya yazın
      defaultHeaders: {
        'x-hasura-admin-secret':
            'your_hasura_secret_key', // Buraya Hasura admin secret'ınızı yazın
      },
    );

    _client = GraphQLClient(
      link: httpLink, // Sadece HttpLink kullanılıyor
      cache: GraphQLCache(store: InMemoryStore()),
    );
  }

  // GraphQL Sorgusu
  Future<QueryResult> performQuery(String query,
      {Map<String, dynamic> variables = const {}}) async {
    QueryOptions options = QueryOptions(
      document: gql(query),
      variables: variables,
    );
    return await _client.query(options);
  }

  // GraphQL Mutasyonu
  Future<QueryResult> performMutation(String mutation,
      {Map<String, dynamic> variables = const {}}) async {
    MutationOptions options = MutationOptions(
      document: gql(mutation),
      variables: variables,
    );
    return await _client.mutate(options);
  }
}
