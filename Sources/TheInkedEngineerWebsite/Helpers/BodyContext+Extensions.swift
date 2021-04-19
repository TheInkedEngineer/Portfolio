import Plot

extension Node where Context: HTML.BodyContext {
  /// Returns a node of type `.p` containing all the passed nodes, and add the attribute `class = "CSS.bodyM"` to it.
  static func bodyM(_ nodes: Node<HTML.BodyContext>...) -> Self {
    .p(
      .class(CSS.bodyM),
      .group(nodes)
    )
  }

  /// Returns a node of type `.p` containing all the passed nodes, and add the attribute `class = "CSS.bodyS"` to it.
  static func bodyS(_ nodes: Node<HTML.BodyContext>...) -> Self {
    .p(
      .class(CSS.bodyS),
      .group(nodes)
    )
  }

  /// Returns a node of type `.h1` containing all the passed nodes, and add the attribute `class = "CSS.titleXL"` to it.
  static func titleXL(_ nodes: Node<HTML.BodyContext>...) -> Self {
    .h1(
      .class(CSS.titleXL),
      .group(nodes)
    )
  }

  /// Returns a node of type `.h3` containing all the passed nodes, and add the attribute `class = "CSS.titleM"` to it.
  static func titleM(_ nodes: Node<HTML.BodyContext>...) -> Self {
    .h3(
      .class(CSS.titleM),
      .group(nodes)
    )
  }

  /// Add an `<a>` HTML element within the current context.
  /// Add `target="_blank"` and `rel="noopener` by default.
  /// - parameter nodes: The element's attributes and child elements.
  static func externalLink(_ nodes: Node<HTML.AnchorContext>...) -> Self {
    var nodes = nodes
    nodes.append(.target(.blank))
    nodes.append(.rel(.noopener))
    return .element(named: "a", nodes: nodes)
  }

  /// Returns a node of type `.div` containing all the passed nodes, and add the attribute `class = "CSS.wrapper"` to it.
  static func wrapper(_ nodes: Node<HTML.BodyContext>...) -> Self {
    .div(
      .class(CSS.wrapper),
      .group(nodes)
    )
  }

  /// Returns a node of type `.div` containing all the passed nodes, and add the attribute `class = "CSS.content"` to it.
  static func content(_ nodes: Node<HTML.BodyContext>...) -> Self {
    .div(
      .class(CSS.content),
      .group(nodes)
    )
  }
}
