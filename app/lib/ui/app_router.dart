import 'package:auto_route/annotations.dart';
import 'package:flexeat/ui/dish_page.dart';
import 'package:flexeat/ui/product_page.dart';
import 'package:flexeat/ui/products_list_page.dart';
import 'package:flexeat/ui/recipes_list_page.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: ProductsListPage),
    AutoRoute(page: ProductPage),
    AutoRoute(page: DishPage),
    AutoRoute(page: RecipesListPage, initial: true)
  ],
)
class $AppRouter {}
