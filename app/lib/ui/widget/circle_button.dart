import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  final void Function()? onPressed;
  final IconData icon;
  final double size;
  final double iconSize;

  const CircleButton(
      {Key? key,
      this.onPressed,
      this.size = 48,
      double? iconSize,
      required this.icon})
      : iconSize = iconSize ?? size * 0.5,
        super(key: key);

  @override
  Widget build(BuildContext context) => Ink(
      decoration: ShapeDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: const CircleBorder()),
      height: size,
      width: size,
      child: IconButton(
        splashRadius: size / 2,
        iconSize: iconSize,
        onPressed: onPressed,
        icon: Icon(icon, color: Theme.of(context).colorScheme.onPrimary),
      ));
}
