/// Este filtro se usa para filtrar las notas que pertencen a un usuario en un
/// stream.
///
/// Explicación según ChatGPT:
/// This is a Dart extension method for filtering a stream of lists of generic type T.
/// The extension method is called filter and it takes a single parameter, where,
///  which is a boolean function that takes an item of type T and returns a
///  boolean. This function will be used to filter the items in the stream.
///
/// The extension method filter returns a new stream of lists of type T. It
/// calls the map method on the original stream and passes in a lambda function
/// as an argument. The lambda function takes a list of type T as an argument
/// and applies the where function to filter the list based on the boolean
/// condition. The resulting list of filtered items is returned as a new list.
///
/// The toList() method is called on the resulting Iterable object from the
/// where method to convert it back into a list.
///
/// So, in summary, the extension method filter allows you to filter a stream of
/// lists of type T by applying a boolean function to each item in the list and
/// returning a new stream of lists of type T with only the items that match
/// the condition.

extension Filter<T> on Stream<List<T>> {
  Stream<List<T>> filter(bool Function(T) where) =>
      map((items) => items.where(where).toList());
}
