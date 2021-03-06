# Content processors

A content processor is a concept to refer to a set of two classes: a content parser class and a content renderer class.

The content parser class is used to process the text before it is saved to the database, and the associated renderer class is used to render the saved content.

## How do I add a content processor?

Register the content processor in an `initializer`:

```ruby
Decidim.content_processors += [:special_words]
```

This symbol will be used to instantiate parsers and processors using the following convention:

- "Decidim::ContentParsers::#{type.to_s.camelize}Parser"
- "Decidim::ContentRenderers::#{type.to_s.camelize}Renderer"

Autoload parser and renderer if in the lib/ dir. For example if in proposals module edit `lib/decidim/proposals.rb`:

```rb
module Decidim
  ...
  module ContentParsers
    autoload :ProposalParser, "decidim/content_parsers/proposal_parser"
  end
  module ContentRenderers
    autoload :ProposalRenderer, "decidim/content_renderers/proposal_renderer"
  end
  ...
end
```

Declare the parser class:

```rb
class Decidim::ContentParsers::SpecialWordsParser < BaseParser
  Metadata = Struct.new(:count)

  def rewrite
    content.gsub('foo', '~~foo~~')
  end

  def metadata
    Metadata.new(content.scan('foo').size)
  end
end
```

And the renderer class:

```rb
class Decidim::ContentRenderers::SpecialWordsRenderer < BaseRenderer
  def render
    content.gsub(/\~\~(.*?)\~\~/, '<del>\1</del>')
  end
end
```

## How to use the content parser class

```rb
parser = Decidim::ContentParsers::SpecialWordsParser.new(content, {})
parser.rewrite # returns the content rewritten
parser.metadata # returns a Metadata object
```

## How to use the content renderer class

```rb
renderer = Decidim::ContentRenderers::SpecialWordsRenderer.new(content)
parser.render # returns the content formatted
```

## Additional documentation

You can check the docs in the base classes and the user processor.
