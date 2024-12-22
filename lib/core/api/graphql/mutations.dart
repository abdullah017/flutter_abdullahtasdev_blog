class GraphQLMutations {
  String addPost = '''
      mutation AddPost(\$title: String!, \$content: String!, \$coverImage: String, \$isPublished: Boolean!, \$audioUrl: String) {
        insert_posts(objects: {title: \$title, content: \$content, cover_image: \$coverImage, is_published: \$isPublished, audio_url: \$audioUrl}) {
          affected_rows
        }
      }
    ''';

  String updatePost = '''
      mutation UpdatePost(\$id: Int!, \$title: String!, \$content: String!, \$coverImage: String, \$isPublished: Boolean!, \$audioUrl: String) {
        update_posts(where: {id: {_eq: \$id}}, _set: {title: \$title, content: \$content, cover_image: \$coverImage, is_published: \$isPublished, audio_url: \$audioUrl}) {
          affected_rows
        }
      }
    ''';

  String deletePost = '''
      mutation DeletePost(\$id: Int!) {
        delete_posts(where: {id: {_eq: \$id}}) {
          affected_rows
        }
      }
    ''';
}
