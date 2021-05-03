---
date: 2021-05-03 00:00
description: A handy guide with a few tricks to write your own website using Swift. 
---

#  Build your website using Publish

Publish is a static site generator built specifically for Swift developers. 
It enables entire websites to be built using Swift, and supports themes, plugins and tons of other powerful customization options.

It's an open-source framework developed by John Sundell and powers [his website](www.swiftbysundell.com)

Publish relies on `Plot` and `Ink` to make the experience as Swift-y as possible. The former is a domain-specific language (DSL) for writing type-safe HTML, XML and RSS in Swift, whereas the latter is a markdown parser that enabled creating new posts (like this one) by simply adding a markdown file in the correct folder.  

\

## Getting Started

The fastest way to work with publish is by using its command-line tool (CLI). To install the CLI clone the repo, navigate inside of it and run `make`.

```no-highlight
$ git clone https://github.com/JohnSundell/Publish.git
$ cd Publish
$ make
```

Now, just create an empty folder for your website somewhere on your computer, navigate to that empty folder and run `Publish new`.

```no-highlight
$ mkdir MyWebsite
$ cd MyWebsite
$ publish new
```

Finally, run open Package.swift to open up the project in Xcode to start building your new website.

\

## Project Structure

When you open your project for the first time, you will have a structure similar to this:

<p align="center" >
  <img src="/images/articles/build-your-website-using-publish/virgin-structure.png"  height="300px"/>
</p>

When you run your project for the first time, a folder named _Output_ will be created. Inside of that folder you can find the files of the static website.

- The project is built using _Swift Package Manager_ and `Package.swift` contains the basic structure to include `Publish` in the project.
- _Content_ is the folder where the `.md` files go. Each folder name should match a `SectionID` in your website (more on that later).
- _Resources_ is where the images, `CSS` files and things of that nature would go.
- `main.swift` is the main file where the root code of the website exists. There you can customize the skeleton of your website.

`Publish` uses a theme when creating the website. This helps with keeping everything neat and aligned. By default, `Publish` ships with a default theme named `.foundation` this is the theme John uses for [his website](https://www.swiftbysundell.com).

\

## Deeper look at Main.swift

The default structure of `main.swift` is the following.

```
// This type acts as the configuration for your website.
struct MyWebsite: Website {
  enum SectionID: String, WebsiteSectionID {
  // Add the sections that you want your website to contain here:
    case posts
  }

  struct ItemMetadata: WebsiteItemMetadata {
  // Add any site-specific metadata that you want to use here.
  }

  // Update these properties to configure your website:
  var url = URL(string: "https://your-website-url.com")!
  var name = "MyWebsite"
  var description = "A description of MyWebsite"
  var language: Language { .english }
  var imagePath: Path? { nil }
}

// This will generate your website using the built-in Foundation theme:
try MyWebsite().publish(withTheme: .foundation)
```

- Each `SectionID` will generate a section in the website. The raw value of the `SectionID` case corresponds to the path value of that section in the `URL`.

- `ItemMetadata` is a list of custom metadata to include and parse in `.md` files.

- `name` is the title to display when the website `URL` is shared, or in the tab bar or the web browser. Articles will automatically have the title of the article in addition to the name set here.

- `description` is the description displayed when the `URL` is shared.

- `language` will automatically set the `lang = ` in the `html` tag.

- `imagePath` is the image associated with the shared link of the website.

- `try MyWebsite().publish(withTheme: .foundation)` will generate your website using the built-in Foundation theme. the `.publish` function takes in more customization parameters for more flexibility.

\

## Creating a custom theme

Foundation is ok. However, you'd would want your website to have its own feel and look. That's where creating your own theme comes into place. \
A theme requires two parameters to be created: an `htmlFactory` and a `resourcePath`. The latter is self explanatory. It basically requires an array of strings pointing to the relative paths of the resources to include (`CSS` files). \
The `htmlFactory` on the other hand is slightly more complicated. It should be an instance of an object (ideally a `Struct`) that conforms to `HtmlFactory` and implements the needed methods.

- `func makeIndexHTML(index: Index, context: PublishingContext<TheInkedEngineerWebsite>) throws -> HTML` is required and should compose the code to generate the `HTML` code for the home page.

- `func makeSectionHTML(section: Section<TheInkedEngineerWebsite>, context: PublishingContext<TheInkedEngineerWebsite>) throws -> HTML` is required and should compose the code to generate the `HTML` code for each section in the website. A section is created by adding a `case` under `SectionID` in `main.swift`. 

- `func makeItemHTML(item: Item<TheInkedEngineerWebsite>, context: PublishingContext<TheInkedEngineerWebsite>) throws -> HTML` is required and should compose the code to generate the `HTML` code for each item (article) in the website. An item is created by adding a `.md` file inside a folder named as the raw value of a section.

- `func makePageHTML(page: Page, context: PublishingContext<TheInkedEngineerWebsite>) throws -> HTML` is required and should compose the code to generate the `HTML` of any free-form page that does not follow the traditional structure. A page is added by creating a `.md` file inside the _Content_ folder.

Once the `htmlFactory` is created, we generate our theme like so:

```
static var myTheme: Theme {
  Theme(
    htmlFactory: CustomHTMLFactory(),
    resourcePaths: ["Resources/css/styles.css", "Resources/css/articles.css"]
  )
}
```

To use the theme, got to `main.swift` and modify the `.publish` method passing your newly created theme instead of `.foundation`.

\

## Tips and Tricks

- Use [SplashPublishPlugin](https://github.com/johnsundell/splashpublishplugin.git) to provide correct `Swift` syntax parsing in your `.md` code blocks.

- Below is a helper to open links in a new tab:

```
/// Add an `<a>` HTML element within the current context.
/// Add `target="_blank"` and `rel="noopener` by default.
/// - parameter nodes: The element's attributes and child elements.
static func externalLink(_ nodes: Node<HTML.AnchorContext>...) -> Self {
  var nodes = nodes
  nodes.append(.target(.blank))
  nodes.append(.rel(.noopener))
  return .element(named: "a", nodes: nodes)
}
```

- Use an `enum` to list all your `CSS` classes. It will reduce the possibility of a typo. If you do so, the code snippet below will come in handy:

```
extension Node where Context: HTMLContext {
/// Adds the raw values of the passed elements as classes.
  static func `classes`(_ classes: String...) -> Self {
    .class(classes.joined(separator: " "))
  }
}
```
so now, you can add your classes like so: `.classes(CSS.underline, CSS.underlineThin, CSS.socialLink)`
