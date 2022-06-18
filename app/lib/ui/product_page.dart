import 'package:flexeat/bloc/product_cubit.dart';
import 'package:flexeat/bloc/product_packagings_cubit.dart';
import 'package:flexeat/model/nutrition_facts.dart';
import 'package:flexeat/model/packaging.dart';
import 'package:flexeat/state/product_packagings_state.dart';
import 'package:flexeat/state/product_state.dart';
import 'package:flexeat/ui/circle_button.dart';
import 'package:flexeat/ui/editable_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../model/article.dart';
import 'article_autocomplete_field.dart';
import 'nutrition_facts_dialog.dart';

class ProductPage extends StatefulWidget {
  final int productId;
  final String initialName;

  const ProductPage({Key? key, required this.productId, this.initialName = ""})
      : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class Section extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget body;

  const Section(
      {Key? key, required this.icon, required this.label, required this.body})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(icon,
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(label)
                ],
              ),
            ],
          ),
        ),
        body,
      ],
    );
  }
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
          ),
          body: Padding(
            padding:
                const EdgeInsets.only(left: 12, right: 12, top: 0, bottom: 12),
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
                        style: Theme.of(context).textTheme.headline1?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant),
                        onSubmit: (text) =>
                            context.read<ProductCubit>().changeName(text),
                      );
                    },
                  ),
                ),
                Section(
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
                        return NutritionFactsSection(
                            nutritionFacts: state.nutritionFacts,
                            onEdit: () => _showNutritionFactsDialog(context));
                      },
                    )),
                Section(
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
                Section(
                    icon: Icons.link,
                    label: "Used as",
                    body: BlocBuilder<ProductCubit, ProductState>(
                        builder: (context, state) => ArticlesList(
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
        );
      }),
    );
  }
}

class PackagingChip extends StatelessWidget {
  final Packaging packaging;
  final bool selected;
  final void Function(bool selected)? onSelected;

  const PackagingChip(this.packaging,
      {Key? key, this.selected = false, this.onSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
        selected: selected,
        onSelected: onSelected,
        elevation: 2,
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(packaging.label),
            const SizedBox(
              width: 8,
            ),
            Text(
              "${packaging.weight} g",
              style: Theme.of(context)
                  .chipTheme
                  .labelStyle
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }
}

class PackagingSelector extends StatefulWidget {
  final List<Packaging> packagings;
  final bool selectable;
  final void Function()? onAdd;

  const PackagingSelector(
      {Key? key, required this.packagings, this.selectable = true, this.onAdd})
      : super(key: key);

  @override
  State<PackagingSelector> createState() => _PackagingSelectorState();
}

class _PackagingSelectorState extends State<PackagingSelector> {
  int selectedId = 0;

  @override
  void initState() {
    selectedId = widget.packagings.isNotEmpty ? widget.packagings.first.id : 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Wrap(
        spacing: 6.0,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: widget.packagings
            .map((packaging) => PackagingChip(
                  packaging,
                  selected: packaging.id == selectedId,
                  onSelected: widget.selectable
                      ? (selected) {
                          if (selected) {
                            setState(() {
                              selectedId = packaging.id;
                            });
                          }
                        }
                      : null,
                ))
            .cast<Widget>()
            .followedBy([
          CircleButton(
            size: 34,
            icon: Icons.add,
            onPressed: () {
              widget.onAdd?.call();
            },
          )
        ]).toList(growable: false),
      ),
    );
  }
}

class LinkArticleView extends StatefulWidget {
  final List<Article> articles;
  final void Function(Article article)? onSubmitArticle;
  final void Function(String text)? onSubmitText;

  const LinkArticleView(
      {Key? key,
      required this.articles,
      this.onSubmitArticle,
      this.onSubmitText})
      : super(key: key);

  @override
  State<LinkArticleView> createState() => _LinkArticleViewState();
}

class _LinkArticleViewState extends State<LinkArticleView> {
  ArticleAutocompleteValue value = const ArticleAutocompleteValue(input: "");

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets + const EdgeInsets.all(16),
      duration: const Duration(milliseconds: 100),
      curve: Curves.decelerate,
      child: Row(
        children: [
          Expanded(
            child: ArticleAutocompleteField(
                articles: widget.articles,
                onChanged: (value) {
                  setState(() {
                    this.value = value;
                  });
                }),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 60,
            child: AspectRatio(
                aspectRatio: 1,
                child: ElevatedButton(
                    onPressed: _onSubmit, child: const Icon(Icons.link))),
          )
        ],
      ),
    );
  }

  void _onSubmit() {
    if (value.matchedArticle != null) {
      widget.onSubmitArticle?.call(value.matchedArticle!);
    } else {
      widget.onSubmitText?.call(value.input);
    }
  }
}

class ArticlesList extends StatelessWidget {
  final List<Article> articles;
  final void Function(int articleId)? onUnlink;
  final void Function()? onAdd;

  const ArticlesList(
      {Key? key, required this.articles, this.onUnlink, this.onAdd})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Wrap(
        spacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: articles
            .map((article) => Chip(
                  onDeleted: () {
                    onUnlink?.call(article.id);
                  },
                  label: Text(article.name),
                  deleteIcon: const Icon(
                    Icons.close,
                    size: 16,
                  ),
                  deleteIconColor: Colors.white,
                ))
            .cast<Widget>()
            .followedBy([
              CircleButton(
                size: 32,
                icon: Icons.add,
                onPressed: () {
                  onAdd?.call();
                },
              )
            ])
            .toList(growable: false)
            .toList(),
      ),
    );
  }
}

class PackagingInputDialog extends StatefulWidget {
  final void Function(int weight, String label)? onSubmit;

  const PackagingInputDialog({Key? key, this.onSubmit}) : super(key: key);

  @override
  State<PackagingInputDialog> createState() => _PackagingInputDialogState();
}

class _PackagingInputDialogState extends State<PackagingInputDialog> {
  String _label = "";
  String _weight = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("New packaging"),
      scrollable: true,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            decoration: const InputDecoration(
                labelText: "Label",
                hintText: "e.g. Box",
                prefixIcon: Icon(Icons.inventory)),
            onChanged: _changeLabel,
          ),
          TextFormField(
            decoration: const InputDecoration(
                labelText: "Net weight",
                suffixText: "grams",
                prefixIcon: Icon(Icons.scale)),
            keyboardType: TextInputType.number,
            onChanged: _changeWeight,
          ),
          const SizedBox(height: 40),
          TextFormField(
            decoration: InputDecoration(
                helperText: "Optional",
                labelText: "EAN",
                prefixIcon: const Icon(Icons.qr_code),
                suffixIcon: InkWell(
                  child: const Icon(Icons.photo_camera),
                  onTap: () {},
                )),
            keyboardType: TextInputType.number,
            onChanged: _changeLabel,
          )
        ],
      ),
      actions: [TextButton(onPressed: _submit, child: const Text("Add"))],
    );
  }

  void _changeLabel(String text) {
    setState(() {
      _label = text;
    });
  }

  void _changeWeight(String text) {
    setState(() {
      _weight = text;
    });
  }

  void _submit() {
    int weight = int.tryParse(_weight) ?? 0;

    widget.onSubmit?.call(weight, _label);

    Navigator.of(context).pop();
  }
}

class NutritionFactsSection extends StatelessWidget {
  final void Function()? onEdit;
  final NutritionFacts nutritionFacts;
  final Color? color;

  const NutritionFactsSection(
      {Key? key, required this.nutritionFacts, this.onEdit, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onEdit,
      child: Table(
        children: [
          TableRow(children: [
            NutritionFactCell(
                icon: Icon(Icons.bolt, color: color),
                value: nutritionFacts.energy),
            NutritionFactCell(
                icon: Icon(Icons.water_drop, color: color),
                value: nutritionFacts.fat),
            NutritionFactCell(
                icon: Icon(Icons.bakery_dining, color: color),
                value: nutritionFacts.carbohydrates),
          ]),
          TableRow(children: [
            NutritionFactCell(
                icon: Icon(Icons.hive, color: color),
                value: nutritionFacts.fibre),
            NutritionFactCell(
                icon: Icon(Icons.whatshot, color: color),
                value: nutritionFacts.protein),
            NutritionFactCell(
                icon: Icon(Icons.fitbit, color: color),
                value: nutritionFacts.salt),
          ]),
        ],
      ),
    );
  }
}

class NutritionFactCell extends StatelessWidget {
  final Icon icon;
  final double? value;

  const NutritionFactCell({Key? key, required this.icon, this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TableCell(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 12),
          Text("${doubleToStringOrQuestionMark(value)} g")
        ],
      ),
    ));
  }

  String doubleToStringOrQuestionMark(double? value) {
    if (value == null) {
      return '?';
    } else {
      final intValue = value.toInt();
      if (intValue == value) {
        return intValue.toString();
      } else {
        return value.toString();
      }
    }
  }
}
