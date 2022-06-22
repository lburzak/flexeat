import 'package:flexeat/domain/model/product_packaging.dart';
import 'package:flutter/material.dart';

class ProductPackagingView extends StatelessWidget {
  final ProductPackaging productPackaging;

  const ProductPackagingView({Key? key, required this.productPackaging})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(productPackaging.product.name),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
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
          ],
        ),
      ),
    );
  }
}
