import 'package:flutter/material.dart';

class NormalContainer extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;

  const NormalContainer({required this.child, super.key, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: backgroundColor ?? Theme.of(context).cardTheme.color,
        ),
        child: Padding(padding: const EdgeInsets.all(20), child: child));
  }
}
