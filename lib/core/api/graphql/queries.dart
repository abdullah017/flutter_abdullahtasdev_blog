class GraphQLQueries {
  String getPostByID = '''
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

  String fragment = '''
    fragment BlogFields on posts {
      id
      title
      cover_image
      created_at
      content
    }
    ''';

  String getPost = '''
    fragment BlogFields on posts {
      id
      title
      cover_image
      created_at
      content
    }

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

  String getBlogDetail = '''
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

  String fragmentAudioBlog = '''
    fragment AudioBlogFields on posts {
      id
      title
      cover_image
      audio_url
      created_at
      content
    }
    ''';

  String getAudioPosts = '''
    fragment AudioBlogFields on posts {
      id
      title
      cover_image
      audio_url
      created_at
      content
    }

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

  String getAudioPostById = '''
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

  String fragmentSearch = '''
    fragment BlogFields on posts {
      id
      title
      cover_image
      created_at
      content
    }
    ''';

  String searchPosts = '''
    fragment BlogFields on posts {
      id
      title
      cover_image
      created_at
      content
    }

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

  String fragmentSearchAudioBlog = '''
    fragment AudioBlogFields on posts {
      id
      title
      cover_image
      audio_url
      created_at
      content
    }
    ''';

  String searchAudioPosts = '''
   fragment AudioBlogFields on posts {
      id
      title
      cover_image
      audio_url
      created_at
      content
    }

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
}
