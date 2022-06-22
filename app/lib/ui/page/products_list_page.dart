import 'package:auto_route/auto_route.dart';
import 'package:flexeat/bloc/navigation_cubit.dart';
import 'package:flexeat/bloc/products_list_cubit.dart';
import 'package:flexeat/domain/model/product.dart';
import 'package:flexeat/bloc/state/products_list_state.dart';
import 'package:flexeat/ui/router/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsListPage extends StatelessWidget {
  const ProductsListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<NavigationCubit, NavigationState>(
      listener: (context, state) {
        if (state is ToProductNavigationState) {
          context.router.push(ProductRoute(productId: state.productId));
        }
      },
      child: Scaffold(
        body: BlocBuilder<ProductsListCubit, ProductsListState>(
            builder: (context, state) => ListView.builder(
                  itemCount: state.products.length,
                  itemBuilder: (context, index) =>
                      ProductEntry(product: state.products[index]),
                )),
        floatingActionButton: GestureDetector(
          onLongPress: () => _scanAsync(context),
          child: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                context.read<ProductsListCubit>().createProduct();
              }),
        ),
      ),
    );
  }

  void _scanAsync(BuildContext context) async {
    final code = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", false, ScanMode.BARCODE);
    context.read<ProductsListCubit>().createProductFromEan(code);
  }
}

class ProductEntry extends StatelessWidget {
  final Product product;

  const ProductEntry({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Hero(
          tag: 'hero-productName-${product.id}', child: Text(product.name)),
      onTap: () {
        context.router.push(
            ProductRoute(productId: product.id, initialName: product.name));
      },
    );
  }
}
