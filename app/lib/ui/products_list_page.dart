import 'package:flexeat/bloc/products_list_cubit.dart';
import 'package:flexeat/domain/product.dart';
import 'package:flexeat/state/products_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsListPage extends StatelessWidget {
  const ProductsListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsListCubit, ProductsListState>(
        builder: (context, state) => ListView.builder(
              itemCount: state.products.length,
              itemBuilder: (context, index) =>
                  ProductEntry(product: state.products[index]),
            ));
  }
}

class ProductEntry extends StatelessWidget {
  final Product product;

  const ProductEntry({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(product.name));
  }
}
