import 'package:flexeat/model/product_packaging.dart';
import 'package:flexeat/repository/packaging_repository.dart';
import 'package:flexeat/ui/product_packaging_view.dart';
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
              itemCount: snapshot.data?.length,
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
