import 'package:flexeat/bloc/product_cubit.dart';
import 'package:flexeat/circle_button.dart';
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
    setState(() {
      _editing = false;
    });
  }

  void save() {
    context.read<ProductCubit>().save();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 64, bottom: 24),
      child: Column(
        children: [
          _editing
              ? BlocBuilder<ProductCubit, ProductState>(builder: (context, state) => TextFormField(
            initialValue: state.productName,
            onChanged: (text) => context.read<ProductCubit>().setName(text),
          )
            )              : Text(context.select<ProductCubit, String>(
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
                      onPressed: () {},
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
