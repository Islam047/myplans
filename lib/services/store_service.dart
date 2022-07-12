import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StoreService {
  static final _storage = FirebaseStorage.instance.ref();
  static const String _folder = 'post_images';

  static Future<String> uploadImage(File image) async {
    String imgName = 'img_${DateTime.now()}';
    Reference reference = _storage.child(_folder).child(imgName);
    UploadTask uploadTask = reference.putFile(image);
    TaskSnapshot snapshot = await uploadTask;
    final String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
