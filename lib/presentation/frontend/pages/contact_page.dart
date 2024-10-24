import 'package:flutter/material.dart';
import 'package:flutter_abdullahtasdev_blog/presentation/frontend/widgets/layout/main_layout.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'İletişim',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Sosyal medya simgeleri
            ListTile(
              leading: const Icon(Icons.facebook, color: Colors.blue),
              title: const Text('Facebook'),
              onTap: () {
                // Facebook yönlendirme
              },
            ),
            ListTile(
              leading: const Icon(Icons.abc, color: Colors.lightBlue),
              title: const Text('Twitter'),
              onTap: () {
                // Twitter yönlendirme
              },
            ),
            const SizedBox(height: 20),

            // İletişim Formu
            const Text('İletişim Formu', style: TextStyle(fontSize: 20)),
            const TextField(
              decoration: InputDecoration(labelText: 'Adınız'),
            ),
            const SizedBox(height: 10),
            const TextField(
              decoration: InputDecoration(labelText: 'E-posta'),
            ),
            const SizedBox(height: 10),
            const TextField(
              decoration: InputDecoration(labelText: 'Mesajınız'),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Mesaj gönderme işlemi
              },
              child: const Text('Gönder'),
            ),
          ],
        ),
      ),
    );
  }
}
