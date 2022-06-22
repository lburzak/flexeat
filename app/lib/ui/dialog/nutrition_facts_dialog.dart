import 'package:flexeat/bloc/nutrition_facts_form_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../main.dart';

class NutritionFactsDialog extends StatelessWidget {
  final int productId;

  const NutritionFactsDialog({Key? key, required this.productId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) =>
          context.read<Factory<NutritionFactsFormModel, int>>()(productId),
      child: Builder(builder: (context) {
        return AlertDialog(
          title: const Text("Nutrition facts"),
          scrollable: true,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  child: Text("Values per 100g"),
                  alignment: Alignment.bottomRight,
                ),
              ),
              ReactiveForm(
                  formGroup: context.read<NutritionFactsFormModel>().form,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      _FormField(
                        formControlName: 'energy',
                        icon: Icons.bolt,
                        unit: "kcal",
                      ),
                      SizedBox(height: 8),
                      _FormField(
                        formControlName: 'fat',
                        icon: Icons.water_drop,
                      ),
                      SizedBox(height: 8),
                      _FormField(
                        formControlName: 'carbohydrates',
                        icon: Icons.bakery_dining,
                      ),
                      SizedBox(height: 8),
                      _FormField(
                        formControlName: 'fibre',
                        icon: Icons.hive,
                      ),
                      SizedBox(height: 8),
                      _FormField(
                        formControlName: 'protein',
                        icon: Icons.whatshot,
                      ),
                      SizedBox(height: 8),
                      _FormField(
                        formControlName: 'salt',
                        icon: Icons.fitbit,
                      ),
                    ],
                  )),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () {
                  context.read<NutritionFactsFormModel>().submit();
                  Navigator.of(context).pop();
                },
                child: const Text("Save"))
          ],
        );
      }),
    );
  }
}

class _FormField extends StatelessWidget {
  final String formControlName;
  final String unit;
  final IconData icon;

  const _FormField(
      {Key? key,
      required this.formControlName,
      this.unit = "g",
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField(
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: _deriveHintText(),
            prefixIcon: Icon(icon),
            suffixText: unit),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        formControlName: formControlName);
  }

  String _deriveHintText() {
    String text = formControlName;
    return text[0].toUpperCase() + text.substring(1);
  }
}
