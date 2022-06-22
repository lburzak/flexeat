import 'package:flutter/material.dart';

class LightTheme {
  final ThemeData _parent;
  final ColorScheme _colors;

  LightTheme(ThemeData parent)
      : _parent = parent,
        _colors = _buildColorScheme(parent);

  ThemeData build() {
    return _parent.copyWith(
        colorScheme: _colors,
        scaffoldBackgroundColor: _colors.background,
        textTheme: _buildTextTheme(_parent.textTheme),
        appBarTheme: _buildAppBarTheme(_parent.appBarTheme),
        floatingActionButtonTheme:
            _buildFloatingActionButtonTheme(_parent.floatingActionButtonTheme),
        chipTheme: _buildChipTheme(_parent.chipTheme),
        cardTheme: _buildCardTheme(_parent.cardTheme),
        iconTheme: _buildIconTheme(_parent.iconTheme));
  }

  static ColorScheme _buildColorScheme(ThemeData parent) {
    return parent.colorScheme.copyWith(
        background: const Color(0xfff5f5f5),
        primary: const Color(0xff005cb2),
        onPrimary: Colors.white,
        surfaceVariant: Colors.blue.shade600,
        primaryContainer: const Color(0xff69b6ff),
        onSurfaceVariant: Colors.white,
        onBackground: Colors.black);
  }

  AppBarTheme _buildAppBarTheme(AppBarTheme base) {
    return base.copyWith(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: _parent.iconTheme.copyWith(color: _colors.onBackground));
  }

  TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
        headline1: base.headline1?.copyWith(
          fontSize: 32,
          color: _colors.onBackground,
        ),
        headline5: base.headline5?.copyWith(color: _colors.onBackground),
        headline6: base.headline6?.copyWith(color: _colors.onBackground),
        bodyText1: base.bodyText1?.copyWith(fontSize: 16),
        bodyText2:
            base.bodyText2?.copyWith(color: _colors.onPrimary, fontSize: 16));
  }

  FloatingActionButtonThemeData _buildFloatingActionButtonTheme(
      FloatingActionButtonThemeData base) {
    return base.copyWith(
        backgroundColor: _colors.primary, foregroundColor: _colors.onPrimary);
  }

  ChipThemeData _buildChipTheme(ChipThemeData base) {
    return base.copyWith(
      backgroundColor: _colors.primary,
      labelStyle: TextStyle(color: _colors.onPrimary),
      selectedColor: _colors.primaryContainer,
    );
  }

  IconThemeData _buildIconTheme(IconThemeData base) {
    return base.copyWith(color: _colors.onBackground);
  }

  CardTheme _buildCardTheme(CardTheme base) {
    return base;
  }
}
