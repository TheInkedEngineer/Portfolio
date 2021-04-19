import Plot
import Publish

extension HTMLBody {
  static func code(for index: Publish.Index, context: PublishingContext<TheInkedEngineerWebsite>) -> Node<HTML.DocumentContext> {
    .body(
      .wrapper(
        .content(
          .a(
            .raw("<strong>Articles</strong>"),
            .class(CSS.underline),
            .style("position: absolute; right: 0; top: 0px;"),
            .rel(.noopener),
            .href("/articles")
          ),
          .p(
            .text("Hey!,"),
            .class(CSS.bodyM),
            .span(
              .class(CSS.titleXL),
              .text(" I am Firas")
            )
          ),
          .p(
            .text("also known as"),
            .class(CSS.bodyM),
            .span(
              .class(CSS.titleXL),
              .text(" The Inked Engineer")
            )
          ),
          .br(),
          .p(
            .text("I am a "),
            .class(CSS.bodyM),
            .raw("<b>Software Engineer</b>. "),
            .text("My go to language is "),
            .raw("<b>Swift</b>."),
            .br(),
            .text("I am currently a Senior iOS Engineer at "),
            .externalLink(
              .text("Wise Emotions"),
              .class(CSS.underlineThin),
              .href("https://wisemotions.com")
            ),
            .text(", and a lead developer of "),
            .externalLink(
              .text("Mocka"),
              .class(CSS.underlineThin),
              .href("https://github.com/wise-emotions/mocka")
            ),
            .text(".")
          ),
          .p(
            .text("I love art. I enjoy minimalism in all its forms. Sometimes, I like to "),
            .class(CSS.bodyM),
            .externalLink(
              .text("design"),
              .classes(CSS.underline, CSS.underlineThin),
              .href("https://www.dribbble.com/theinkedengineer")
            ),
            .text(".")
          ),
          .p(
            .text("Every now and then I like "),
            .a(
              .text("to write"),
              .classes(CSS.underline),
              .rel(.noopener),
              .href("/articles")
            ),
            .raw(" about <b>software</b>"),
            .text(", "),
            .raw("<b>music</b>"),
            .text(", or "),
            .raw("<b>rant</b>.")
          ),
          .br(),
          .br(),
          .br(),
          .externalLink(
            .text("Twitter"),
            .classes(CSS.underline, CSS.underlineThin, CSS.underlineTwitterBlue, CSS.socialLink),
            .href("https://twitter.com/inkedengineer")
          ),
          .externalLink(
            .text("LinkedIn"),
            .classes(CSS.underline, CSS.underlineThin, CSS.underlineLinkedInBlue, CSS.socialLink),
            .href("https://www.linkedin.com/in/theinkedengineer/")
          ),
          .externalLink(
            .text("Github"),
            .classes(CSS.underline, CSS.underlineThin, CSS.socialLink),
            .href("https://github.com/TheInkedEngineer")
          ),
          .br(),
          .br(),
          .externalLink(
            .text("Curriculum"),
            .classes(CSS.underline, CSS.underlineThin, CSS.socialLink),
            .href("/images/Firas Safa - Curriculum.pdf")
          ),
          .externalLink(
            .text("Email"),
            .classes(CSS.underline, CSS.underlineThin, CSS.underlinePurple, CSS.socialLink),
            .href("mailto:firas@hey.com")
          )
        )
      )
    )
  }
}
