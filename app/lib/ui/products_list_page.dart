import 'package:auto_route/auto_route.dart';
import 'package:flexeat/bloc/products_list_cubit.dart';
import 'package:flexeat/domain/product.dart';
import 'package:flexeat/state/products_list_state.dart';
import 'package:flexeat/ui/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsListPage extends StatelessWidget {
  const ProductsListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProductsListCubit, ProductsListState>(
          builder: (context, state) => ListView.builder(
                itemCount: state.products.length,
                itemBuilder: (context, index) =>
                    ProductEntry(product: state.products[index]),
              )),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            context.router.push(ProductRoute());
          }),
    );
  }
}

class ProductEntry extends StatelessWidget {
  final Product product;

  const ProductEntry({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product.name),
      onTap: () {
        context.router.push(ProductRoute(productId: product.id));
      },
    );
  }
}
