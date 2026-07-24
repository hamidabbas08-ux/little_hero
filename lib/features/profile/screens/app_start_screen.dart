import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/models/child_profile.dart';
import '../../../core/services/child_profile_service.dart';
import 'child_profile_screen.dart';

enum _StartupStage { loading, createProfile, welcome, home }

class AppStartScreen extends StatefulWidget {
  final WidgetBuilder homeBuilder;

  const AppStartScreen({required this.homeBuilder, super.key});

  @override
  State<AppStartScreen> createState() => _AppStartScreenState();
}

class _AppStartScreenState extends State<AppStartScreen> {
  _StartupStage _stage = _StartupStage.loading;
  ChildProfile? _profile;
  Timer? _welcomeTimer;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await ChildProfileService.loadProfile();

    if (!mounted) {
      return;
    }

    if (profile == null) {
      setState(() {
        _stage = _StartupStage.createProfile;
      });
      return;
    }

    _showWelcome(profile);
  }

  void _showWelcome(ChildProfile profile) {
    _welcomeTimer?.cancel();

    setState(() {
      _profile = profile;
      _stage = _StartupStage.welcome;
    });

    _welcomeTimer = Timer(const Duration(milliseconds: 1800), () {
      if (!mounted) {
        return;
      }

      setState(() {
        _stage = _StartupStage.home;
      });
    });
  }

  void _profileSaved(ChildProfile profile) {
    _showWelcome(profile);
  }

  @override
  void dispose() {
    _welcomeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (_stage) {
      case _StartupStage.loading:
        return const Scaffold(
          backgroundColor: Color(0xFFF0F8FF),
          body: Center(child: CircularProgressIndicator()),
        );

      case _StartupStage.createProfile:
        return ChildProfileScreen(onSaved: _profileSaved);

      case _StartupStage.welcome:
        return _buildWelcomeScreen();

      case _StartupStage.home:
        return widget.homeBuilder(context);
    }
  }

  Widget _buildWelcomeScreen() {
    final profile = _profile!;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F8FF),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(25),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFBDEBFF), Color(0xFFFFF4C7)],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildProfileImage(profile),
              const SizedBox(height: 25),
              Text(
                'Welcome back, ${profile.name}! 👋',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 33,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF3F3561),
                ),
              ),
              const SizedBox(height: 11),
              Text(
                '${profile.age} Years Old',
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF6B6380),
                ),
              ),
              const SizedBox(height: 27),
              const Text(
                'Get ready to play, learn and grow!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF574E6A),
                ),
              ),
              const SizedBox(height: 27),
              const SizedBox(
                width: 42,
                height: 42,
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                  color: Color(0xFF6C52B3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage(ChildProfile profile) {
    return Container(
      width: 190,
      height: 190,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFFFB34F), width: 7),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 18,
            offset: Offset(0, 9),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: profile.hasCustomPhoto
          ? Image.file(
              File(profile.photoPath!),
              width: 190,
              height: 190,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Text(
                  profile.avatar,
                  style: const TextStyle(fontSize: 108),
                );
              },
            )
          : Text(profile.avatar, style: const TextStyle(fontSize: 108)),
    );
  }
}
