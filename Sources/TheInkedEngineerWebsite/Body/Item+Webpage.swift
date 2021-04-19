import Plot
import Publish

extension HTMLBody {
  static func code(for item: Item<TheInkedEngineerWebsite>) -> Node<HTML.DocumentContext> {
    .body(
      .wrapper(
        .content(
          .contentBody(item.body)
        ),
        HTMLBody.footer()
      )
    )
  }
}
