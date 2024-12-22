// File: api/firebase/firebase_service.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  FirebaseService._privateConstructor();
  static final FirebaseService instance = FirebaseService._privateConstructor();

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }

  FirebaseAuth get auth => FirebaseAuth.instance;
  FirebaseStorage get storage => FirebaseStorage.instance;
}
