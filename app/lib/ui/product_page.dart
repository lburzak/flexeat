import 'package:flexeat/bloc/loading_cubit.dart';
import 'package:flexeat/bloc/product_cubit.dart';
import 'package:flexeat/bloc/product_packagings_cubit.dart';
import 'package:flexeat/domain/packaging.dart';
import 'package:flexeat/state/product_packagings_state.dart';
import 'package:flexeat/state/product_state.dart';
import 'package:flexeat/ui/circle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../main.dart';

class ProductPage extends StatefulWidget {
  final int productId;
  final String initialName;

  const ProductPage({Key? key, required this.productId, this.initialName = ""})
      : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final _titleFocusNode = FocusNode();
  bool _editing = false;

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
          appBar: AppBar(),
          body: Padding(
            padding:
                const EdgeInsets.only(left: 12, right: 12, top: 0, bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: _editing
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 5),
                          child: BlocBuilder<ProductCubit, ProductState>(
                              builder: (context, state) => Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          focusNode: _titleFocusNode,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5,
                                          initialValue: state.productName,
                                          onChanged: (text) => context
                                              .read<ProductCubit>()
                                              .setName(text),
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              context
                                                  .read<ProductCubit>()
                                                  .save();
                                              _editing = false;
                                            });
                                          },
                                          icon: const Icon(Icons.done))
                                    ],
                                  )),
                        )
                      : Row(
                          children: [
                            InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Hero(
                                    tag: 'hero-productName-${widget.productId}',
                                    child: Material(
                                      type: MaterialType.transparency,
                                      child: BlocListener<LoadingCubit, bool>(
                                        listener: (context, state) =>
                                            print(state),
                                        child: Text(
                                            context.select<LoadingCubit, bool>(
                                                    (cubit) => cubit.state)
                                                ? widget.initialName
                                                : context.select<ProductCubit,
                                                        String>(
                                                    (cubit) => cubit
                                                        .state.productName),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline1),
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    _editing = true;
                                  });
                                  _titleFocusNode.requestFocus();
                                }),
                          ],
                        ),
                ),
                Column(
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.local_dining),
                        SizedBox(
                          width: 12,
                        ),
                        Text("Nutrition facts")
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () {},
                              child: Text(
                                "Add".toUpperCase(),
                              ))),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.inventory),
                              SizedBox(
                                width: 12,
                              ),
                              Text("Packagings")
                            ],
                          ),
                        ],
                      ),
                    ),
                    BlocBuilder<ProductPackagingsCubit, ProductPackagingsState>(
                        builder: (context, state) => PackagingSelector(
                              packagings: state.packagings,
                              onAdd: () {
                                _showPackagingDialog(context);
                              },
                            )),
                  ],
                ),
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
          children: [
            Text(packaging.label),
            const SizedBox(
              width: 8,
            ),
            Text(
              "${packaging.weight} g",
              style: const TextStyle(fontWeight: FontWeight.bold),
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
    return Row(
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
          .expand((element) => [
                element,
                const SizedBox(
                  width: 8,
                )
              ])
          .followedBy([
        CircleButton(
          size: 34,
          icon: Icons.add,
          onPressed: () {
            widget.onAdd?.call();
          },
        )
      ]).toList(growable: false),
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
