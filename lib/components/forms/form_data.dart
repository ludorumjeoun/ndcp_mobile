class FormData<T> {
  final String label;
  final String id;
  final void Function(T? value)? onChanged;
  T? _value;

  FormData({required this.label, required this.id, this.onChanged, T? value});

  T? get value => _value;
  set value(T? value) {
    _value = value;
    if (onChanged is Function(T? value)) {
      onChanged!(value);
    }
  }
}
