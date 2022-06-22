import 'package:flexeat/domain/model/article.dart';
import 'package:flexeat/ui/widget/article_autocomplete_field.dart';
import 'package:flutter/material.dart';

class LinkArticleView extends StatefulWidget {
  final List<Article> articles;
  final void Function(Article article)? onSubmitArticle;
  final void Function(String text)? onSubmitText;

  const LinkArticleView(
      {Key? key,
      required this.articles,
      this.onSubmitArticle,
      this.onSubmitText})
      : super(key: key);

  @override
  State<LinkArticleView> createState() => _LinkArticleViewState();
}

class _LinkArticleViewState extends State<LinkArticleView> {
  ArticleAutocompleteValue value = const ArticleAutocompleteValue(input: "");

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets + const EdgeInsets.all(16),
      duration: const Duration(milliseconds: 100),
      curve: Curves.decelerate,
      child: Row(
        children: [
          Expanded(
            child: ArticleAutocompleteField(
                articles: widget.articles,
                onChanged: (value) {
                  setState(() {
                    this.value = value;
                  });
                }),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 60,
            child: AspectRatio(
                aspectRatio: 1,
                child: ElevatedButton(
                    onPressed: _onSubmit, child: const Icon(Icons.link))),
          )
        ],
      ),
    );
  }

  void _onSubmit() {
    if (value.matchedArticle != null) {
      widget.onSubmitArticle?.call(value.matchedArticle!);
    } else {
      widget.onSubmitText?.call(value.input);
    }
  }
}
