import 'package:auto_route/annotations.dart';
import 'package:flexeat/ui/product_page.dart';
import 'package:flexeat/ui/products_list_page.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: ProductsListPage, initial: true),
    AutoRoute(page: ProductPage),
  ],
)
class $AppRouter {}
