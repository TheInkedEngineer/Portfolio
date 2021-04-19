import Plot

extension Node where Context: HTMLContext {
  /// Adds the raw values of the passed elements as classes.
  static func `classes`(_ classes: String...) -> Self {
    .class(classes.joined(separator: " "))
  }
}
