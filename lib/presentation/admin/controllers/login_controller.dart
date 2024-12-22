import 'package:abdullahtasdev/data/repositories/admin_repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class LoginController extends GetxController {
  final AuthRepository authRepository;

  LoginController({required this.authRepository});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      errorMessage.value = 'Email and password cannot be empty.';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final success = await authRepository.login(email, password);
      if (success) {
        Get.offAllNamed('/admin/dashboard');
      } else {
        errorMessage.value = 'Invalid email or password.';
      }
    } catch (e) {
      errorMessage.value = 'An error occurred. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
