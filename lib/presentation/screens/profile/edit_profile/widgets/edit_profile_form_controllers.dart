import 'package:flutter/material.dart';

class EditProfileFormControllers {
  static final formKey         = GlobalKey<FormState>();
  static final nameCtrl        = TextEditingController();
  static final phoneCtrl       = TextEditingController();
  static final placeCtrl       = TextEditingController();
  static final bioCtrl         = TextEditingController();
  static final experienceCtrl  = TextEditingController();
  static bool _initialized     = false;

  /// Call once when the form first loads.
  static void init({
    required String name,
    required String phone,
    required String place,
    required String bio,
    required int experience,
  }) {
    if (_initialized) return;
    nameCtrl.text       = name;
    phoneCtrl.text      = phone;
    placeCtrl.text      = place;
    bioCtrl.text        = bio;
    experienceCtrl.text = experience.toString();
    _initialized        = true;
  }

  /// Call this when the screen is permanently dismissed
  /// so controllers reset for a fresh open next time.
  static void reset() {
    _initialized = false;
    nameCtrl.clear();
    phoneCtrl.clear();
    placeCtrl.clear();
    bioCtrl.clear();
    experienceCtrl.clear();
  }
}