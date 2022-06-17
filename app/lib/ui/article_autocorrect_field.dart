import 'package:collection/collection.dart';
import 'package:flexeat/model/article.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class ArticleAutocorrectValue {
  final String input;
  final Article? matchedArticle;

  const ArticleAutocorrectValue({
    required this.input,
    this.matchedArticle,
  });
}

class ArticleAutocorrectField extends StatefulWidget {
  final List<Article> articles;
  final void Function(ArticleAutocorrectValue value)? onChanged;

  const ArticleAutocorrectField(
      {Key? key, required this.articles, this.onChanged})
      : super(key: key);

  @override
  State<ArticleAutocorrectField> createState() =>
      _ArticleAutocorrectFieldState();
}

class _ArticleAutocorrectFieldState extends State<ArticleAutocorrectField> {
  ArticleAutocorrectValue value = const ArticleAutocorrectValue(input: "");

  @override
  Widget build(BuildContext context) {
    return TypeAheadFormField<Article>(
      initialValue: value.input,
      suggestionsCallback: _buildSuggestions,
      onSuggestionSelected: _onSelected,
      itemBuilder: (context, article) => ListTile(title: Text(article.name)),
      textFieldConfiguration: TextFieldConfiguration(
          onChanged: _onChanged,
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              prefixIcon: value.matchedArticle == null
                  ? const SizedBox.shrink()
                  : const Icon(Icons.done, color: Colors.green))),
      direction: AxisDirection.up,
      minCharsForSuggestions: 2,
      noItemsFoundBuilder: (_) => const SizedBox.shrink(),
    );
  }

  void _onChanged(String text) {
    setState(() {
      value = ArticleAutocorrectValue(
          input: text,
          matchedArticle:
              widget.articles.firstWhereOrNull((i) => i.name == text));

      widget.onChanged?.call(value);
    });
  }

  List<Article> _buildSuggestions(String value) => widget.articles
      .where(
          (element) => element.name.toLowerCase().contains(value.toLowerCase()))
      .toList();

  void _onSelected(Article article) {
    setState(() {
      value =
          ArticleAutocorrectValue(input: article.name, matchedArticle: article);
    });
  }
}
