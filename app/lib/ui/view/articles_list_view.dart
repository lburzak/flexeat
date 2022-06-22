import 'package:flexeat/domain/model/article.dart';
import 'package:flexeat/ui/widget/circle_button.dart';
import 'package:flutter/material.dart';

class ArticlesListView extends StatelessWidget {
  final List<Article> articles;
  final void Function(int articleId)? onUnlink;
  final void Function()? onAdd;

  const ArticlesListView(
      {Key? key, required this.articles, this.onUnlink, this.onAdd})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Wrap(
        spacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: articles
            .map((article) => Chip(
                  onDeleted: () {
                    onUnlink?.call(article.id);
                  },
                  label: Text(article.name),
                  deleteIcon: const Icon(
                    Icons.close,
                    size: 16,
                  ),
                  deleteIconColor: Colors.white,
                ))
            .cast<Widget>()
            .followedBy([
              CircleButton(
                size: 32,
                icon: Icons.add,
                onPressed: () {
                  onAdd?.call();
                },
              )
            ])
            .toList(growable: false)
            .toList(),
      ),
    );
  }
}
