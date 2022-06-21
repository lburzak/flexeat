import 'package:collection/collection.dart';
import 'package:flexeat/model/article.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class ArticleAutocompleteValue {
  final String input;
  final Article? matchedArticle;

  const ArticleAutocompleteValue({
    this.input = "",
    this.matchedArticle,
  });
}

class ArticleAutocompleteField extends StatefulWidget {
  final List<Article> articles;
  final void Function(ArticleAutocompleteValue value)? onChanged;

  const ArticleAutocompleteField(
      {Key? key, required this.articles, this.onChanged})
      : super(key: key);

  @override
  State<ArticleAutocompleteField> createState() =>
      _ArticleAutocompleteFieldState();
}

class _ArticleAutocompleteFieldState extends State<ArticleAutocompleteField> {
  Article? matchedArticle;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TypeAheadFormField<Article>(
      suggestionsCallback: _buildSuggestions,
      onSuggestionSelected: _onSelected,
      itemBuilder: (context, article) => ListTile(title: Text(article.name)),
      textFieldConfiguration: TextFieldConfiguration(
          controller: _controller,
          onChanged: _onChanged,
          decoration: InputDecoration(
              labelText: "Article",
              border: const OutlineInputBorder(),
              prefixIcon: matchedArticle == null
                  ? const SizedBox.shrink()
                  : const Icon(Icons.done, color: Colors.green))),
      direction: AxisDirection.up,
      minCharsForSuggestions: 2,
      noItemsFoundBuilder: (_) => const SizedBox.shrink(),
    );
  }

  void _onChanged(String text) {
    setState(() {
      matchedArticle = widget.articles.firstWhereOrNull((i) => i.name == text);

      widget.onChanged?.call(ArticleAutocompleteValue(
          input: text, matchedArticle: matchedArticle));
    });
  }

  List<Article> _buildSuggestions(String value) => widget.articles
      .where(
          (element) => element.name.toLowerCase().contains(value.toLowerCase()))
      .toList();

  void _onSelected(Article article) {
    _controller.text = article.name;

    setState(() {
      matchedArticle = article;
    });

    widget.onChanged?.call(
        ArticleAutocompleteValue(input: article.name, matchedArticle: article));
  }
}
