import 'package:flexeat/model/product_packaging.dart';
import 'package:flutter/material.dart';

class ProductPackagingView extends StatelessWidget {
  final ProductPackaging productPackaging;

  const ProductPackagingView({Key? key, required this.productPackaging})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text(productPackaging.product.name),
            Text("${productPackaging.packaging.weight} g")
          ],
        ),
      ),
    );
  }
}
