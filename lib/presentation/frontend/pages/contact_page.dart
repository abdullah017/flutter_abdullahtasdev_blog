import 'package:abdullahtasdev/presentation/frontend/controllers/contact_controller.dart';
import 'package:abdullahtasdev/presentation/frontend/widgets/card/contact_card_widget.dart';
import 'package:abdullahtasdev/presentation/frontend/widgets/popup/popup_overlay_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ContactPage extends GetView<ContactController> {
  ContactPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (screenSize.width > 800)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Expanded(
                            flex: 1,
                            child: UserCard(),
                          ),
                          SizedBox(width: 40),
                          // Expanded(
                          //   flex: 2,
                          //   child: ContactForm(),
                          // ),
                        ],
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                         // ContactForm(),
                          SizedBox(height: 30),
                          UserCard(),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),

          // Popup Overlay
          Obx(
            () => controller.isPopupVisible.value
                ? PopupOverlay(onClose: controller.hidePopup)
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
