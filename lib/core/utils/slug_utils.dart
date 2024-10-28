
class SlugUtils {
  // Türkçe karakterleri İngilizce karşılıklarına dönüştüren harita
  static final Map<String, String> _turkishCharMap = {
    'ı': 'i',
    'ğ': 'g',
    'ü': 'u',
    'ş': 's',
    'ö': 'o',
    'ç': 'c',
  };

  // Türkçe karakterleri dönüştürme fonksiyonu
  static String _replaceTurkishChars(String input) {
    _turkishCharMap.forEach((turkish, english) {
      input = input.replaceAll(turkish, english);
    });
    return input;
  }

  // Slug oluşturma: başlık ve ID alır, temizler ve birleştirir
  static String createSlug(String title, int id) {
    // Başlığı küçük harfe çevir ve Türkçe karakterleri değiştir
    String formattedTitle = _replaceTurkishChars(title.toLowerCase());

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
