import 'package:flutter/material.dart';

class PageSection extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget body;

  const PageSection(
      {Key? key, required this.icon, required this.label, required this.body})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(icon,
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(label)
                ],
              ),
            ],
          ),
        ),
        body,
      ],
    );
  }
}
