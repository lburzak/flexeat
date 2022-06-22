import 'package:auto_route/auto_route.dart';
import 'package:flexeat/ui/page/dish_page.dart';
import 'package:flexeat/ui/page/home_page.dart';
import 'package:flexeat/ui/page/product_page.dart';
import 'package:flexeat/ui/page/products_list_page.dart';
import 'package:flexeat/ui/page/recipes_list_page.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(path: '/', page: HomePage, children: [
      AutoRoute(
        name: 'RecipeTabRoute',
        page: EmptyRouterPage,
        children: [
          AutoRoute(path: '', page: RecipesListPage),
          AutoRoute(page: DishPage),
          RedirectRoute(path: '*', redirectTo: '')
        ],
      ),
      AutoRoute(
        name: 'ProductTabRoute',
        page: EmptyRouterPage,
        children: [
          AutoRoute(path: '', page: ProductsListPage),
          AutoRoute(path: 'product/:productId', page: ProductPage),
          RedirectRoute(path: '*', redirectTo: '')
        ],
      ),
    ]),
    AutoRoute(path: 'product/:productId', page: ProductPage),
  ],
)
class $AppRouter {}
