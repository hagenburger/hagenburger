module MiniSyntax
  module Highlighter
    module Json
      def self.highlight(code)
        code.gsub! %r(".*?[^\\]":), '<b>\\0</b>'
        code.gsub! %r((: *)(".*?[^\\]")(?!:)), '\\1<q>\\2</q>'
        code
      end
    end
  end
end

MiniSyntax.register :json, MiniSyntax::Highlighter::Json

