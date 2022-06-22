import 'package:auto_route/auto_route.dart';
import 'package:flexeat/ui/router/app_router.gr.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: const [RecipeTabRoute(), ProductTabRoute()],
      bottomNavigationBuilder: (_, tabsRouter) {
        return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: tabsRouter.activeIndex,
            onTap: tabsRouter.setActiveIndex,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.restaurant_menu), label: "Recipes"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart), label: "Products"),
            ]);
      },
    );
  }
}
