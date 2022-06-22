import 'package:dio/dio.dart';
import 'package:flexeat/bloc/dish_cubit.dart';
import 'package:flexeat/bloc/loading_cubit.dart';
import 'package:flexeat/bloc/navigation_cubit.dart';
import 'package:flexeat/bloc/nutrition_facts_form_model.dart';
import 'package:flexeat/bloc/product_cubit.dart';
import 'package:flexeat/bloc/product_packagings_cubit.dart';
import 'package:flexeat/bloc/products_list_cubit.dart';
import 'package:flexeat/bloc/recipes_list_cubit.dart';
import 'package:flexeat/data/local_article_repository.dart';
import 'package:flexeat/data/local_nutrition_facts_repository.dart';
import 'package:flexeat/data/local_packaging_repository.dart';
import 'package:flexeat/data/local_product_repository.dart';
import 'package:flexeat/data/local_recipe_repository.dart';
import 'package:flexeat/data/openfoodapi/food_api.dart';
import 'package:flexeat/domain/repository/article_repository.dart';
import 'package:flexeat/domain/repository/food_repository.dart';
import 'package:flexeat/domain/repository/nutrition_facts_repository.dart';
import 'package:flexeat/domain/repository/packaging_repository.dart';
import 'package:flexeat/domain/repository/product_repository.dart';
import 'package:flexeat/domain/repository/recipe_repository.dart';
import 'package:flexeat/domain/usecase/create_product.dart';
import 'package:flexeat/domain/usecase/create_product_from_ean.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart' hide Factory;
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import 'factory.dart';

class AppContainer {
  final KiwiContainer _container = KiwiContainer();

  AppContainer(Database database) {
    _container.registerSingleton<ProductRepository>(
        (container) => LocalProductRepository(container()));
    _container.registerSingleton((container) => LoadingCubit());
    _container.registerFactory((container) => ProductsListCubit(
        container(), container(), container(), container(), container()));
    _container.registerSingleton((container) => NavigationCubit());
    _container.registerFactory<PackagingRepository>(
        (container) => LocalPackagingRepository(container()));
    _container.registerFactory((container) => CreateProduct(container()));
    _container.registerSingleton<NutritionFactsRepository>(
        (container) => LocalNutritionFactsRepository(container()));
    _container.registerSingleton<ArticleRepository>(
        (container) => LocalArticleRepository(container()));
    _container
        .registerSingleton<RecipeRepository>((c) => LocalRecipeRepository(c()));
    _container.registerInstance(database);
    _container.registerFactory(
        (container) => RecipesListCubit(container(), container()));
    _container
        .registerFactory((c) => CreateProductFromEan(c(), c(), c(), c(), c()));
    _container.registerFactory<FoodRepository>((c) => FoodApi(c()));
    _container.registerSingleton((container) => Dio());
  }

  T provide<T>() => _container<T>();

  Factory<ProductCubit, int> productCubitFactory() => (int productId) =>
      ProductCubit(provide(), provide(), provide(), provide(), provide(),
          productId: productId);

  Factory<ProductPackagingsCubit, int> packagingsCubitFactory() =>
      (int productId) => ProductPackagingsCubit(_container(), productId);

  Factory<NutritionFactsFormModel, int> nutritionFactsFormModelFactory() =>
      (int productId) =>
          NutritionFactsFormModel(_container(), productId: productId);

  Factory<DishCubit, int> dishCubitFactory() => (int recipeId) => //
      DishCubit(_container(), _container(), _container(), _container(),
          recipeId: recipeId);

  List<Provider> buildServiceProviders() => [
        Provider<Factory<ProductCubit, int>>(
            create: (_) => productCubitFactory()),
        Provider<Factory<ProductPackagingsCubit, int>>(
            create: (_) => packagingsCubitFactory()),
        Provider<Factory<NutritionFactsFormModel, int>>(
            create: (_) => nutritionFactsFormModelFactory()),
        Provider<Factory<DishCubit, int>>(create: (_) => dishCubitFactory()),
        Provider<ArticleRepository>(create: (_) => provide()),
        Provider<PackagingRepository>(create: (_) => provide()),
      ];

  List<BlocProvider> buildBlocProviders() => [
        BlocProvider<NavigationCubit>(
          create: (context) => provide(),
        ),
        BlocProvider<ProductsListCubit>(
          create: (context) => provide(),
        ),
        BlocProvider<RecipesListCubit>(
          create: (context) => provide(),
        ),
        BlocProvider<LoadingCubit>(
          create: (context) => provide(),
        )
      ];
}
