import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AudioBlogBackgroundImage extends StatelessWidget {
  final String imageUrl;

  const AudioBlogBackgroundImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      errorWidget: (context, url, error) => Image.network(
        'https://placekitten.com/800/400',
        fit: BoxFit.cover,
      ),
    );
  }
}
