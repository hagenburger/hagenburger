module MiniSyntax
  module Highlighter
    module LivingStyleGuide
      def self.highlight(code)
        code.gsub! %r(@([a-z-]+)( *([^\{\n]+?)?)((( +)(\{(.+?)\n\}))|(: +)(.+?)$|(\n(  .+?(\n|$))+)|$))m do
          result = %Q(<b>@<em>#{$1}</em></b>#{$2})
          filter = $1
          arguments = $3
          if data = $7
            data = sub_highlight(data, filter, arguments)
            result << %Q(#{$6}<q>#{data}</q>)
          elsif data = $10
            data = sub_highlight(data, filter, arguments)
            result << %Q(#{$9}<q>#{data}</q>)
          elsif data = $11
            data = sub_highlight(data, filter, arguments)
            result << %Q(<q>#{data}</q>)
          end
          result
        end
        code.gsub! %r(^//.+) do |comment|
          %Q(<i>#{comment}</i>)
        end
        code
      end

      def self.sub_highlight(data, filter, arguments)
        if filter == 'css' and arguments != 'sass'
          MiniSyntax.highlight(data, :css)
        elsif filter == 'header' or filter == 'footer'
          lang = arguments == 'haml' ? :haml : :html
          MiniSyntax.highlight(data, lang)
        elsif filter == 'javascript-before' or filter == 'javascript-after'
          MiniSyntax.highlight(data, :javascript)
        else
          data
        end
      end
    end
  end
end

MiniSyntax.register :lsg, MiniSyntax::Highlighter::LivingStyleGuide
MiniSyntax.register :livingstyleguide, MiniSyntax::Highlighter::LivingStyleGuide

