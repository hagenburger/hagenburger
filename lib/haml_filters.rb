module Haml
  module Filters
    module Markdown
      include Base
      lazy_require 'rdiscount'

      def render(text)
        text = text.force_encoding('UTF-8') # buggy
        html = ::RDiscount.new(text).to_html
        
        # remove uglyness and create beautiful HTML5
        html.gsub! /\n\n/, "\n"
        html.gsub! /<h2 id='_?(.+?)_?'>(.+?)<\/h2>/ do
          text = $2
          "<h2 id=\"#{ $1.gsub('_', '-') }\">#{ text }</h2>"
        end
        html.gsub! /<d[dt]>/, '  \\0'
        html.gsub! /<li>/, '  \\0'
        html.gsub! " style='text-align: left;'", ''
        html.gsub! /<(\w+)( (\w+)='(.+?)')>/ do
          "<#{ $1 }#{ $2.gsub('\'', '"') }>"
        end
        html.gsub! /<img(.+?) ?\/>/, '<img\\1>'
        
        html.force_encoding('ASCII-8BIT') # buggy
      end
    end
  end
end
