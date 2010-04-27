module Haml
  module Filters
    module Markdown
      include Base
      lazy_require 'maruku'

      def render(text)
        html = ::Maruku.new(text).to_html
        
        # remove uglyness and create beautiful HTML5
        html.gsub! /\n\n/, "\n"
        html.gsub! /<h2 id='_?(.+?)_?'>(.+?)<\/h2>/ do
          text = $2
          "<h2 id=\"#{ $1.gsub('_', '-') }\">#{ text }</h2>"
        end
        html.gsub! /<d[dt]>/, '  \\0'
        html.gsub! " style='text-align: left;'", ''
        html.gsub! /<(\w+)( (\w+)='(.+?)')>/ do
          "<#{ $1 }#{ $2.gsub('\'', '"') }>"
        end
        html.gsub! /<img(.+?) ?\/>/, '<img\\1>'
        
        html
      end
    end
  end
end
