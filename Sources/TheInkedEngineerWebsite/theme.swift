import Foundation
import Plot
import Publish

extension Theme where Site == TheInkedEngineerWebsite {
  static var tie: Self {
    Theme(
      htmlFactory: TheInkedEngineerFactory(),
      resourcePaths: ["Resources/css/styles.css", "Resources/css/articles.css"]
    )
  }

  private struct TheInkedEngineerFactory: HTMLFactory {
    func makeIndexHTML(for index: Index, context: PublishingContext<TheInkedEngineerWebsite>) throws -> HTML {
      HTML(
        .lang(context.site.language),
        .head(for: index, on: context.site),
        .defaultFont(),
        HTMLBody.code(for: index, context: context)
      )
    }

    func makeSectionHTML(for section: Section<TheInkedEngineerWebsite>, context: PublishingContext<TheInkedEngineerWebsite>) throws -> HTML {
      HTML(
        .lang(context.site.language),
        .head(for: section, on: context.site),
        .defaultFont(),
        HTMLBody.code(for: section)
      )
    }

    func makeItemHTML(for item: Item<TheInkedEngineerWebsite>, context: PublishingContext<TheInkedEngineerWebsite>) throws -> HTML {
      HTML(
        .lang(context.site.language),
        .head(for: item, on: context.site, stylesheetPaths: ["/styles.css", "/articles.css"]),
        .articlesFonts(),
        HTMLBody.code(for: item)
      )
    }

    func makePageHTML(for page: Page, context: PublishingContext<TheInkedEngineerWebsite>) throws -> HTML {
      HTML()
    }

    func makeTagListHTML(for page: TagListPage, context: PublishingContext<TheInkedEngineerWebsite>) throws -> HTML? {
      nil
    }

    func makeTagDetailsHTML(for page: TagDetailsPage, context: PublishingContext<TheInkedEngineerWebsite>) throws -> HTML? {
      nil
    }
  }
}
