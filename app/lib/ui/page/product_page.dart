import 'package:flexeat/bloc/product_cubit.dart';
import 'package:flexeat/bloc/product_packagings_cubit.dart';
import 'package:flexeat/bloc/state/product_packagings_state.dart';
import 'package:flexeat/bloc/state/product_state.dart';
import 'package:flexeat/domain/model/packaging.dart';
import 'package:flexeat/main.dart';
import 'package:flexeat/ui/dialog/nutrition_facts_dialog.dart';
import 'package:flexeat/ui/dialog/packaging_input_dialog.dart';
import 'package:flexeat/ui/view/articles_list_view.dart';
import 'package:flexeat/ui/view/link_article_view.dart';
import 'package:flexeat/ui/view/nutriton_facts_view.dart';
import 'package:flexeat/ui/widget/editable_header.dart';
import 'package:flexeat/ui/widget/packaging_selector.dart';
import 'package:flexeat/ui/widget/page_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  final int productId;
  final String initialName;

  const ProductPage({Key? key, required this.productId, this.initialName = ""})
      : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  void initState() {
    super.initState();
  }

  void _showPackagingDialog(BuildContext context) {
    final cubit = context.read<ProductPackagingsCubit>();
    showDialog(
        context: context,
        builder: (context) => PackagingInputDialog(
              onSubmit: (weight, label) =>
                  cubit.addPackaging(Packaging(weight: weight, label: label)),
            ));
  }

  void _showNutritionFactsDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => NutritionFactsDialog(productId: widget.productId));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => context
              .read<Factory<ProductPackagingsCubit, int>>()(widget.productId),
        ),
        BlocProvider<ProductCubit>(
            create: (context) =>
                context.read<Factory<ProductCubit, int>>()(widget.productId))
      ],
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
          appBar: AppBar(
            iconTheme: Theme.of(context).iconTheme.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant),
            actions: [
              IconButton(
                  onPressed: () {
                    context.read<ProductCubit>().remove();
                  },
                  icon: const Icon(Icons.delete))
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 12, right: 12, top: 0, bottom: 12),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: BlocBuilder<ProductCubit, ProductState>(
                      builder: (context, state) {
                        return EditableHeader(
                          initialText: state.productName,
                          style: Theme.of(context)
                              .textTheme
                              .headline1
                              ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant),
                          onSubmit: (text) =>
                              context.read<ProductCubit>().changeName(text),
                        );
                      },
                    ),
                  ),
                  PageSection(
                      icon: Icons.local_dining,
                      label: "Nutrition Facts",
                      body: BlocBuilder<ProductCubit, ProductState>(
                        builder: (context, state) {
                          final map = state.nutritionFacts.toMap();
                          if (map.values.every((element) => element == null)) {
                            return SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                    onPressed: () =>
                                        _showNutritionFactsDialog(context),
                                    child: Text(
                                      "Add".toUpperCase(),
                                    )));
                          }
                          return NutritionFactsView(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                              nutritionFacts: state.nutritionFacts,
                              onEdit: () => _showNutritionFactsDialog(context));
                        },
                      )),
                  PageSection(
                      icon: Icons.inventory,
                      label: "Packagings",
                      body: BlocBuilder<ProductPackagingsCubit,
                              ProductPackagingsState>(
                          builder: (context, state) => PackagingSelector(
                                packagings: state.packagings,
                                onAdd: () {
                                  _showPackagingDialog(context);
                                },
                              ))),
                  PageSection(
                      icon: Icons.link,
                      label: "Used as",
                      body: BlocBuilder<ProductCubit, ProductState>(
                          builder: (context, state) => ArticlesListView(
                                articles: state.compatibleArticles,
                                onUnlink: (articleId) => context
                                    .read<ProductCubit>()
                                    .unlinkArticle(articleId),
                                onAdd: () => showModalBottomSheet(
                                    context: context,
                                    builder: (context) => Provider(
                                          create: (context) => context.read<
                                                  Factory<ProductCubit, int>>()(
                                              widget.productId),
                                          child: Builder(builder: (context) {
                                            return LinkArticleView(
                                                onSubmitArticle: (article) {
                                                  context
                                                      .read<ProductCubit>()
                                                      .linkArticle(article.id);
                                                  Navigator.of(context).pop();
                                                },
                                                onSubmitText: (text) {
                                                  context
                                                      .read<ProductCubit>()
                                                      .linkNewArticle(text);
                                                  Navigator.of(context).pop();
                                                },
                                                articles:
                                                    state.availableArticles);
                                          }),
                                        )),
                              ))),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
