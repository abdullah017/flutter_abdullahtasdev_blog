# Abullahtas.dev Web Blog App

Bu proje, Flutter ile geliştirilen, Firebase ve Hasura destekli bir Blog Platformu web uygulamasıdır. Uygulama, güçlü bir Glassmorphism tasarımına sahip olup, SEO uyumluluğu, GetX ile state management, kullanıcı dostu bir arayüz ve yönetici paneli içerir. Projenin amacı, Flutter Web ile gelişmiş özellikler sunan bir blog platformu oluşturarak web üzerinde etkili bir deneyim sunmaktır.


# 🔗 Demo
Çalışan uygulamanın demosuna göz atmak için buraya [tıklayın](https://abdullahtas.dev/)

# 📂 Proje Klasör Yapısı

```

root
├── lib
│   ├── core
│   │   ├── network       # API entegrasyonları ve GraphQL yapılandırmaları
│   │   ├── utils         # Yardımcı işlevler ve genel araçlar
│   ├── data
│   │   ├── models        # Veri modelleri (User, Post, etc.)
│   │   ├── repositories  # Hasura ve Firebase veri işleme sınıfları
│   ├── presentation
│   │   ├── admin         # Admin paneli bileşenleri ve sayfaları
│   │   ├── frontend      # Kullanıcı arayüzüne ait sayfa ve bileşenler
│   │   ├── controllers   # GetX kontrollü yönetim (Frontend ve Backend)
│   │   ├── widgets       # Ortak kullanılan widgetlar
│   ├── themes            # Light ve Dark tema yapılandırması
│   └── main.dart         # Uygulama başlangıç noktası
├── assets                # Uygulamada kullanılan medya dosyaları
└── pubspec.yaml          # Paket bağımlılıkları ve ayarlar
```

# 🚀 Özellikler
* **Blog Gönderileri:** Yazılı ve sesli blog gönderileri desteği
* **Yönetici Paneli:** Blogları yönetme, düzenleme ve silme
* **Glassmorphism Tasarımı:** Modern ve şeffaf bir kullanıcı arayüzü
* **SEO Uyumluluğu:** meta_seo paketi ile SEO optimizasyonu
* **Dark ve Light Mod Desteği:** Kullanıcı deneyimini kişiselleştirme
* **Mobil ve Web Uyumlu:** Responsiveness ve mobil uyum

# 📦 Kullanılan Paketler
**GetX:** State management ve navigasyon

**meta_seo:** SEO optimizasyonu için meta etiket yönetimi

**firebase_storage:** Firebase depolama

**file_picker:** Dosya seçici

**audioplayers:** Sesli blog dosyalarını oynatmak için

**flutter_quill:** Zengin metin düzenleyici

**graphql_flutter:** GraphQL sorguları ve Hasura entegrasyonu


# 📋 Kurulum

Bu projeyi yerel ortamınızda çalıştırmak için aşağıdaki adımları takip edin:

## 1. Projeyi Klonlayın

```
git clone https://github.com/username/flutter-web-blog-platform.git
cd flutter-web-blog-platform
```

## 2. Gerekli Bağımlılıkları Yükleyin

```
flutter pub get
```
## 3. Firebase CLI Yapılandırması

Firebase CLI ile proje yapılandırması için bu makaleden faydalanabilirsiniz. [Makale için tıklayın]([https://abdullahtas.dev/](https://abdullahtas.medium.com/flutter-firebase-cli-c47deb4447a7))

Firebase Console üzerinden aktif etmeniz gereken yapılar;

* Firebase Storage
* Firebase Auth

## 4. Hasura Ayarları
Hasura’yı kullanarak SQL sorgularınızı çalıştırabilir ve veritabanı işlemlerinizi yönetebilirsiniz.

GraphQL Uç Noktası: Hasura projenize uygun GraphQL uç noktasını **core/network/graphql_service.dart** dosyasına ekleyin.

Örnek SQL Sorguları: Aşağıdaki sorgular, Hasura veritabanında kullanılan örnek SQL sorgularıdır:

```
CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT,
    cover_image VARCHAR(255),
    audio_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## 5. Uygulamanın Çalıştırılması
Projenizi başlatmak için aşağıdaki komutu çalıştırın:

```
flutter run -d chrome
```

Projenizi çalıştırdığınızda görsel yüklenme sorunuyla karşılaşırsanız aşağıdaki komut ile çalıştırın:

```
flutter run -d chrome --web-renderer html

```

Eğer build alıp hosting ile deploy edecekseniz aşağıdaki komutu çalıştırarak build alabilirsiniz:

```

flutter build web --web-renderer html --release

```

Admin sayfasına giriş için **/admin-login** yazmanız gerekmektedir!




## 🤝 Katkıda Bulunma

Projeye katkıda bulunmak isterseniz, pull request gönderebilir veya GitHub Issues bölümünde hata bildiriminde bulunabilirsiniz. Katkılarınızı bekliyoruz!


Bir fork yapın.
Yeni bir branch oluşturun.

```
git checkout -b feature/ozellik-adi
```
Değişikliklerinizi commit edin.

```
git commit -m 'Özellik ekle: Yeni özellik'
```

Branch’i gönderin.

```
git push origin feature/ozellik-adi
```

Bir pull request açın.


## 📄 Lisans

Bu proje MIT Lisansı ile lisanslanmıştır. Daha fazla bilgi için LICENSE dosyasını inceleyin.

## 📞 İletişim

Herhangi bir sorunuz veya öneriniz varsa, bizimle iletişime geçmekten çekinmeyin.




# ADMİN EKRAN GÖRÜNTÜLERİ


<img width="1434" alt="Ekran Resmi 2024-10-28 16 43 04" src="https://github.com/user-attachments/assets/4d24ed92-d690-4cf1-a17b-29fadae0d70e">
<img width="1434" alt="Ekran Resmi 2024-10-28 16 42 50" src="https://github.com/user-attachments/assets/017e6f64-657f-41d3-9d53-7239eb61bc16">
<img width="1434" alt="Ekran Resmi 2024-10-28 16 42 34" src="https://github.com/user-attachments/assets/4ed0f277-c31d-495d-a868-117b438be797">
<img width="1434" alt="Ekran Resmi 2024-10-28 16 42 28" src="https://github.com/user-attachments/assets/7f4a1d0c-b22d-44ed-b672-80bb5541c8e9">


# BLOG EKRAN GÖRÜNTÜLERİ


<img width="333" alt="Ekran Resmi 2024-10-28 17 09 46" src="https://github.com/user-attachments/assets/fc5f67dd-3707-4299-8bf3-c36e24f2815c">
<img width="333" alt="Ekran Resmi 2024-10-28 17 09 41" src="https://github.com/user-attachments/assets/2228df2f-3657-42f5-bf06-d110e11cdcf2">
<img width="333" alt="Ekran Resmi 2024-10-28 17 09 35" src="https://github.com/user-attachments/assets/5c39e9a0-7780-4d1b-8d7f-35765f9103a5">
<img width="333" alt="Ekran Resmi 2024-10-28 17 09 31" src="https://github.com/user-attachments/assets/a0d60a4d-20ca-4984-80a0-cdfa60ed014e">
<img width="413" alt="Ekran Resmi 2024-10-28 17 14 15" src="https://github.com/user-attachments/assets/98272d9a-0d72-40cb-9288-298183074851">
<img width="1434" alt="Ekran Resmi 2024-10-28 17 09 03" src="https://github.com/user-attachments/assets/32cf0e66-ab41-41c4-81f7-37f56cc1639a">
<img width="1434" alt="Ekran Resmi 2024-10-28 17 08 59" src="https://github.com/user-attachments/assets/0321ad52-8978-4c4a-8775-ff5f20027f45">
<img width="1434" alt="Ekran Resmi 2024-10-28 17 08 55" src="https://github.com/user-attachments/assets/9f60a962-e7ff-4088-ad2d-6597e9e1b918">
<img width="1434" alt="Ekran Resmi 2024-10-28 17 13 58" src="https://github.com/user-attachments/assets/9a769212-b6f8-446b-a3ef-4b7fb2b3649e">



