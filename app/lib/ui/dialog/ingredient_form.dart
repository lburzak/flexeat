import 'package:flexeat/domain/model/article.dart';
import 'package:flexeat/domain/repository/article_repository.dart';
import 'package:flexeat/ui/view/article_autocomplete_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IngredientForm extends StatefulWidget {
  final void Function(ArticleAutocompleteValue value, int weight)? onSubmit;

  const IngredientForm({Key? key, this.onSubmit}) : super(key: key);

  @override
  State<IngredientForm> createState() => _IngredientFormState();
}

class _IngredientFormState extends State<IngredientForm> {
  ArticleAutocompleteValue articleValue = const ArticleAutocompleteValue();
  String _weight = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add ingredient"),
      scrollable: true,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StreamBuilder<List<Article>>(
              stream: context.read<ArticleRepository>().watchAll(),
              builder: (context, snapshot) {
                return ArticleAutocompleteField(
                  articles: snapshot.hasData ? snapshot.requireData : const [],
                  onChanged: (value) {
                    setState(() {
                      articleValue = value;
                    });
                  },
                );
              }),
          const SizedBox(
            height: 12,
          ),
          TextFormField(
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Net weight",
                suffixText: "grams",
                prefixIcon: Icon(Icons.scale)),
            keyboardType: TextInputType.number,
            onChanged: _changeWeight,
          )
        ],
      ),
      actions: [TextButton(onPressed: _submit, child: const Text("Add"))],
    );
  }

  void _changeWeight(String text) {
    setState(() {
      _weight = text;
    });
  }

  void _submit() {
    int weight = int.tryParse(_weight) ?? 0;

    widget.onSubmit?.call(articleValue, weight);

    Navigator.of(context).pop();
  }
}
