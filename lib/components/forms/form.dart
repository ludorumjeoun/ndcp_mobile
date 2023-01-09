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
  final void Function(FormDataSet fields) addFields;
  final Widget Function(BuildContext context, List<Widget> children) build;
  final FormDataSet _subfields = FormDataSet((fields) async {});
  SubFormData(this.build, this.addFields, {required label})
      : super(label: label, id: subId) {
    addFields(_subfields);
  }
}

abstract class FormField<T, F extends FormData<T>> extends ConsumerWidget {
  final AppFormState form;
  final F data;
  const FormField(this.form, this.data, {super.key});
  onChanged(T? value) => data.value = value;

  bool get isFirst => form.isFirstInputField(data);
  bool get isLast => form.isLastInputField(data);
}

class SubFormField extends FormField<void, SubFormData> {
  const SubFormField(super.form, super.data, {super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return data.build(context, data._subfields.toWidgets(form));
  }
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
          void Function(String? value)? onChanged}) =>
      addField(TextFormData(
          label: label, id: id, decoration: decoration, onChanged: onChanged));

  FormDataSet addPassword(
          {required String label,
          required String id,
          FormDataDecoration? decoration,
          void Function(String? value)? onChanged}) =>
      addField(PasswordFormData(
          label: label, id: id, decoration: decoration, onChanged: onChanged));

  FormDataSet addSubmit({required String label, bool enabled = true}) =>
      addField(SubmitFormData(label: label, enabled: enabled));

  _onSubmit() async {
    final Map<String, dynamic> fields = {};
    for (var field in _fields) {
      if (field.id != SubmitFormData.submitId) {
        fields[field.id] = field.value;
      } else if (field is SubFormData) {
        for (var subField in field._subfields._fields) {
          fields[subField.id] = subField.value;
        }
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

  toWidgets(AppFormState form) {
    final List<Widget> widgets = [];
    for (var field in _fields) {
      if (field is TextFormData) {
        widgets.add(TextFormField(form, field));
      } else if (field is PasswordFormData) {
        widgets.add(PasswordFormField(form, field));
      } else if (field is SubmitFormData) {
        widgets.add(SubmitFormField(form, field));
      } else if (field is WidgetFormData) {
        widgets.add(field.widget);
      } else if (field is SwitchFormData) {
        widgets.add(SwitchFormField(form, field));
      } else if (field is SubFormData) {
        widgets.add(SubFormField(form, field));
      }
    }
    return widgets;
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
    return widget.dataset.toWidgets(this);
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
