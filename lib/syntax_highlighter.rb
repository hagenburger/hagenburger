module Haml
  module Filters
    module CommandLine
      include Base

      def render(code)
        code = Haml::Helpers.html_escape(code.strip)
        code = '<kbd>' + code.gsub(/\n/, %Q(</kbd>\n<kbd>)) + '</kbd>'
        code.gsub! %r((\#.*?)$) do |comment|
          if comment =~ %r(</q>)
            comment
          else
            comment.gsub! %r(</?(b|i|em|var|code|kbd)>), ""
            %Q(<i>#{comment}</i>)
          end
        end
        code.gsub! %r(<kbd><i>), "<i>"
        '<pre class="command-line"><code>' + Haml::Helpers.preserve(code) + '</code></pre>'
      end
    end

    module Code
      include Base

      def render(code)
        '<pre><code>' + Haml::Helpers.preserve(code) + '</code></pre>'
      end
    end

    module BashCode
      include Base
  
      def highlight(code)
        code.gsub! /\$[a-z\-_]+/, "<var>\\0</var>"
        code.gsub! /(&quot;(.*?)&quot;|'.*?')/ do |text|
          %Q(<q>#{text}</q>)
        end
        code.gsub! %r((\#.*?)$) do |comment|
          if comment.gsub(%r(<q>(.*?)</q>), "\\1") =~ %r(</q>)
            comment
          else
            comment.gsub! %r(</?(b|i|em|var|code)>), ""
            %Q(<i>#{comment}</i>)
          end
        end
        code
      end
  
      def render(code)
        code = Haml::Helpers.html_escape(code)
        code = highlight(code)
        Code.render(code)
      end
    end

    module RubyCode
      include Base
  
      def highlight(code)
        keywords = %w(BEGIN begin case class else elsif END end ensure for if in module rescue then unless until when while)
        keywords += %w(def do and not or require)
        keywords += %w(alias alias_method break next redo retry return super undef yield)
        keywords += %w(initialize new loop include extend raise attr_reader attr_writer attr_accessor attr catch throw private module_function public protected)
        code.gsub! /\b(#{keywords.join('|')})\b(?!\?)/, "<em>\\1</em>"
        code.gsub! /\b([A-Z_][a-zA-Z0-9_]+)\b/, "<b>\\1</b>"
        code.gsub! /(\#([^\{].*?)?)\n/, "<i>\\1</i>\n"
        code.gsub! /(&quot;(.*?)&quot;|'.*?'|%[qrw]\(.*?\)|%([QRW])\((.*?)\))/ do |text|
          if $2 or type = $3
            text.gsub! /#\{(.*?)\}/ do
              %Q(<code>\#{#{highlight($1)}}</code>)
            end
          end
          %Q(<q>#{text}</q>)
        end
        code.gsub! %r((\#.*?)$) do |comment|
          if comment.gsub(%r(<q>(.*?)</q>), "\\1") =~ %r(</q>)
            comment
          else
            comment.gsub! %r(</?(b|i|em|var|code)>), ""
            %Q(<i>#{comment}</i>)
          end
        end
        code.gsub!('<i><i>', '<i>')
        code
      end
  
      def render(code)
        code = Haml::Helpers.html_escape(code)
        code = highlight(code)
        Code.render(code)
      end
    end

    module JavaScriptCode
      include Base
  
      def highlight(code)
        keywords = %w(break continue do for import new this void case default else function in return typeof while comment delete export if label switch var with)
        keywords += %w(catch enum throw class extends try const finally debugger super)
        code.gsub! /\b(#{keywords.join('|')})\b/, "<em>\\1</em>"
        code.gsub! /\b([A-Z_][a-zA-Z0-9_]+)\b/, "<b>\\1</b>"
        code.gsub! /("(.*?)"|'.*?')/, "<q>\\1</q>"
        code.gsub! %r((//.*?)$) do |comment|
          if comment.gsub(%r(<q>(.*?)</q>), "\\1") =~ %r(</q>)
            comment
          else
            comment.gsub! %r(</?(b|i|em|var|code)>), ""
            %Q(<i>#{comment}</i>)
          end
        end
        code
      end
  
      def render(code)
        code = Haml::Helpers.html_escape(code)
        code = highlight(code)
        Code.render(code)
      end
    end

    module PHPCode
      include Base
  
      def highlight(code)
        keywords = %w(abstract and array as break case catch cfunction class clone const continue declare default do else elseif enddeclare endfor endforeach endif endswitch endwhile extends final for foreach function global goto if implements interface instanceof namespace new old_function or private protected public static switch throw try use var while xor)
        keywords += %w(die echo empty exit eval include include_once isset list require require_once return print unset )
        code.gsub! /\b(#{keywords.join('|')})\b/, "<em>\\1</em>"
        code.gsub! /\b([A-Z_][a-zA-Z0-9_]+)\b/, "<b>\\1</b>"
        code.gsub! /\$[a-zA-Z0-9_]+/, "<var>\\0</var>"
        code.gsub! /(&quot;(.*?)&quot;|'.*?')/ do |q|
          q.gsub! %r(<(b|i|em|var)>(.*?)</\1>), "\\2"
          if q[0..5] == '&quot;'
            q.gsub! /(\$[a-zA-Z0-9_]+)(\[(.+?)\])?/ do
              hash = $3['$'] ? %Q([<var>#{$3}</var>]) : $2 if $2
              %Q(<code><var>#{$1}</var>#{hash}</code>)
            end
          end
          %Q(<q>#{q}</q>)
        end
        code.gsub! %r((//.*?)$) do |comment|
          if comment.gsub(%r(<q>(.*?)</q>), "\\1") =~ %r(</q>)
            comment
          else
            comment.gsub! %r(</?(b|i|em|var|code)>), ""
            %Q(<i>#{comment}</i>)
          end
        end
        code
      end
  
      def render(code)
        code = Haml::Helpers.html_escape(code)
        code = highlight(code)
        Code.render(code)
      end
    end

    module HamlCode
      include Base

      def render(code)
        code = Haml::Helpers.html_escape(code)
        code.gsub! /^( *)(%[a-z\-]+)?(([\.\#][a-z\-_]+)*)((&lt;)?(&gt;)?&?)(=.+?$)?/i do
          result = $1 || ''
          tag = $2
          classes_and_id = $3
          options = $5
          ruby = $8
          result << %Q(<em>#{tag}</em>) if tag
          result << classes_and_id if classes_and_id
          result << options if options
          result << RubyCode.highlight(ruby) if ruby
          result
        end
        code.gsub! /^(  )*(-.+?)$/ do
          %Q(#{$1}#{RubyCode.highlight($2)})
        end
        Code.render(code)
      end
    end

    module ERBCode
      include Base
  
      def highlight(code)
        code.gsub /&lt;%(.*?)%&gt;/ do
          "<code>&lt;%" + RubyCode.highlight($1) + "%&gt;</code>"
        end
      end

      def render(code)
        code = Haml::Helpers.html_escape(code)
        code = highlight(code)
        Code.render(code)
      end
    end

    module YamlCode
      include Base

      def render(code)
        code = Haml::Helpers.html_escape(code)
        code.gsub! /^(  )*([a-z_-]+:)/, "\\1<b>\\2</b>"
        code.gsub! /(\#([^\{].*?)?)\n/, "<i>\\1</i>\n"
        code = ERBCode.highlight(code)
        Code.render(code)
      end
    end

    module HTMLCode
      include Base

      def highlight(code)
        code.gsub! %r((&lt;script( [a-z\-]+(=(&quot;|'|\w).*?\4)?)*&gt;)(.+?)(&lt;/script&gt;))m do
          %Q(#{$1}#{JavaScriptCode.highlight($5)}#{$6})
        end
        code.gsub! %r(&lt;([a-z\-]+[1-6]?)(( [a-z\-]+(=&quot;.*?&quot;)?)*)( /)?&gt;)m do
          tag = $1
          xml_close_tag = $5
          attributes = $2.gsub %r( ([a-z\-]+)(=(&quot;)(.*?)(&quot;))?)m do
            if %(onload onclick onmouseover onmousemove onmouseout onfocus onblur onkeyup onkeydown onkeypress).include?($1)
              %Q( <b>#{$1}</b>=#{$3}#{JavaScriptCode.highlight($4)}#{$3})
            else
              %Q( <b>#{$1}</b>#{$2})
            end
          end if $2
          %Q(<b>&lt;<em>#{tag}</em></b>#{attributes}<b>#{xml_close_tag}&gt;</b>)
        end
        code.gsub! %r(&lt;/([a-z\-]+[1-6]?)&gt;) do
          %Q(<b>&lt;/<em>#{$1}</em>&gt</b>)
        end
        code = ERBCode.highlight(code)
      end

      def render(code)
        code = Haml::Helpers.html_escape(code)
        code = highlight(code)
        Code.render(code)
      end
    end

    module CSSCode
      include Base
      
      def highlight_value(code)
        keywords = %w(left-side far-left left center-left center center-right right far-right right-side behind leftwards rightwards inherit)
        keywords << %w(scroll fixed transparent none top center bottom middle)
        keywords << %w(repeat repeat-x repeat-y no-repeat collapse separate auto both normal)
        keywords << %w(attr open-quote close-quote no-open-quote no-close-quote)
        keywords << %w(crosshair default pointer move e-resize ne-resize nw-resize n-resize se-resize sw-resize s-resize w-resize text wait help progress)
        keywords << %w(ltr rtl)
        keywords << %w(inline block list-item run-in inline-block table inline-table table-row-group table-header-group table-footer-group table-row table-column-group table-column table-cell table-caption)
        keywords << %w(below level above higher lower)
        keywords << %w(show hide italic oblique small-caps bold bolder lighter)
        keywords << %w(caption icon menu message-box small-caption status-bar)
        keywords << %w(inside outside disc circle square decimal decimal-leading-zero lower-roman upper-roman lower-greek lower-latin upper-latin armenian georgian lower-alpha upper-alpha)
        keywords << %w(invert)
        keywords << %w(visible hidden scroll)
        keywords << %w(always avoid)
        keywords << %w(x-low low medium high x-high)
        keywords << %w(static relative absolute fixed)
        keywords << %w(spell-out)
        keywords << %w(x-slow slow medium fast x-fast faster slower)
        keywords << %w(left right center justify)
        keywords << %w(underline overline line-through blink)
        keywords << %w(capitalize uppercase lowercase)
        keywords << %w(embed bidi-override)
        keywords << %w(baseline sub super top text-top middle bottom text-bottom)
        keywords << %w(silent x-soft soft medium loud x-loud)
        keywords << %w(normal pre nowrap pre-wrap pre-line)
        keywords << %w(maroon red yellow olive purple fuchsia white lime green navy blue aqua teal black silver gray orange)
        code.gsub! /\b#{keywords.join('|')}\b/, "<em>\\0</em>"
        code.gsub! /\$[a-z\-_]+/, "<var>\\0</var>"
        code.gsub! /(&quot;|')(.*?)\1/ do |q|
          q.gsub! %r(<(b|i|em|var)>(.*?)</\1>), "\\2"
          q.gsub!(/#\{(.*?)\}/) do
            %Q(<code>\#{#{highlight_value($1)}}</code>)
          end
          %Q(<q>#{q}</q>)
        end
        code
      end

      def highlight(code)
        code.gsub! %r(( *)((\$[a-z\-_]+):(.+?);|([_\*]?[a-z\-]+:)((&quot;|[^&])+?);|@import (.+?);|(([\.\#]?[a-z0-9\-_&:]+([,\s]\s*[\.\#]?[a-z0-9\-_&:]+)*))(\s*)\{(.*?\n\1)\}))im do
          intendation = $1
          if $3
            %Q(#{intendation}<var>#{$3}</var>:#{highlight_value($4)};)
          elsif $5
            %Q(#{intendation}<b>#{$5}</b>#{highlight_value($6)};)
          elsif $8
            %Q(#{intendation}<em>@import</em> #{$7};)
          elsif $10
            whitespace = $12
            rules = $13
            selector = $10.gsub(/([\.\#\b])([a-z0-9\-_]+)\b/i) do
              if $1 == '.'
                %Q(<b><i>#{$1}#{$2}</i></b>)
              elsif $1 == '#'
                %Q(<b>#{$1}#{$2}</b>)
              else
                %Q(<em>#{$2}</em>)
              end
            end
            %Q(#{intendation}#{selector}#{whitespace}{#{highlight(rules)}})
          end
        end
        code.gsub! %r((<i>)?(//.*?$|/\*.*?\*/)) do
          comment = $2
          if $1 == '<i>' or comment.gsub(%r(<q>(.*?)</q>), "\\1") =~ %r(</q>)
            comment
          else
            comment.gsub! %r(</?(b|i|em|var|code)>), ""
            %Q(<i>#{comment}</i>)
          end
        end
        code
      end

      def render(code)
        code = Haml::Helpers.html_escape(code)
        code = highlight(code)
        Code.render(code)
      end
    end
  end
end