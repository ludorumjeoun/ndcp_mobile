import 'package:flutter/material.dart';

class NormalContainer extends StatelessWidget {
  final Widget child;

  const NormalContainer({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).cardTheme.color,
        ),
        child: Padding(padding: const EdgeInsets.all(20), child: child));
  }
}
