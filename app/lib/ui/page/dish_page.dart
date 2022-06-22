import 'package:auto_route/auto_route.dart';
import 'package:flexeat/bloc/dish_cubit.dart';
import 'package:flexeat/bloc/navigation_cubit.dart';
import 'package:flexeat/domain/model/dish.dart';
import 'package:flexeat/domain/model/ingredient.dart';
import 'package:flexeat/domain/model/nutrition_facts.dart';
import 'package:flexeat/domain/model/product_packaging.dart';
import 'package:flexeat/domain/repository/packaging_repository.dart';
import 'package:flexeat/main.dart';
import 'package:flexeat/ui/dialog/ingredient_form.dart';
import 'package:flexeat/ui/router/app_router.gr.dart';
import 'package:flexeat/ui/view/nutriton_facts_view.dart';
import 'package:flexeat/ui/view/product_packaging_selection_view.dart';
import 'package:flexeat/ui/view/product_packaging_view.dart';
import 'package:flexeat/ui/widget/editable_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class DishPage extends StatelessWidget {
  final int recipeId;

  const DishPage({Key? key, required this.recipeId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DishCubit>(
        create: (context) => context.read<Factory<DishCubit, int>>()(recipeId),
        child: BlocBuilder<DishCubit, Dish>(
          builder: (context, state) => DishView(dish: state),
        ));
  }
}

class DishView extends StatelessWidget {
  final Dish dish;

  const DishView({Key? key, required this.dish}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DishCubit>();
    final entries = dish.ingredients.entries.toList();
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("ADD INGREDIENT"),
        icon: const Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => BlocProvider<DishCubit>.value(
                    value: cubit,
                    child: Builder(builder: (context) {
                      return IngredientForm(onSubmit: (value, weight) {
                        context.read<DishCubit>().addIngredient(
                            value.matchedArticle?.id, value.input, weight);
                      });
                    }),
                  ));
        },
      ),
      appBar: AppBar(actions: [
        IconButton(
            onPressed: () {
              context.read<DishCubit>().remove();
            },
            icon: const Icon(Icons.delete))
      ]),
      body: BlocListener<NavigationCubit, NavigationState>(
        listener: (context, state) {
          context.router.pop();
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: EditableHeader(
                  initialText: context.select<DishCubit, String>(
                      (cubit) => cubit.state.recipeHeader.name),
                  onSubmit: (text) =>
                      context.read<DishCubit>().changeName(text),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: NutritionFactsView(
                    nutritionFacts: context.select<DishCubit, NutritionFacts>(
                        (cubit) => cubit.state.nutritionFacts)),
              ),
              Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: entries.length,
                    itemBuilder: (context, index) => IngredientView(
                        ingredient: entries[index].key,
                        productPackaging: entries[index].value)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IngredientView extends StatelessWidget {
  final Ingredient ingredient;
  final ProductPackaging? productPackaging;

  const IngredientView(
      {Key? key, required this.ingredient, this.productPackaging})
      : super(key: key);

  void _showBindProductDialog(BuildContext context) {
    final packagingRepository = context.read<PackagingRepository>();
    final DishCubit cubit = context.read<DishCubit>();

    showModalBottomSheet(
        context: context,
        builder: (context) => MultiProvider(
              providers: [
                Provider<PackagingRepository>.value(
                  value: packagingRepository,
                ),
                Provider<DishCubit>.value(value: cubit)
              ],
              child: Builder(builder: (context) {
                return ProductPackagingSelectionView(
                  articleId: ingredient.article.id,
                  onSelected: (e) => context
                      .read<DishCubit>()
                      .selectProduct(ingredient.article.id, e.packaging.id),
                );
              }),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyText1!,
        child: ExpansionTile(
          leading: IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () {
              context.read<DishCubit>().removeIngredient(ingredient.article.id);
            },
          ),
          title: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        ingredient.article.name,
                        maxLines: 3,
                      ),
                    ),
                    Visibility(
                      visible: productPackaging == null,
                      child: IconButton(
                          onPressed: () => _showBindProductDialog(context),
                          icon: Icon(
                            Icons.link,
                            color: Theme.of(context).colorScheme.primary,
                          )),
                    ),
                    const Spacer(),
                    Text("${ingredient.weight} g"),
                  ],
                ),
              ),
              productPackaging != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: GestureDetector(
                        child: ProductPackagingView(
                            productPackaging: productPackaging!),
                        onLongPress: () => _showBindProductDialog(context),
                        onTap: () => context.navigateTo(ProductRoute(
                            productId: productPackaging!.product.id)),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
          childrenPadding: const EdgeInsets.all(16),
          children: [
            NutritionFactsView(
                nutritionFacts: productPackaging == null
                    ? const NutritionFacts()
                    : productPackaging!.nutritionFacts
                        .scaled(ingredient.weight))
          ],
        ),
      ),
    );
  }
}
