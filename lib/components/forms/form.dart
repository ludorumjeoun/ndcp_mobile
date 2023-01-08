import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ndcp_mobile/components/forms/app_switch_field.dart';
import 'package:ndcp_mobile/components/forms/form_data.dart';
import 'package:ndcp_mobile/components/forms/app_text_field.dart';

class FormDataDecoration {
  final Widget? prefix;

  FormDataDecoration({this.prefix});
}

class DecoratedFormData<T> extends FormData<T> {
  final FormDataDecoration? decoration;
  DecoratedFormData(
      {required String label,
      required String id,
      void Function(T? value)? onChanged,
      this.decoration,
      T? value})
      : super(label: label, id: id, onChanged: onChanged, value: value);
}

class TextFormData extends DecoratedFormData<String> {
  TextFormData(
      {required String label,
      required String id,
      void Function(String? value)? onChanged,
      FormDataDecoration? decoration})
      : super(
            label: label, id: id, onChanged: onChanged, decoration: decoration);
}

class PasswordFormData extends DecoratedFormData<String> {
  PasswordFormData(
      {required String label,
      required String id,
      void Function(String? value)? onChanged,
      FormDataDecoration? decoration})
      : super(
            label: label, id: id, onChanged: onChanged, decoration: decoration);
}

class SwitchFormData extends FormData<bool> {
  SwitchFormData(
      {required String label,
      required String id,
      void Function(bool? value)? onChanged,
      bool? value})
      : super(label: label, id: id, onChanged: onChanged, value: value);
}

class SubmitFormData extends FormData<void> {
  static const String submitId = 'submit';
  final bool enabled;
  SubmitFormData({required label, this.enabled = true})
      : super(label: label, id: submitId);
}

class WidgetFormData extends FormData<void> {
  static const String widgetId = 'widget';
  final Widget widget;
  WidgetFormData(this.widget, {required label})
      : super(label: label, id: widgetId);
}

class SubFormData extends FormData<void> {
  static const String subId = 'sub';
  final FormDataSet parent;
  SubFormData(this.parent, {required label}) : super(label: label, id: subId);
}

abstract class FormField<T, F extends FormData<T>> extends ConsumerWidget {
  final AppFormState form;
  final F data;
  const FormField(this.form, this.data, {super.key});
  onChanged(T? value) => data.value = value;

  bool get isFirst => form.isFirstInputField(data);
  bool get isLast => form.isLastInputField(data);
}

class FormDataSet {
  final List<FormData> _fields = [];
  final Future<void> Function(Map<String, dynamic> fields) onSubmit;
  final Future<void> Function(
          Object error, List<MapEntry<String, String>> errorFields)?
      onValidateError;
  FormDataSet(this.onSubmit, {this.onValidateError});

  FormDataSet addField(FormData field) {
    _fields.add(field);
    return this;
  }

  FormDataSet addText(
      {required String label,
      required String id,
      FormDataDecoration? decoration,
      void Function(String? value)? onChanged}) {
    _fields.add(TextFormData(
        label: label, id: id, decoration: decoration, onChanged: onChanged));
    return this;
  }

  FormDataSet addPassword(
      {required String label,
      required String id,
      FormDataDecoration? decoration,
      void Function(String? value)? onChanged}) {
    _fields.add(PasswordFormData(
        label: label, id: id, decoration: decoration, onChanged: onChanged));
    return this;
  }

  FormDataSet addSubmit({required String label, bool enabled = true}) {
    _fields.add(SubmitFormData(label: label, enabled: enabled));
    return this;
  }

  _onSubmit() async {
    final Map<String, dynamic> fields = {};
    for (var field in _fields) {
      if (field.id != SubmitFormData.submitId) {
        fields[field.id] = field.value;
      }
    }
    try {
      await onSubmit(fields);
    } on List<MapEntry<String, String>> catch (e) {
      onValidateError?.call(e, e);
    } catch (e) {
      onValidateError?.call(e, []);
    }
  }

  FormDataSet addWidget(Widget widget, {required String label}) {
    _fields.add(WidgetFormData(widget, label: label));
    return this;
  }
}

class TextFormField extends FormField<String, TextFormData> {
  const TextFormField(super.form, super.data, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppTextField(
      autofocus: isFirst,
      textInputAction: isLast ? TextInputAction.done : TextInputAction.next,
      onChanged: onChanged,
      prefix: data.decoration?.prefix,
      label: data.label,
      enabled: !form.isProgress,
      onSubmitted: (value) {
        if (isLast) {
          form._submit();
        }
      },
    );
  }
}

class PasswordFormField extends FormField<String, PasswordFormData> {
  const PasswordFormField(super.form, super.data, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppTextField(
      autofocus: isFirst,
      obscureText: true,
      textInputAction: isLast ? TextInputAction.done : TextInputAction.next,
      onChanged: onChanged,
      prefix: data.decoration?.prefix,
      label: data.label,
      enabled: !form.isProgress,
      onSubmitted: (value) {
        if (isLast) {
          form._submit();
        }
      },
    );
  }
}

class SwitchFormField extends FormField<bool, SwitchFormData> {
  const SwitchFormField(super.form, super.data, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppSwitchField(
      label: data.label,
      defaultValue: data.value ?? false,
      onChanged: onChanged,
    );
  }
}

class SubmitFormField extends FormField<void, SubmitFormData> {
  const SubmitFormField(super.form, super.data, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: form.isProgress
          ? null
          : data.enabled
              ? form._submit
              : null,
      style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
      child: form.isProgress
          ? const CircularProgressIndicator.adaptive()
          : Text(data.label),
    );
  }
}

class AppForm extends ConsumerStatefulWidget {
  const AppForm({Key? key, required this.dataset}) : super(key: key);

  final FormDataSet dataset;

  @override
  createState() => AppFormState();
}

class AppFormState extends ConsumerState<AppForm> {
  bool isProgress = false;

  _submit() async {
    setState(() {
      isProgress = true;
    });
    await widget.dataset._onSubmit();
    if (mounted) {
      setState(() {
        isProgress = false;
      });
    } else {
      isProgress = false;
    }
  }

  bool isFirstInputField(FormData data) =>
      widget.dataset._fields
          .where((element) => element.id != SubmitFormData.submitId)
          .first ==
      data;
  bool isLastInputField(FormData data) =>
      widget.dataset._fields
          .where((element) => element.id != SubmitFormData.submitId)
          .last ==
      data;

  List<Widget> _children() {
    return widget.dataset._fields.map((data) {
      if (data is TextFormData) {
        return TextFormField(this, data);
      } else if (data is PasswordFormData) {
        return PasswordFormField(this, data);
      } else if (data is SubmitFormData) {
        return SubmitFormField(this, data);
      } else if (data is WidgetFormData) {
        return data.widget;
      } else if (data is SwitchFormData) {
        return SwitchFormField(this, data);
      }
      throw Exception('Unknown form field type');
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: _children(),
    );
  }
}
