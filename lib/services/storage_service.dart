import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<String> uploadImage(
    Uint8List imageBytes,
    String fileName, {
    String folder = 'uploads',
  }) async {
    final ref = storage.ref().child('$folder/$fileName');

    await ref.putData(
      imageBytes,
      SettableMetadata(contentType: 'image/jpeg'),
    );

    return await ref.getDownloadURL();
  }
}