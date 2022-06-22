import 'package:flexeat/domain/model/packaging.dart';
import 'package:flutter/material.dart';

import 'circle_button.dart';

class PackagingSelector extends StatefulWidget {
  final List<Packaging> packagings;
  final bool selectable;
  final void Function()? onAdd;

  const PackagingSelector(
      {Key? key, required this.packagings, this.selectable = true, this.onAdd})
      : super(key: key);

  @override
  State<PackagingSelector> createState() => _PackagingSelectorState();
}

class _PackagingSelectorState extends State<PackagingSelector> {
  int selectedId = 0;

  @override
  void initState() {
    selectedId = widget.packagings.isNotEmpty ? widget.packagings.first.id : 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Wrap(
        spacing: 6.0,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: widget.packagings
            .map((packaging) => PackagingChip(
                  packaging,
                  selected: packaging.id == selectedId,
                  onSelected: widget.selectable
                      ? (selected) {
                          if (selected) {
                            setState(() {
                              selectedId = packaging.id;
                            });
                          }
                        }
                      : null,
                ))
            .cast<Widget>()
            .followedBy([
          CircleButton(
            size: 34,
            icon: Icons.add,
            onPressed: () {
              widget.onAdd?.call();
            },
          )
        ]).toList(growable: false),
      ),
    );
  }
}

class PackagingChip extends StatelessWidget {
  final Packaging packaging;
  final bool selected;
  final void Function(bool selected)? onSelected;

  const PackagingChip(this.packaging,
      {Key? key, this.selected = false, this.onSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
        selected: selected,
        onSelected: onSelected,
        elevation: 2,
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(packaging.label),
            const SizedBox(
              width: 8,
            ),
            Text(
              "${packaging.weight} g",
              style: Theme.of(context)
                  .chipTheme
                  .labelStyle
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }
}
