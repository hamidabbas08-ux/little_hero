import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/child_profile.dart';

class ChildProfileService {
  ChildProfileService._();

  static const String _nameKey = 'child_profile_name';
  static const String _ageKey = 'child_profile_age';
  static const String _avatarKey = 'child_profile_avatar';
  static const String _photoPathKey = 'child_profile_photo_path';

  static Future<ChildProfile?> loadProfile() async {
    final preferences = await SharedPreferences.getInstance();

    final name = preferences.getString(_nameKey)?.trim() ?? '';

    if (name.isEmpty) {
      return null;
    }

    final storedPhotoPath = preferences.getString(_photoPathKey);

    String? validPhotoPath;

    if (storedPhotoPath != null &&
        storedPhotoPath.isNotEmpty &&
        await File(storedPhotoPath).exists()) {
      validPhotoPath = storedPhotoPath;
    }

    return ChildProfile(
      name: name,
      age: preferences.getInt(_ageKey) ?? 5,
      avatar: preferences.getString(_avatarKey) ?? '🦸',
      photoPath: validPhotoPath,
    );
  }

  static Future<void> saveProfile(ChildProfile profile) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setString(_nameKey, profile.name.trim());

    await preferences.setInt(_ageKey, profile.age);

    await preferences.setString(_avatarKey, profile.avatar);

    if (profile.photoPath == null || profile.photoPath!.isEmpty) {
      await preferences.remove(_photoPathKey);
    } else {
      await preferences.setString(_photoPathKey, profile.photoPath!);
    }
  }

  static Future<String?> chooseAndSavePhoto() async {
    final picker = ImagePicker();

    final selectedImage = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      imageQuality: 85,
    );

    if (selectedImage == null) {
      return null;
    }

    final directory = await getApplicationDocumentsDirectory();

    final profileDirectory = Directory('${directory.path}/profile');

    if (!await profileDirectory.exists()) {
      await profileDirectory.create(recursive: true);
    }

    final extension = _fileExtension(selectedImage.path);

    final destination = File(
      '${profileDirectory.path}/'
      'child_profile_photo$extension',
    );

    if (await destination.exists()) {
      await destination.delete();
    }

    final savedFile = await File(selectedImage.path).copy(destination.path);

    return savedFile.path;
  }

  static Future<void> removeSavedPhoto(String? photoPath) async {
    if (photoPath == null || photoPath.isEmpty) {
      return;
    }

    final file = File(photoPath);

    if (await file.exists()) {
      await file.delete();
    }

    final preferences = await SharedPreferences.getInstance();

    await preferences.remove(_photoPathKey);
  }

  static String _fileExtension(String path) {
    final dotIndex = path.lastIndexOf('.');

    if (dotIndex == -1) {
      return '.jpg';
    }

    final extension = path.substring(dotIndex).toLowerCase();

    const supportedExtensions = {'.jpg', '.jpeg', '.png', '.webp'};

    if (!supportedExtensions.contains(extension)) {
      return '.jpg';
    }

    return extension;
  }
}
