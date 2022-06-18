import 'package:flexeat/model/product_packaging.dart';
import 'package:flexeat/repository/packaging_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductPackagingSelectionView extends StatelessWidget {
  final int articleId;
  final void Function(ProductPackaging productPackaging)? onSelected;

  const ProductPackagingSelectionView(
      {Key? key, required this.articleId, this.onSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductPackaging>>(
        initialData: const [],
        future: context
            .read<PackagingRepository>()
            .findProductPackagingsByArticleId(articleId),
        builder: (context, snapshot) {
          return ListView.builder(
              itemCount: ps(snapshot.data?.length),
              itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      onSelected?.call(snapshot.requireData[index]);
                      Navigator.of(context).pop();
                    },
                    child: ProductPackagingView(
                        productPackaging: snapshot.requireData[index]),
                  ));
        });
  }
}

T ps<T>(T arg) {
  print("DEBUG $arg");
  return arg;
}

class ProductPackagingView extends StatelessWidget {
  final ProductPackaging productPackaging;

  const ProductPackagingView({Key? key, required this.productPackaging})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "${productPackaging.product.name} ${productPackaging.packaging.weight}",
      style: TextStyle(color: Colors.black),
    );
  }
}
