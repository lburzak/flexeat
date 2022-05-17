import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  final void Function()? onPressed;
  final IconData icon;
  final double size;

  const CircleButton(
      {Key? key, this.onPressed, this.size = 48, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Ink(
      decoration: ShapeDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: const CircleBorder()),
      child: SizedBox.square(
        dimension: size,
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            size: size * 0.5,
          ),
        ),
      ));
}
