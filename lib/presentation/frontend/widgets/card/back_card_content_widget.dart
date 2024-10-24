import 'package:flutter/material.dart';

class BackCardContent extends StatelessWidget {
  final String summary;

  const BackCardContent(this.summary, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blueGrey[900],
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Blog summary
            Expanded(
              child: Text(
                summary,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
                maxLines: 5, // Adjusted to fit more words
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 12),

            // "Read More" button
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the detail page
                  // Example: Navigator.pushNamed(context, '/blog_detail', arguments: blogId);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                child: const Text('Devamını Oku'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
