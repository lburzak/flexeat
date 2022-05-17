import 'package:flexeat/bloc/product_cubit.dart';
import 'package:flexeat/domain/packaging.dart';
import 'package:flexeat/ui/circle_button.dart';
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

  void _addPackaging(BuildContext context) {
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
        children: [
          _editing
              ? BlocBuilder<ProductCubit, ProductState>(
                  builder: (context, state) => TextFormField(
                        initialValue: state.productName,
                        onChanged: (text) =>
                            context.read<ProductCubit>().setName(text),
                      ))
              : Text(context.select<ProductCubit, String>(
                  (cubit) => cubit.state.productName)),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        "Add nutrition facts".toUpperCase(),
                        style: const TextStyle(fontSize: 12),
                      )))),
          BlocBuilder<ProductCubit, ProductState>(
              builder: (context, state) => Row(
                    children: state.packagings
                        .map((packaging) => PackagingChip(packaging))
                        .toList(growable: false),
                  )),
          const Spacer(),
          _editing
              ? Row(
                  children: [
                    const Spacer(),
                    CircleButton(
                      icon: Icons.save,
                      onPressed: _stopEditing,
                    ),
                  ],
                )
              : Row(
                  children: [
                    CircleButton(
                      icon: Icons.attach_money,
                      onPressed: () {},
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    CircleButton(
                      icon: Icons.add,
                      onPressed: () => _addPackaging(context),
                    ),
                    const Spacer(),
                    CircleButton(
                      icon: Icons.edit,
                      onPressed: _startEditing,
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
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Text(packaging.label),
            const SizedBox(width: 8,),
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
      content: Column(
        children: [
          TextFormField(
            onChanged: _changeLabel,
          ),
          TextFormField(
            onChanged: _changeWeight,
          ),
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
