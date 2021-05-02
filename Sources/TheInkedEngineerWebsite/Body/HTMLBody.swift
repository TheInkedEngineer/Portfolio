import Plot
import Publish

/// A namespace to organize the code of the single website page.
enum HTMLBody {}

extension HTMLBody {
  /// The footer present in the bottom of pages.
  /// - Parameter canGoBack: if `true` a back button will be shown as well.
  static func footer(canGoBack: Bool = false) -> Node<HTML.BodyContext> {
    .content(
      .id(CSS.footer),
      .if(
        canGoBack,
        .a(
          .img(
            // We add the source in the `CSS` file to have it programmatically change based on light/dark mode.
            .id(CSS.backButton),
            .src("/images/back.png")
          ),
          .href("../"),
          .style("border-bottom: 0")
        )
      ),
      .a(
        .img(
          // We add the source in the `CSS` file to have it programmatically change based on light/dark mode.
          .id(CSS.homeButton)
        ),
        .href("/"),
        .style("border-bottom: 0")
      ),
      .p(
        .externalLink(
          .text("@inkedengineer"),
          .classes(CSS.underline, CSS.underlineThin, CSS.underlineTwitterBlue, CSS.socialLink),
          .href("https://twitter.com/inkedengineer")
        )
      )
    )
  }
}
