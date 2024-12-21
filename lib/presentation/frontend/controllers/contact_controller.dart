import 'package:get/get.dart';

class ContactController extends GetxController {
  var isPopupVisible = false.obs;

  void showPopup() => isPopupVisible.value = true;
  void hidePopup() => isPopupVisible.value = false;

  void sendContactForm(String name, String email, String message) {
    // Add your form submission logic here
    // print('Name: $name, Email: $email, Message: $message');
  }
}
