import 'package:flutter/material.dart';
import 'package:abdullahtasdev/core/utils/slug_navigation.dart';

class SearchResultCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final bool isAudio;

  const SearchResultCard({super.key, required this.item, required this.isAudio});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          if (isAudio) {
            Navigation.toAudioBlogDetail(item['title'], item['id']);
          } else {
            Navigation.toBlogDetail(item['title'], item['id']);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['title'] ?? 'Başlık Yok',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item['created_at'] ?? 'Tarih Yok',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              if (isAudio)
                const Icon(
                  Icons.audiotrack,
                  color: Colors.grey,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
