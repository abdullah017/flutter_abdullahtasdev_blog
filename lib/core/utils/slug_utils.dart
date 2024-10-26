// lib/utils/slug_utils.dart

class SlugUtils {
  // Slug oluşturma: başlık ve ID alır, temizler ve birleştirir
  static String createSlug(String title, int id) {
    // Başlığı küçük harfe çevir
    String formattedTitle = title.toLowerCase();

    // Boşlukları ve özel karakterleri '-' ile değiştir
    formattedTitle = formattedTitle.replaceAll(RegExp(r'\s+'), '-');
    formattedTitle = formattedTitle.replaceAll(RegExp(r'[^a-z0-9\-]'), '');

    // Gereksiz '-' karakterlerini kaldır
    formattedTitle = formattedTitle.replaceAll(RegExp(r'-{2,}'), '-');
    formattedTitle = formattedTitle.replaceAll(RegExp(r'^-+|-+$'), '');

    return '$formattedTitle-$id';
  }

  // Slug'dan ID'yi çıkarma
  static int extractIdFromSlug(String slug) {
    final parts = slug.split('-');
    final idStr = parts.isNotEmpty ? parts.last : '0';
    return int.tryParse(idStr) ?? 0;
  }
}
