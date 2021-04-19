import Plot
import Publish

extension HTMLBody {
  static func code(for section: Section<TheInkedEngineerWebsite>) -> Node<HTML.DocumentContext> {
    .body(
      .wrapper(
        .content(
          .titleXL(.text(section.title)),
          .ul(
            .forEach(section.items) { item in
              .li(
                .a(
                  .text(item.title),
                  .class(CSS.articleLink),
                  .rel(.noopener),
                  .href(item.path)
                ),
                .p(
                  .text("Published: \(item.date.prettyPrinted)"),
                  .class(CSS.articlePublishingDate)
                )
              )
            }
          )
        ),
        HTMLBody.footer()
      )
    )
  }
}
