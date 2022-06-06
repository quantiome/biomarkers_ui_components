extension ListExtension<T> on List<T> {
  /// Returns the list with the given object inserted between each element.
  List<T> interlacedWith(T object) =>
      isEmpty ? [] : List.generate(length * 2 - 1, (index) => index.isEven ? this[index ~/ 2] : object);
}
