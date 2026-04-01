import 'package:flutter/material.dart';


abstract final class ChatColors {
  /// Primary teal used throughout the chat UI.
  static const primary = Color(0xFF0E7C7B);

  /// Slightly darker teal for gradient starts.
  static const primaryDark = Color(0xFF0A6B6A);

  /// Light avatar gradient — start.
  static const avatarGradientStart = Color(0xFF78D8D7);

  /// Light avatar gradient — end.
  static const avatarGradientEnd = Color(0xFF27C4C3);

  /// Main dark text colour.
  static const textPrimary = Color(0xFF1A2332);

  /// Secondary / muted text colour.
  static const textSecondary = Color(0xFF8A9BB0);

  /// Screen background.
  static const background = Color(0xFFF5F8FC);

  /// Error / destructive colour.
  static const error = Color(0xFFE05C5C);
}

abstract final class ChatTextStyles {
  static const String _font = 'Nunito';

  static const appBarTitle = TextStyle(
    color: Colors.white,
    fontSize: 22,
    fontWeight: FontWeight.w800,
    fontFamily: _font,
  );

  static const appBarSubtitle = TextStyle(
    color: Color(0xB3FFFFFF), // white @ 70 %
    fontSize: 13,
    fontFamily: _font,
  );

  static const roomName = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: ChatColors.textPrimary,
    fontFamily: _font,
  );

  static const roomNameUnread = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: ChatColors.textPrimary,
    fontFamily: _font,
  );

  static const roomPreview = TextStyle(
    fontSize: 13,
    color: ChatColors.textSecondary,
    fontFamily: _font,
  );

  static const roomPreviewUnread = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: ChatColors.textPrimary,
    fontFamily: _font,
  );
}