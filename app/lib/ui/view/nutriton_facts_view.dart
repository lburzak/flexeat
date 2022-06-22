import 'package:flexeat/domain/model/nutrition_facts.dart';
import 'package:flutter/material.dart';

class NutritionFactsView extends StatelessWidget {
  final void Function()? onEdit;
  final NutritionFacts nutritionFacts;
  final Color? color;

  const NutritionFactsView(
      {Key? key, required this.nutritionFacts, this.onEdit, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onEdit,
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyText1!.copyWith(color: color),
        child: Table(
          children: [
            TableRow(children: [
              NutritionFactCell(
                  icon: Icon(Icons.bolt, color: color),
                  value: nutritionFacts.energy,
                  unit: "kcal"),
              NutritionFactCell(
                  icon: Icon(Icons.water_drop, color: color),
                  value: nutritionFacts.fat),
              NutritionFactCell(
                  icon: Icon(Icons.bakery_dining, color: color),
                  value: nutritionFacts.carbohydrates),
            ]),
            TableRow(children: [
              NutritionFactCell(
                  icon: Icon(Icons.hive, color: color),
                  value: nutritionFacts.fibre),
              NutritionFactCell(
                  icon: Icon(Icons.whatshot, color: color),
                  value: nutritionFacts.protein),
              NutritionFactCell(
                  icon: Icon(Icons.fitbit, color: color),
                  value: nutritionFacts.salt),
            ]),
          ],
        ),
      ),
    );
  }
}

class NutritionFactCell extends StatelessWidget {
  final Icon icon;
  final double? value;
  final String unit;

  const NutritionFactCell(
      {Key? key, required this.icon, this.value, this.unit = "g"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TableCell(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 12),
          Text(
            "${doubleToStringOrQuestionMark(value)} $unit",
            textAlign: TextAlign.right,
          )
        ],
      ),
    ));
  }

  String doubleToStringOrQuestionMark(double? value) {
    if (value == null) {
      return '?';
    } else {
      final intValue = value.toInt();
      if (intValue == value) {
        return intValue.toString();
      } else {
        return value.toStringAsPrecision(3);
      }
    }
  }
}
