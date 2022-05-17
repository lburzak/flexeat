import 'package:flexeat/bloc/product_cubit.dart';
import 'package:flexeat/domain/packaging.dart';
import 'package:flexeat/state/product_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  bool _editing = false;

  void _startEditing() {
    setState(() {
      _editing = true;
    });
  }

  void _stopEditing() {
    _save();
    setState(() {
      _editing = false;
    });
  }

  void _save() {
    context.read<ProductCubit>().save();
  }

  void _showPackagingDialog(BuildContext context) {
    final cubit = context.read<ProductCubit>();
    showDialog(
        context: context,
        builder: (context) => PackagingInputDialog(
              onSubmit: (weight, label) => cubit.addPackaging(weight, label),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 64, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32.0),
            child: _editing
                ? BlocBuilder<ProductCubit, ProductState>(
                    builder: (context, state) => TextFormField(
                          style: Theme.of(context).textTheme.headline5,
                          initialValue: state.productName,
                          onChanged: (text) =>
                              context.read<ProductCubit>().setName(text),
                        ))
                : Text(
                    context.select<ProductCubit, String>(
                        (cubit) => cubit.state.productName),
                    style: Theme.of(context).textTheme.headline1),
          ),
          _editing
              ? Column(
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
                    SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {},
                            child: Text(
                              "Add".toUpperCase(),
                            ))),
                  ],
                )
              : const SizedBox.shrink(),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: const [
                    Icon(Icons.inventory),
                    SizedBox(
                      width: 12,
                    ),
                    Text("Packagings")
                  ],
                ),
              ),
              BlocBuilder<ProductCubit, ProductState>(
                  builder: (context, state) => Row(
                        children: state.packagings
                            .map((packaging) => PackagingChip(packaging))
                            .cast<Widget>()
                            .expand((element) => [
                                  element,
                                  const SizedBox(
                                    width: 8,
                                  )
                                ])
                            .toList(growable: false),
                      )),
            ],
          ),
          const Spacer(),
          _editing
              ? Row(
                  children: [
                    FloatingActionButton.extended(
                      onPressed: () => _showPackagingDialog(context),
                      icon: const Icon(Icons.shopping_bag),
                      label: Text("Add packaging".toUpperCase()),
                    ),
                    const Spacer(),
                    FloatingActionButton(
                      onPressed: _stopEditing,
                      child: const Icon(Icons.save),
                    ),
                  ],
                )
              : Row(
                  children: [
                    FloatingActionButton(
                      onPressed: () {},
                      child: const Icon(Icons.attach_money),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    const Spacer(),
                    FloatingActionButton(
                      onPressed: _startEditing,
                      child: const Icon(Icons.edit),
                    ),
                  ],
                )
        ],
      ),
    );
  }
}

class PackagingChip extends StatelessWidget {
  final Packaging packaging;

  const PackagingChip(this.packaging, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(300)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              packaging.label,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: 8,
            ),
            Text("${packaging.weight} g"),
          ],
        ),
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
