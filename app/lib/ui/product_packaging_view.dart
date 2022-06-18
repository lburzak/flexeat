import 'package:flexeat/model/product_packaging.dart';
import 'package:flutter/material.dart';

class ProductPackagingView extends StatelessWidget {
  final ProductPackaging productPackaging;

  const ProductPackagingView({Key? key, required this.productPackaging})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text(productPackaging.product.name),
            const Spacer(),
            Icon(
              Icons.inventory,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: 16,
            ),
            const SizedBox(
              width: 8,
            ),
            Text(productPackaging.packaging.label),
            const SizedBox(
              width: 8,
            ),
            Text("${productPackaging.packaging.weight} g")
          ],
        ),
      ),
    );
  }
}
