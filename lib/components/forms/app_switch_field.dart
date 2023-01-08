import 'package:flutter/material.dart';

class AppSwitchField extends StatefulWidget {
  final String label;
  final void Function(bool value)? onChanged;
  final bool defaultValue;
  const AppSwitchField(
      {required this.label,
      this.defaultValue = false,
      super.key,
      this.onChanged});

  @override
  State<StatefulWidget> createState() => _AppSwitchFieldState();
}

class _AppSwitchFieldState extends State<AppSwitchField> {
  bool _value = false;

  _buildSwitch() {
    return Row(
      children: [
        Switch(
          value: _value,
          onChanged: (value) {
            setState(() {
              _value = value;
            });
            if (widget.onChanged is Function(bool value)) {
              widget.onChanged!(value);
            }
          },
        ),
        Expanded(child: Text(widget.label)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(48),
      ),
      child: _buildSwitch(),
    );
  }
}
