module MiniSyntax
  module Highlighter
    module LivingStyleGuide
      def self.highlight(code)
        content_syntax = :html
        result = ''
        until code == '' do
          result << if /\A(?<filter_ws>\n*)^@(?<filter>[a-z\-]+)(?<arguments_whitespace> *(?<arguments>[^\{\n]*)?)((?<lead>: +)(?<data>.+?)$|(?<lead>\n)(?<data>(  .+?\n)+)|(?<lead> *)(?<data>\{(.+?)\n\}))?/m =~ code
            content_syntax = filter.to_s if %w(haml javascript coffee-script).include?(filter)
            data = sub_highlight(data, filter, arguments) if data
            %Q(#{filter_ws}<b>@<em>#{filter}</em></b>#{arguments_whitespace}#{lead}<q>#{data}</q>)
          elsif /\A(?<comment_ws>\n*)^(?<comment>\/\/.+)$/ =~ code
            %Q(#{comment_ws}<i>#{comment}</i>)
          elsif /\A(?<content_ws>\n*)(?<content>.+\Z)/m =~ code
            %Q(#{content_ws}<q>#{MiniSyntax.highlight(content, content_syntax)}</q>) if content.length
          end
          code = $' || ''
        end
        result
      end

      private
      def self.sub_highlight(data, filter, arguments)
        if filter == 'css' and arguments != 'sass'
          MiniSyntax.highlight(data, :css)
        elsif filter == 'header' or filter == 'footer'
          lang = arguments == 'haml' ? :haml : :html
          MiniSyntax.highlight(data, lang)
        elsif filter == 'javascript-before' or filter == 'javascript-after'
          MiniSyntax.highlight(data, :javascript)
        elsif filter == 'data'
          lang = arguments == 'yaml' ? :yaml : :javascript
          MiniSyntax.highlight(data, lang)
        else
          data
        end
      end
    end
  end
end

MiniSyntax.register :lsg, MiniSyntax::Highlighter::LivingStyleGuide
MiniSyntax.register :livingstyleguide, MiniSyntax::Highlighter::LivingStyleGuide

