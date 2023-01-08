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
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.center,
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
        Text(widget.label),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildSwitch();
  }
}
