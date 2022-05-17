import 'package:flexeat/bloc/product_cubit.dart';
import 'package:flexeat/ui/product_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/in_memory_product_repository.dart';

void main() {
  runApp(const MyApp());
}

class LightTheme {
  final ThemeData _parent;
  final ColorScheme _colors;

  LightTheme(ThemeData parent)
      : _parent = parent,
        _colors = _buildColorScheme(parent);

  ThemeData build() {
    return _parent.copyWith(
        colorScheme: _colors,
        scaffoldBackgroundColor: _colors.surfaceVariant,
        textTheme: _buildTextTheme(_parent.textTheme),
        floatingActionButtonTheme:
            _buildFloatingActionButtonTheme(_parent.floatingActionButtonTheme),
        chipTheme: _buildChipTheme(_parent.chipTheme),
        iconTheme: _buildIconTheme(_parent.iconTheme));
  }

  static ColorScheme _buildColorScheme(ThemeData parent) {
    return parent.colorScheme.copyWith(
        background: const Color(0xffDFDFDF),
        primary: const Color(0xff005cb2),
        surfaceVariant: Colors.blue.shade600,
        onSurfaceVariant: Colors.white);
  }

  TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
        headline1: base.headline1?.copyWith(
          fontSize: 32,
          color: _colors.onBackground,
        ),
        headline5: base.headline5?.copyWith(
          color: _colors.onBackground,
        ),
        bodyText2:
            base.bodyText2?.copyWith(color: _colors.onPrimary, fontSize: 16));
  }

  FloatingActionButtonThemeData _buildFloatingActionButtonTheme(
      FloatingActionButtonThemeData base) {
    return base.copyWith(
        backgroundColor: _colors.primary,
        foregroundColor: _colors.onBackground);
  }

  ChipThemeData _buildChipTheme(ChipThemeData base) {
    return base.copyWith(
      backgroundColor: _colors.primary,
      // labelStyle: textTheme.bodyText2
    );
  }

  IconThemeData _buildIconTheme(IconThemeData base) {
    return base.copyWith(color: _colors.onBackground);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: LightTheme(Theme.of(context)).build(),
        home: Scaffold(
            body: BlocProvider(
          create: (_) => ProductCubit(InMemoryProductRepository()),
          child: const ProductPage(),
        )));
  }
}
