import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/models/child_profile.dart';
import '../../../core/services/child_profile_service.dart';

class ChildProfileScreen extends StatefulWidget {
  final ValueChanged<ChildProfile> onSaved;
  final bool editingExistingProfile;

  const ChildProfileScreen({
    required this.onSaved,
    this.editingExistingProfile = false,
    super.key,
  });

  @override
  State<ChildProfileScreen> createState() => _ChildProfileScreenState();
}

class _ChildProfileScreenState extends State<ChildProfileScreen> {
  static const List<String> avatars = [
    '🦸',
    '🦸‍♀️',
    '👦',
    '👧',
    '🧒',
    '👶',
    '🐻',
    '🐼',
    '🦁',
    '🐰',
    '🦊',
    '🐯',
  ];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();

  int _age = 5;
  String _selectedAvatar = '🦸';
  String? _photoPath;

  bool _loading = true;
  bool _saving = false;
  bool _choosingPhoto = false;

  @override
  void initState() {
    super.initState();
    _loadExistingProfile();
  }

  Future<void> _loadExistingProfile() async {
    final profile = await ChildProfileService.loadProfile();

    if (!mounted) {
      return;
    }

    if (profile != null) {
      _nameController.text = profile.name;
      _age = profile.age;
      _selectedAvatar = profile.avatar;
      _photoPath = profile.photoPath;
    }

    setState(() {
      _loading = false;
    });
  }

  Future<void> _choosePhoto() async {
    if (_choosingPhoto) {
      return;
    }

    setState(() {
      _choosingPhoto = true;
    });

    try {
      final newPhotoPath = await ChildProfileService.chooseAndSavePhoto();

      if (!mounted || newPhotoPath == null) {
        return;
      }

      final previousPhoto = _photoPath;

      setState(() {
        _photoPath = newPhotoPath;
      });

      if (previousPhoto != null && previousPhoto != newPhotoPath) {
        await ChildProfileService.removeSavedPhoto(previousPhoto);
      }
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Photo could not be selected: $error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _choosingPhoto = false;
        });
      }
    }
  }

  Future<void> _removePhoto() async {
    final oldPhotoPath = _photoPath;

    setState(() {
      _photoPath = null;
    });

    await ChildProfileService.removeSavedPhoto(oldPhotoPath);
  }

  Future<void> _saveProfile() async {
    if (_saving || !_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _saving = true;
    });

    final profile = ChildProfile(
      name: _nameController.text.trim(),
      age: _age,
      avatar: _selectedAvatar,
      photoPath: _photoPath,
    );

    try {
      await ChildProfileService.saveProfile(profile);

      if (!mounted) {
        return;
      }

      widget.onSaved(profile);
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile could not be saved: $error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF0F8FF),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF0F8FF),
      appBar: widget.editingExistingProfile
          ? AppBar(
              backgroundColor: const Color(0xFF7D6CE7),
              foregroundColor: Colors.white,
              centerTitle: true,
              title: const Text(
                'Edit Child Profile',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            )
          : null,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                if (!widget.editingExistingProfile)
                  const Text(
                    'Welcome, Little Hero! 🦸',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 31,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF423671),
                    ),
                  ),
                if (!widget.editingExistingProfile) const SizedBox(height: 7),
                if (!widget.editingExistingProfile)
                  const Text(
                    'Create your learning profile',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF746B8A),
                    ),
                  ),
                const SizedBox(height: 23),
                _buildProfilePicture(),
                const SizedBox(height: 14),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 8,
                  children: [
                    FilledButton.icon(
                      onPressed: _choosingPhoto ? null : _choosePhoto,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF6C52B3),
                      ),
                      icon: _choosingPhoto
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.photo_library_rounded),
                      label: Text(
                        _choosingPhoto
                            ? 'Opening Gallery...'
                            : 'Choose Gallery Photo',
                      ),
                    ),
                    if (_photoPath != null)
                      OutlinedButton.icon(
                        onPressed: _removePhoto,
                        icon: const Icon(Icons.delete_outline_rounded),
                        label: const Text('Remove Photo'),
                      ),
                  ],
                ),
                const SizedBox(height: 25),
                _buildDetailsCard(),
                const SizedBox(height: 22),
                _buildAvatarSection(),
                const SizedBox(height: 25),
                FilledButton.icon(
                  onPressed: _saving ? null : _saveProfile,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(62),
                    backgroundColor: const Color(0xFFFF9B45),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(23),
                    ),
                  ),
                  icon: _saving
                      ? const SizedBox(
                          width: 23,
                          height: 23,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : Icon(
                          widget.editingExistingProfile
                              ? Icons.save_rounded
                              : Icons.play_arrow_rounded,
                          size: 29,
                        ),
                  label: Text(
                    _saving
                        ? 'Saving...'
                        : widget.editingExistingProfile
                        ? 'Save Profile'
                        : 'Start Learning',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePicture() {
    return Container(
      width: 175,
      height: 175,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFFFB34F), width: 6),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 15,
            offset: Offset(0, 7),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: _photoPath == null
          ? Text(_selectedAvatar, style: const TextStyle(fontSize: 100))
          : Image.file(
              File(_photoPath!),
              width: 175,
              height: 175,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Text(
                  _selectedAvatar,
                  style: const TextStyle(fontSize: 100),
                );
              },
            ),
    );
  }

  Widget _buildDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(27),
        border: Border.all(color: const Color(0xFFBEB1F5), width: 3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Child’s Name',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            maxLength: 24,
            decoration: InputDecoration(
              hintText: 'Enter child’s name',
              prefixIcon: const Icon(Icons.badge_rounded),
              filled: true,
              fillColor: const Color(0xFFF7F4FF),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            validator: (value) {
              final name = value?.trim() ?? '';

              if (name.isEmpty) {
                return 'Please enter the child’s name.';
              }

              if (name.length < 2) {
                return 'Please enter at least 2 letters.';
              }

              return null;
            },
          ),
          const SizedBox(height: 15),
          const Text(
            'Age',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<int>(
            initialValue: _age,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.cake_rounded),
              filled: true,
              fillColor: const Color(0xFFF7F4FF),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            items: List<DropdownMenuItem<int>>.generate(11, (index) {
              final age = index + 2;

              return DropdownMenuItem<int>(
                value: age,
                child: Text(
                  '$age Years',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              );
            }),
            onChanged: (value) {
              if (value == null) {
                return;
              }

              setState(() {
                _age = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7DE),
        borderRadius: BorderRadius.circular(27),
        border: Border.all(color: const Color(0xFFFFCA64), width: 3),
      ),
      child: Column(
        children: [
          const Text(
            'Choose an Avatar',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w900,
              color: Color(0xFF584015),
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'You can use an avatar instead of a photo.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: avatars.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              final avatar = avatars[index];
              final selected = avatar == _selectedAvatar && _photoPath == null;

              return Material(
                color: selected ? const Color(0xFFE2D9FF) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () async {
                    final oldPhotoPath = _photoPath;

                    setState(() {
                      _selectedAvatar = avatar;
                      _photoPath = null;
                    });

                    if (oldPhotoPath != null) {
                      await ChildProfileService.removeSavedPhoto(oldPhotoPath);
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected
                            ? const Color(0xFF6C52B3)
                            : const Color(0xFFFFCA64),
                        width: selected ? 5 : 2,
                      ),
                    ),
                    child: Text(avatar, style: const TextStyle(fontSize: 44)),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
