import 'package:flexeat/bloc/loading_cubit.dart';
import 'package:flexeat/bloc/navigation_cubit.dart';
import 'package:flexeat/bloc/nutrition_facts_form_model.dart';
import 'package:flexeat/bloc/product_cubit.dart';
import 'package:flexeat/bloc/product_packagings_cubit.dart';
import 'package:flexeat/bloc/products_list_cubit.dart';
import 'package:flexeat/data/database.dart' as database;
import 'package:flexeat/data/local_nutrition_facts_repository.dart';
import 'package:flexeat/data/local_packaging_repository.dart';
import 'package:flexeat/data/local_product_repository.dart';
import 'package:flexeat/repository/nutrition_facts_repository.dart';
import 'package:flexeat/repository/packaging_repository.dart';
import 'package:flexeat/repository/product_repository.dart';
import 'package:flexeat/ui/app_router.gr.dart';
import 'package:flexeat/usecase/create_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart' hide Factory;
import 'package:provider/provider.dart';
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
        appBarTheme: _buildAppBarTheme(),
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

  AppBarTheme _buildAppBarTheme() {
    return const AppBarTheme(backgroundColor: Colors.transparent, elevation: 0);
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

typedef Factory<T, P0> = T Function(P0 p0);

class AppContainer {
  final KiwiContainer _container = KiwiContainer();

  AppContainer(Database database) {
    _container.registerSingleton<ProductRepository>(
        (container) => LocalProductRepository(container()));
    _container.registerSingleton((container) => LoadingCubit());
    _container.registerFactory((container) =>
        ProductsListCubit(container(), container(), container(), container()));
    _container.registerSingleton((container) => NavigationCubit());
    _container.registerFactory<PackagingRepository>(
        (container) => LocalPackagingRepository(container()));
    _container.registerFactory((container) => CreateProduct(container()));
    _container.registerFactory<NutritionFactsRepository>(
        (container) => LocalNutritionFactsRepository());
    _container.registerInstance(database);
  }

  T provide<T>() => _container<T>();

  Factory<ProductCubit, int> productCubitFactory() => (int productId) =>
      ProductCubit(_container(), _container(), productId: productId);

  Factory<ProductPackagingsCubit, int> packagingsCubitFactory() =>
      (int productId) => ProductPackagingsCubit(_container(), productId);

  Factory<NutritionFactsFormModel, int> nutritionFactsFormModelFactory() =>
      (int productId) =>
          NutritionFactsFormModel(_container(), productId: productId);
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appRouter = AppRouter();
  late AppContainer container;
  bool loaded = false;

  @override
  Widget build(BuildContext context) {
    return loaded
        ? MultiProvider(
            providers: [
              Provider<Factory<ProductCubit, int>>(
                  create: (_) => container.productCubitFactory()),
              Provider<Factory<ProductPackagingsCubit, int>>(
                  create: (_) => container.packagingsCubitFactory()),
              Provider<Factory<NutritionFactsFormModel, int>>(
                  create: (_) => container.nutritionFactsFormModelFactory())
            ],
            child: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => container.provide<NavigationCubit>(),
                ),
                BlocProvider(
                  create: (context) => container.provide<ProductsListCubit>(),
                ),
                BlocProvider(
                  create: (context) => container.provide<LoadingCubit>(),
                )
              ],
              child: MaterialApp.router(
                  title: 'Flutter Demo',
                  routerDelegate: _appRouter.delegate(),
                  routeInformationParser: _appRouter.defaultRouteParser(),
                  theme: LightTheme(Theme.of(context)).build()),
            ),
          )
        : const CircularProgressIndicator();
  }

  @override
  void initState() {
    super.initState();
    database.openDatabase().then((db) {
      setState(() {
        container = AppContainer(db);
        loaded = true;
      });
    });
  }
}
