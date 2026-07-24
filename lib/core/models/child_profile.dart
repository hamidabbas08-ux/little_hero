class ChildProfile {
  final String name;
  final int age;
  final String avatar;
  final String? photoPath;

  const ChildProfile({
    required this.name,
    required this.age,
    required this.avatar,
    this.photoPath,
  });

  bool get hasCustomPhoto {
    return photoPath != null && photoPath!.trim().isNotEmpty;
  }
}
