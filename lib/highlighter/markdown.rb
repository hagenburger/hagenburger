module MiniSyntax
  module Highlighter
    module Markdown
      def self.highlight(code)
        # See https://github.com/vmg/redcarpet/issues/208#issuecomment-52182751:
        code.gsub! /^\\```/, '```'

        code.gsub! %r(((^\#.+?$)|^(``` *)([a-z0-9\-_]+)?(\n(.|\n)+?)(```)$)) do
          if data = $2
            %Q(<b>#{data}</b>)
          elsif data = $5
            syntax = $4 || :lsg
            data = MiniSyntax.highlight(data, syntax.to_sym)
            %Q(<q>#{$3}#{$4}#{data}#{$7}</q>)
          elsif data = $11
            %Q(<span style="color: red">#{data}</span>)
          end
        end

        code
      end
    end
  end
end

MiniSyntax.register :md, MiniSyntax::Highlighter::Markdown
MiniSyntax.register :markdown, MiniSyntax::Highlighter::Markdown

