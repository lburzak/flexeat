import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  final void Function()? onPressed;
  final IconData icon;

  const CircleButton({Key? key, this.onPressed, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Ink(
      decoration: ShapeDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: const CircleBorder()),
      child: SizedBox.square(
        dimension: 48,
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(icon),
        ),
      ));
}