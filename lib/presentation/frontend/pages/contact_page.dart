import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:abdullahtasdev/presentation/frontend/widgets/layout/main_layout.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage>
    with SingleTickerProviderStateMixin {
  double _opacity = 0.0;
  bool _isPopupVisible = false;

  @override
  void initState() {
    super.initState();
    // Start the opacity animation after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  void _showPopup() {
    setState(() {
      _isPopupVisible = true;
    });
  }

  void _hidePopup() {
    setState(() {
      _isPopupVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Obtain screen size
    final Size screenSize = MediaQuery.of(context).size;

    return MainLayout(
      body: SafeArea(
        child: Stack(
          children: [
            // Main Content with Blur Effect
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: AnimatedOpacity(
                    duration: const Duration(seconds: 1),
                    opacity: _opacity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                        child: Container(
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              if (constraints.maxWidth > 800) {
                                // Layout for large screens (e.g., tablets, desktops)
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // User Card
                                    Expanded(
                                      flex: 1,
                                      child: GestureDetector(
                                        onTap: _showPopup,
                                        child: _buildUserCard(screenSize),
                                      ),
                                    ),
                                    const SizedBox(width: 40),
                                    // Contact Form
                                    // Expanded(
                                    //   flex: 2,
                                    //   child: _buildContactForm(),
                                    // ),
                                  ],
                                );
                              } else {
                                // Layout for small screens (e.g., mobile)
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // _buildContactForm(),
                                    const SizedBox(height: 30),
                                    GestureDetector(
                                      onTap: _showPopup,
                                      child: _buildUserCard(screenSize),
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Popup Overlay
            if (_isPopupVisible) _buildPopup(screenSize),
          ],
        ),
      ),
    );
  }

  // ignore: unused_element
  Widget _buildContactForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'İletişim',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'İletişim Formu',
          style: TextStyle(
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            labelText: 'Adınız',
            labelStyle: const TextStyle(color: Colors.white),
            filled: true,
            fillColor: Colors.white.withOpacity(0.3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            labelText: 'E-posta',
            labelStyle: const TextStyle(color: Colors.white),
            filled: true,
            fillColor: Colors.white.withOpacity(0.3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
          ),
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            labelText: 'Mesajınız',
            labelStyle: const TextStyle(color: Colors.white),
            filled: true,
            fillColor: Colors.white.withOpacity(0.3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
          ),
          maxLines: 5,
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 20),
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.white.withOpacity(0.3),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
            ),
            onPressed: () {
              // Implement form submission logic here
            },
            child: const Text(
              'Gönder',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserCard(Size screenSize) {
    // Adjust card size based on screen width
    double avatarRadius = 50;
    double cardWidth = 300;

    if (screenSize.width < 600) {
      // For smaller screens, reduce the size
      avatarRadius = 40;
      cardWidth = screenSize.width * 0.8;
    }

    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // User Photo
          CircleAvatar(
            radius: avatarRadius,
            backgroundImage: const AssetImage(
                'assets/images/pp.jpg'), // Ensure the image exists in assets
            backgroundColor: Colors.transparent,
          ),
          const SizedBox(height: 20),
          // User Name
          const Text(
            'Abdullah Taş',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          // Email
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.email, color: Colors.white, size: 16),
              SizedBox(width: 10),
              Text(
                'info@abdullahtas.dev',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Social Media Icons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon:
                    const FaIcon(FontAwesomeIcons.github, color: Colors.black),
                onPressed: () async {
                  try {
                    // Uygulamanın açılıp açılamayacağını kontrol et
                    if (await canLaunchUrl(
                        Uri.parse('github://user?username=abdullah017'))) {
                      await launchUrl(
                          Uri.parse('github://user?username=abdullah017'));
                    } else {
                      // Uygulama yüklü değilse web tarayıcısında aç
                      if (await canLaunchUrl(
                          Uri.parse('https://github.com/abdullah017'))) {
                        await launchUrl(
                            Uri.parse('https://github.com/abdullah017'),
                            mode: LaunchMode.externalApplication);
                      } else {
                        throw 'Link açılamıyor: GITHUB';
                      }
                    }
                  } catch (e) {
                    // Hata durumunda kullanıcıya bildirin
                    if (kDebugMode) {
                      print(e);
                    }
                  }
                },
              ),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.twitter,
                    color: Colors.lightBlue),
                onPressed: () async {
                  try {
                    // Uygulamanın açılıp açılamayacağını kontrol et
                    if (await canLaunchUrl(
                        Uri.parse('twitter://user?screen_name=0abdullahtas'))) {
                      await launchUrl(
                          Uri.parse('twitter://user?screen_name=0abdullahtas'));
                    } else {
                      // Uygulama yüklü değilse web tarayıcısında aç https://x.com/0abdullahtas
                      if (await canLaunchUrl(
                          Uri.parse('https://x.com/0abdullahtas'))) {
                        await launchUrl(Uri.parse('https://x.com/0abdullahtas'),
                            mode: LaunchMode.externalApplication);
                      } else {
                        throw 'Link açılamıyor: X';
                      }
                    }
                  } catch (e) {
                    // Hata durumunda kullanıcıya bildirin
                    if (kDebugMode) {
                      print(e);
                    }
                  }
                },
              ),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.instagram,
                    color: Colors.pink),
                onPressed: () async {
                  try {
                    // Uygulamanın açılıp açılamayacağını kontrol et
                    if (await canLaunchUrl(
                        Uri.parse('instagram://user?username=0abdullahtas'))) {
                      await launchUrl(
                          Uri.parse('instagram://user?username=0abdullahtas'));
                    } else {
                      // Uygulama yüklü değilse web tarayıcısında aç https://www.instagram.com/0abdullahtas/
                      if (await canLaunchUrl(Uri.parse(
                          'https://www.instagram.com/0abdullahtas/'))) {
                        await launchUrl(
                            Uri.parse(
                                'https://www.instagram.com/0abdullahtas/'),
                            mode: LaunchMode.externalApplication);
                      } else {
                        throw 'Link açılamıyor: INSTAGRAM';
                      }
                    }
                  } catch (e) {
                    // Hata durumunda kullanıcıya bildirin
                    if (kDebugMode) {
                      print(e);
                    }
                  }
                },
              ),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.linkedinIn,
                    color: Colors.blueAccent),
                onPressed: () async {
                  try {
                    // Uygulamanın açılıp açılamayacağını kontrol et
                    if (await canLaunchUrl(
                        Uri.parse('linkedin://in/abdullahtas'))) {
                      await launchUrl(Uri.parse('linkedin://in/abdullahtas'));
                    } else {
                      // Uygulama yüklü değilse web tarayıcısında aç https://www.linkedin.com/in/abdullahtas/
                      if (await canLaunchUrl(Uri.parse(
                          'https://www.linkedin.com/in/abdullahtas/'))) {
                        await launchUrl(
                            Uri.parse(
                                'https://www.linkedin.com/in/abdullahtas/'),
                            mode: LaunchMode.externalApplication);
                      } else {
                        throw 'Link açılamıyor: INSTAGRAM';
                      }
                    }
                  } catch (e) {
                    // Hata durumunda kullanıcıya bildirin
                    if (kDebugMode) {
                      print(e);
                    }
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          // About Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.white.withOpacity(0.3),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
            ),
            onPressed: _showPopup,
            child: const Text(
              'Hakkımda',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopup(Size screenSize) {
    // Determine popup width based on screen size
    double popupWidth = screenSize.width * 0.75;
    double popupMaxWidth = 600;
    if (popupWidth > popupMaxWidth) popupWidth = popupMaxWidth;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: _isPopupVisible ? 1.0 : 0.0,
      child: _isPopupVisible
          ? GestureDetector(
              onTap: _hidePopup,
              child: Container(
                width: screenSize.width,
                height: screenSize.height,
                color: Colors.black
                    .withOpacity(0.5), // Semi-transparent background
                child: Center(
                  child: GestureDetector(
                    onTap:
                        () {}, // Prevents tap events from propagating to the background
                    child: AnimatedScale(
                      scale: _isPopupVisible ? 1.0 : 0.8,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          child: Container(
                            width: popupWidth,
                            padding: const EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1.5,
                              ),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Popup Title
                                  const Text(
                                    'Hakkımda',
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  // About Text
                                  const Text(
                                    'Merhaba! Ben Abdullah Taş, yazılım geliştirme alanında tutkulu bir geliştiriciyim. Flutter ve Dart ile mobil uygulamalar geliştirmekte uzmanlaşmış bulunuyorum. Ayrıca, web teknolojileri ve backend geliştirme konularında da deneyim sahibiyim.',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 20),
                                  // Close Button
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor:
                                          Colors.white.withOpacity(0.3),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      elevation: 5,
                                    ),
                                    onPressed: _hidePopup,
                                    child: const Text(
                                      'Kapat',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
