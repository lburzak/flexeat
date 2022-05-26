import 'package:flexeat/bloc/loading_cubit.dart';
import 'package:flexeat/bloc/product_cubit.dart';
import 'package:flexeat/bloc/product_packagings_cubit.dart';
import 'package:flexeat/bloc/products_list_cubit.dart';
import 'package:flexeat/data/database.dart' as database;
import 'package:flexeat/data/local_packaging_repository.dart';
import 'package:flexeat/data/local_product_repository.dart';
import 'package:flexeat/repository/packaging_repository.dart';
import 'package:flexeat/repository/product_repository.dart';
import 'package:flexeat/ui/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:sqflite/sqflite.dart';

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
        onPrimary: Colors.white,
        surfaceVariant: Colors.blue.shade600,
        primaryContainer: const Color(0xff69b6ff),
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
      labelStyle: TextStyle(color: _colors.onPrimary),
      selectedColor: _colors.primaryContainer,
    );
  }

  IconThemeData _buildIconTheme(IconThemeData base) {
    return base.copyWith(color: _colors.onBackground);
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appRouter = AppRouter();
  late KiwiContainer container;
  bool loaded = false;

  @override
  Widget build(BuildContext context) {
    return loaded
        ? MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => container<ProductsListCubit>(),
              ),
              BlocProvider(
                create: (context) => container<ProductPackagingsCubit>(),
              ),
              BlocProvider(
                create: (context) => container<ProductCubit>(),
              )
            ],
            child: MaterialApp.router(
                title: 'Flutter Demo',
                routerDelegate: _appRouter.delegate(),
                routeInformationParser: _appRouter.defaultRouteParser(),
                theme: LightTheme(Theme.of(context)).build()),
          )
        : const CircularProgressIndicator();
  }

  @override
  void initState() {
    super.initState();
    database.openDatabase().then((db) {
      setState(() {
        container = buildContainer(db);
        loaded = true;
      });
    });
  }
}

KiwiContainer buildContainer(Database database) {
  final container = KiwiContainer();

  container
      .registerFactory((container) => ProductCubit(container(), container()));
  container.registerFactory<ProductRepository>(
      (container) => LocalProductRepository(container()));
  container.registerFactory((container) => LoadingCubit());
  container.registerFactory(
      (container) => ProductsListCubit(container(), container()));
  container
      .registerFactory((container) => ProductPackagingsCubit(container(), 1));
  container.registerFactory<PackagingRepository>(
      (container) => LocalPackagingRepository(container()));
  container.registerInstance(database);

  return container;
}
