import 'package:auto_route/auto_route.dart';
import 'package:flexeat/bloc/navigation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PageSection extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget body;

  const PageSection(
      {Key? key, required this.icon, required this.label, required this.body})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<NavigationCubit, NavigationState>(
      listener: (context, state) {
        if (state is BackNavigationState) {
          context.router.pop();
        }
      },
      child: Column(
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
      ),
    );
  }
}
