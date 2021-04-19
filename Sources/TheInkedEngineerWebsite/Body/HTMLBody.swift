import Plot
import Publish

/// A namespace to organize the code of the single website page.
enum HTMLBody {}

extension HTMLBody {
  /// The footer present in the bottom of pages.
  static func footer() -> Node<HTML.BodyContext> {
    .content(
      .id(CSS.footer),
      .a(
        .img(
          // We add the source in the `CSS` file to have it programmatically change based on light/dark mode.
          .id(CSS.homeButton)
        ),
        .href("/"),
        .style("border-bottom: 0")
      )
    )
  }
}
