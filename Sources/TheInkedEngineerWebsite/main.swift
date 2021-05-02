import Foundation
import Publish
import Plot
import SplashPublishPlugin

struct TheInkedEngineerWebsite: Website {
  enum SectionID: String, WebsiteSectionID {
    case articles

    /// The title of the section to display properly formatted.
    var title: String {
      switch self {
      case .articles:
        return "The Inked Engineer's thoughts"
      }
    }
  }

  // Custom Metadata to include in `.md` files.
  struct ItemMetadata: WebsiteItemMetadata {}

  var url = URL(string: "https://theinkedengineer.com")!
  var name = "The Inked Engineer"
  var description = "A personal portfolio and blog"
  var language: Language { .english }
  var imagePath: Path? { "images/social.png" }
}

// This will generate the website using the custom theme:
try TheInkedEngineerWebsite().publish(
  withTheme: .tie,
  indentation: .spaces(2),
  plugins: [.splash(withClassPrefix: "swift-")]
)
