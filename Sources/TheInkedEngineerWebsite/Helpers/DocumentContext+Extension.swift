import Plot

extension Node where Context == HTML.DocumentContext {
  /// Returns the node `.head` containing the default fonts.
  static func defaultFont() -> Node {
    .head(
      .link(.rel(.preconnect), .href("https://fonts.gstatic.com")),
      .link(.rel(.stylesheet), .href("https://fonts.googleapis.com/css2?family=Fira+Sans:wght@400;700&display=swap"))
    )
  }

  /// Returns the node `.head` containing the fonts used with the articles section.
  static func articlesFonts() -> Node {
    .head(
      .link(.rel(.preconnect), .href("https://fonts.gstatic.com")),
      .link(.rel(.stylesheet), .href("https://fonts.googleapis.com/css2?family=Fira+Sans:wght@400;700&display=swap")),
      .link(.rel(.stylesheet), .href("https://fonts.googleapis.com/css2?family=Fira+Code&display=swap"))
    )
  }

  /// Adds `Plausible.js` to a `.head` node.
  /// - Parameter domain: The list of paths to join to form the data-domain value.
  static func plausible(for path: String = "theinkedengineer.com") -> Node {
    .head(
      .script(
        .async(),
        .defer(),
        .attribute(named: "data-domain", value: path),
        .src("https://plausible.io/js/plausible.js")
      )
    )
  }
}
